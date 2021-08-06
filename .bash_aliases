#!/bin/bash

source /home/jkordani/.rr_aliases

SSH_ENV="/home/jkordani/.ssh/agent-environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi


alias sudo="sudo -E"

alias checkinstall="sudo checkinstall --maintainer=jkordani@roboticresearch.com -D"

alias kinetic="source /opt/ros/kinetic/setup.bash"

alias srcalias='source ~/.bashrc; source ~/.bash_aliases; source ~/.rr_aliases'

#git dotfiles
alias _config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

alias evosource="source ~/Code/evo/evo-play/bin/activate"

alias sshh="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

config () {
    pushd "${HOME}" >/dev/null || return
    _config "$@"
    popd >/dev/null || return
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
