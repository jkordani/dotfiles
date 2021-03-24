#!/bin/bash

RESTORE_DIR=${PWD}
CURRENT_DIR=${PWD}
PREV_DIR=${OLDPWD}

complete -F _sauce sauce

sauce () {
    basedir=$(findenv)
    file="${basedir}$1"
    shift
    source "${file}" $@
}

_sauce(){
    maybe=$(findenv)

    if [[ "${maybe}" == "FAILURE" ]]; then
        return 1
    else
        cur="${COMP_WORDS[1]}"
        words=$(find ${maybe} -maxdepth 1 -type f -name "env*" -printf "%f\n")
        COMPREPLY=( $(compgen -W "${words}" -- "${cur}") )
    fi
}


restoreDirectory() {
    cd "${RESTORE_DIR}"
    OLDPWD="$PREV_DIR"
}


findenv() {
    CURRENT_DIR=$(dirname $(pwd))

    if [[ "${CURRENT_DIR}" == "/" ]]; then
        echo "FAILURE"
        restoreDirectory
        return 1
    fi

    maybe=$(find . -maxdepth 1 -type d -name env)

    #Where do these dirs go?
    #they go up....
    if [[ -z "${maybe}" ]]; then
        cd .. #>& /dev/null
        findenv
    else
        echo "${PWD}/env/"
        return 1
    fi
}
