#!/bin/bash

source /home/jkordani/.rr_aliases

alias udacity="docker run -e DISPLAY -e QT_X11_NO_MITSHM -v ~/.Xauthority:/home/user/.Xauthority --net host -v ~/Code/udacity/rse/:/home/jkordani/Code/udacity/rse/ -u user -it --rm udacity:latest /bin/bash"

# SSH_ENV="/home/jkordani/.ssh/agent-environment"

# the below wasn't necessary until recently, and maybe it was transient... lets find out

# function start_agent {
#     echo "Initialising new SSH agent..."
#     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "/home/jkordani/.ssh/agent-environment"
#     echo succeeded
#     chmod 600 "/home/jkordani/.ssh/agent-environment"
#     source "/home/jkordani/.ssh/agent-environment" > /dev/null
#     /usr/bin/ssh-add;
# }

# # Source SSH settings, if applicable

# if [ -f "/home/jkordani/.ssh/agent-environment" ]; then
#     source "/home/jkordani/.ssh/agent-environment" > /dev/null
#     #ps ${SSH_AGENT_PID} doesn't work under cywgin
#     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
#         start_agent;
#     }
# else
#     start_agent;
# fi


alias sudo="sudo -E"

alias checkinstall="sudo checkinstall --maintainer=jkordani@roboticresearch.com -D --strip=no --stripso=no"

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

function newemacs () {
    if (( "$#" >= "2" )); then
        nohup emacsclient -a "" -c -s "$1" "${@:2}" &
    else
        nohup emacsclient -a "" -c -s "$1" . &
    fi
}

function mkcd () {
    mkdir -p "$1"
    pushd "$1" || return
}
typeset -xf mkcd

function localprojects () {
    cd ~/quicklisp/local-projects/
}
typeset -xf localprojects

alias bin2hex="hexdump -ve '1/1 \"%.2x\"'"

#makes my qt4 app recordable in rr replay tool.  But might change the behavior?
export QT_X11_NO_MITSHM=1

source /opt/ros/kinetic/setup.bash

