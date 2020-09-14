#!/bin/bash

## Safe execution
# -e: exit if subcommand fails
# -u: unset variable is an error
# -o pipefail: exit if pipeline fails
set -eu -o pipefail

## Add TTF description to CSS
include_ttf() {

    # Transform TTF content into base64
    ttf_content_base64=$(base64 -w 0 "${1}")

    # Write into CSS
    addline "@font-face {"
    addline "\\tfont-family: \"${ttf_family}\";"
    addline "\\tfont-weight: ${ttf_weight};"
    addline "\\tfont-style: ${ttf_style};"
    addline "\\tsrc: url(data:font/ttf;charset=utf-8;base64,${ttf_content_base64}) format('truetype');"
    addline "}"
}

## Add WOFF2 description to CSS
include_woff2() {

    # Transform TTF into woff2
    woff2_compress "${1}" > /dev/null 2>&1

    local woff2_file="$(dirname "${1}")/$(basename "${1}" .ttf).woff2"

    # Transform TTF content into base64
    woff2_content_base64=$(base64 -w 0 "${woff2_file}")

    # Delete temporary woff2 file
    rm "${woff2_file}"

    # Write into CSS
    addline "@font-face {"
    addline "\\tfont-family: \"${ttf_family}\";"
    addline "\\tfont-weight: ${ttf_weight};"
    addline "\\tfont-style: ${ttf_style};"
    addline "\\tsrc: url(data:font/woff2;charset=utf-8;base64,${woff2_content_base64}) format('woff2');"
    addline "}"
}

## Add font
include_font() {

    # Determine font family
    ttf_family=$(fc-scan --format="%{family}" "${1}")

    # Determine font weight
    case "$(fc-scan --format="%{weight}" "${1}")" in
        "80") ttf_weight="normal" ;;
        "200") ttf_weight="bold" ;;
        *) warning "font weight not supported for font ${1}" ;
           return;;
    esac

    # Determine font slant
    case "$(fc-scan --format="%{slant}" "${1}")" in
        "0") ttf_style="normal" ;;
        "100") ttf_style="italic" ;;
        *) warning "font slant not supported for font ${1}" ;
           return;;
    esac

    if [ -x "$(command -v woff2_compress)" ]; then
        include_woff2 "${1}"
    else
        include_ttf "${1}"
    fi
}

main() {

    # Iterate through font files
    for f in "${@}";
    do
        case "${f##*.}" in
            "ttf") include_font "${f}" ;;
            *) warning "${f} not supported" ;;
        esac
    done
}

warning() {
    echo "Warning: ${*}" 1>&2
}

addline() {
    # shellcheck disable=SC2059
    printf "${@}\\n"
}

main "$@"
