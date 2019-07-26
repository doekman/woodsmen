#!/usr/bin/env bash

# Unofficial Bash Strict Mode (nog geen ervaring opgedaan met Debian)
#set -euo pipefail
#IFS=$'\n\t' #Het "find"-commando heeft problemen met deze IFS...

function abspath { 
    if [[ -d "$1" ]]; then
        pushd "$1" > /dev/null || exit 1;
        pwd;
        popd > /dev/null  || exit 1;
    else
        if [[ -e $1 ]]; then
            pushd "$(dirname "$1")" > /dev/null || exit 1;
            echo "$(pwd)/$(basename "$1")";
            popd > /dev/null  || exit 1;
        else
            echo "$1" does not exist! 1>&2;
            return 127;
        fi;
    fi
}

function usage {
  if [[ $# -gt 1 ]] ; then
    echo -e ""
    echo -e "$2"
  fi
  echo -e ""
  echo -e "Usage: ./$(basename "$1") command [options]"
  echo -e ""
  echo -e "  commands (pick one):"
  echo -e "    clean              Remove all gz-archive and sha1-fingerprint files"
  echo -e "    install            Make gz-archive and sha1-fingerprint files of all applicable files"
  echo -e "    clean-install      Performs a clean first, then an install"
  echo -e "    install-gz         Make gz-archive of all compressable files"
  echo -e "    install-sha1       Make sha1-files of all relevant files"
  echo -e "    clean-gz           Remove all gz-archive files"
  echo -e "    clean-sha1         Remove all sha1-fingerprint files"
  echo -e "    clean-install-gz   clean install, gz-files only"
  echo -e "    clean-install-sha1 clean install, sha1-files only"
  echo -e ""
  echo -e "  options (optional):"
  echo -e "    -h, -? or --help   show this usage page and exists"
  echo -e "    -q or --quiet      keep the output minimal"
  echo -e "    -v or --verbose    provide more hints as to what is happening"
  echo -e "    -dr or --dry-run   don't actually perform stuff"
  echo -e ""
  exit 1
}

if [[ $(uname) == "Linux" ]]; then
	#Debian
	FIND_PREFIX="find"
	FIND_INFIX="-regextype posix-extended"
elif [[ $(uname) == "Darwin" ]]; then
	#OS X
	FIND_PREFIX="find -E"
	FIND_INFIX=""
else
	echo "Unkown system $(uname)"
	exit 1
fi


scriptname=$(basename "$0")
script_dir=$(dirname "$0")
static_folder=$(abspath "$script_dir/wwwroot")

gz_include_files='^.*[.](html?|js|map|css|eot|ttf|woff2?|svg)$'
sha1_exclude_files='^.*[.](sha1|gz|DS_Store)$'

clean_gz=0; clean_sha1=0; install_gz=0; install_sha1=0;

shopt -s nocasematch
case ${1:-} in
  clean-install)      clean_gz=1; clean_sha1=1; install_gz=1; install_sha1=1;;
  clean-install-gz)   clean_gz=1; clean_sha1=0; install_gz=1; install_sha1=0;;
  clean-install-sha1) clean_gz=0; clean_sha1=1; install_gz=0; install_sha1=1;;
  install)                                      install_gz=1; install_sha1=1;;
  install-gz)                                   install_gz=1;;
  install-sha1)                                               install_sha1=1;;
  clean)              clean_gz=1; clean_sha1=1;;
  clean-gz)           clean_gz=1;;
  clean-sha1)                     clean_sha1=1;;
  *) usage "$scriptname";;
esac
shift

((verbose=1))
((dryrun=0))
while (( $# > 0 )) ; do
  case $1 in
    -q | --quiet) ((verbose=0));;
    -v | --verbose) ((verbose=2));;
    -dr | --dry-run) ((dryrun=1));;
    -h | -\? | --help) usage "$scriptname";;
    *) usage "$scriptname";;
  esac
  shift
done

if (( verbose >= 1 )) ; then
  echo -e "current date:\t$(date -u)"
  echo -e "scriptname:\t${scriptname}"
  echo -e "options:\tverbose:${verbose}; dryrun:${dryrun}"
  echo -e "commands:"
  echo -e "- clean:\tgz=$clean_gz, sha1=$clean_sha1"
  echo -e "- install:\tgz=$install_gz, sha1=$install_sha1"
fi


cd "$static_folder" || exit 1

if [[ $clean_gz == "1" ]]; then
	((verbose >= 1 )) && echo "Cleaning *.gz files"
	((verbose >= 1 )) && echo "-------------------"
	for static_gz_item in $(${FIND_PREFIX} . ${FIND_INFIX} -type f -iregex "^.*[.]gz$"); do
		org_name=${static_gz_item:0:${#static_gz_item}-3}
		if [[ $org_name =~  $gz_include_files ]]; then
			((verbose >= 1 )) && echo "x remove: $static_gz_item ($org_name)"
			((dryrun == 0 )) && rm -f "$static_gz_item"
		fi
	done
fi

if [[ $clean_sha1 == "1" ]]; then
	((verbose >= 1 )) && echo "Cleaning *.sha1 files"
	((verbose >= 1 )) && echo "---------------------"
	for digest_item in $(${FIND_PREFIX} . ${FIND_INFIX} -type f -regex "^.*[.]sha1$"); do
		((verbose >= 1 )) && echo "x remove: $digest_item (sha1 file)"
		((dryrun == 0 )) && rm -f "$digest_item"
	done
fi

if [[ $install_gz == "1" ]]; then
	((verbose >= 1 )) && echo "Creating *.gz for selected static content"
	((verbose >= 1 )) && echo "-----------------------------------------"
	for static_item in $(${FIND_PREFIX} . ${FIND_INFIX} -type f -iregex "$gz_include_files"); do
		if [[ $static_item -nt $static_item.gz ]]; then
			if [[ -f $static_item.gz ]]; then
				((verbose >= 1 )) && echo "x remove: $static_item.gz"
				((dryrun == 0 )) && rm -f "$static_item.gz"
			fi
			((verbose >= 1 )) && echo "- create : $static_item.gz"
			((dryrun == 0 )) && gzip --keep "$static_item"
		else
			((verbose >= 2 )) && echo "= skip  : ${static_item}"
		fi
	done
fi

if [[ $install_sha1 == "1" ]]; then
	((verbose >= 1 )) && echo "Creating *.sha1 for selected static content"
	((verbose >= 1 )) && echo "-------------------------------------------"
	for static_item in $(${FIND_PREFIX} . ${FIND_INFIX} -type f -not -regex "$sha1_exclude_files"); do
		file_path="$(dirname "$static_item")"
		digest_file="$file_path/$(basename "$static_item").sha1"
		if [[ $static_item -nt $digest_file ]]; then
			((verbose >= 1 )) && echo "- create : $digest_file"
			((dryrun == 0 )) && echo -n "$(openssl sha1 "$static_item" | sed 's/^.*= //')" > "$digest_file"
		else
			((verbose >= 2 )) && echo "= skip  : ${static_item}"
		fi
	done
fi
