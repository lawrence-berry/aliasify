#!/bin/bash -
set -o nounset                                  # Treat unset variables as an error

. $HOME/Projects/util/bash_helpers/bin/helpers.sh

if [[ $# -eq 0 ]]; then
  echo "Please include the name of the script to alias e.g.:"
  echo "  aliasify startup.sh"
  echo ""
  echo "Script should be in current working directory and"
  echo "alias will have all punctuation and file extensions removed."
  exit 1
fi

clean_for_path $1
# NB: periods don't seem to be being passed through as arguments, hacky fix
# - assumes 'sh' ending is actually '.sh'
ALIAS_NAME=`sed 's/sh$/.sh/' <<<$RESULT`
# then remove the extension
ALIAS_NAME=${ALIAS_NAME%.*}

ALIAS_PATH="${PWD}/${1}"
ALIAS_SNIPPET="alias ${ALIAS_NAME}='eval ${ALIAS_PATH} \$argv'"
ALIAS_CONFIG_PATH="${HOME}/Projects/util/terminal_aliases/fish/aliases.sh"

fileContains "${ALIAS_CONFIG_PATH}" "${ALIAS_NAME}"

if [ $? -eq "0" ]; then
  echo "${ALIAS_NAME} found in ${ALIAS_CONFIG_PATH}, cannot proceed. Exiting."
  exit 1
else
  appendIfNotFoundIn "${ALIAS_CONFIG_PATH}" "${ALIAS_SNIPPET}"
  echo "${ALIAS_NAME} added as Fish alias."
fi

# Fix absolute paths to $HOME
# TODO: Needs work directory replacement
sed -i '' "s#/Users/route#/\$HOME#g" "${ALIAS_CONFIG_PATH}"
