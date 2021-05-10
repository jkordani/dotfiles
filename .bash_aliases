#!/bin/bash

source ~/.rr_aliases

alias checkinstall="sudo checkinstall"

alias kinetic="source /opt/ros/kinetic/setup.bash"

alias srcalias='source ~/.bashrc; source ~/.bash_aliases; source ~/.rr_aliases'

#git dotfiles
alias _config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

alias evosource="source ~/Code/evo/evo-play/bin/activate"

alias sshh="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

config () {
    pushd $HOME >/dev/null
    _config $@
    popd >/dev/null
}

export EDITOR='emacsclient -a "" -c $@'


function emacs() {
    if [[ "$1" == "-nw" ]] ; then # if terminal, open "normal" mode
        command emacs "$@"
    elif (( "$#" >= "1" )); then
        nohup emacsclient -a "" -c "$@" & # c means always make new gui window
    else
        nohup emacsclient -a "" -c . &
    fi
}

function newemacsc () {
    if (( "$#" >= "2" )); then
        nohup emacsclient -a "" -c -s "$1" "${@:2}" &
    else
        nohup emacsclient -a "" -c -s "$1" . &
    fi
}

source /opt/ros/kinetic/setup.bash
