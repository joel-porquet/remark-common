#!/bin/sh

# Safe execution
# -e: exit if subcommand fails
# -u: unset variable is an error
# -o pipefail: exit if pipeline fails
set -eu -o pipefail

function main {

    # Iterate through TTF files
    for ttf in "${@}";
    do
        ttf_name=$(fc-scan --format="%{family}" "${ttf}")
        ttf_content_base64=$(base64 -w 0 ${ttf})
        addline "@font-face {"
        addline "\tfont-family: \"${ttf_name}\";"
        addline "\tfont-weight: normal;"
        addline "\tsrc: url(data:font/ttf;base64,${ttf_content_base64}) format('truetype');"
        addline "}"
    done
}

function addline {
    echo -e "${@}"
}

main "$@"
