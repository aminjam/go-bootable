#!/bin/bash

orphan_deps() {
    local imports=$(cd $DIR && go list -f '{{join .Imports " "}}' ./... | grep -v vendor)
    local vendored_deps=" $(cd $DIR && gvt list | cut -d ' ' -f 1 | sort ) "
    local orphan=""
    for dep in ${vendored_deps}; do
        if [[ "${imports}" != *"${dep}"* ]]; then
            local orphan+=$dep" "
        fi
    done
    if [[ "${orphan}" != "" ]]; then
        echo "Consider deleting unused dependencies:"
        echo "gvt delete ${orphan}" >&2
        exit 1
    fi
}

main() {
    set +e
    set -o pipefail

    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
    DIR="$( cd -P "$( dirname "$SOURCE" )/.." && pwd )"

    #parse args
    ACTION=$1

    case $1 in
        orphan) orphan_deps;;
        *) echo "Action ($1) not found." >&2
    esac
}

main "$@"
