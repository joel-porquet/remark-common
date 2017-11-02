#!/bin/sh

## Safe execution
# -e: exit if subcommand fails
# -u: unset variable is an error
# -o pipefail: exit if pipeline fails
set -eu -o pipefail

## Add TTF file
function include_ttf {

    # Determine font family
    ttf_family=$(fc-scan --format="%{family}" "${1}")

    # Determine font weight
    case "$(fc-scan --format="%{weight}" "${1}")" in
        "80") ttf_weight="normal";;
        "200") ttf_weight="bold";;
        *) echo "Warning: font weight not supported for font ${1}" > 2;
           return;;
    esac

    # Determine font slant
    case "$(fc-scan --format="%{slant}" "${1}")" in
        "0") ttf_style="normal";;
        "100") ttf_style="italic";;
        *) echo "Warning: font slant not supported for font ${1}" > 2;
           return;;
    esac

    # Transform TTF content into base64
    ttf_content_base64=$(base64 -w 0 ${1})

    # Write into CSS
    addline "@font-face {"
    addline "\tfont-family: \"${ttf_family}\";"
    addline "\tfont-weight: \"${ttf_weight}\";"
    addline "\tfont-style: \"${ttf_style}\";"
    addline "\tsrc: url(data:font/ttf;base64,${ttf_content_base64}) format('truetype');"
    addline "}"
}

function main {

    # Iterate through font files
    for f in "${@}";
    do
        case "${f##*.}" in
            "ttf") include_ttf "${f}" ;;
            *) echo "Warning: ${f} not supported" > 2 ;;
        esac
    done
}

function addline {
    echo -e "${@}"
}

main "$@"
