# -*- mode: shell-script -*-

# Add local commands to PATH
if test -d "$HOME/.local/bin"
then
    export PATH="$PATH:$HOME/.local/bin"
fi

export AVM_PROMPT_RESET_COLORS='\033[00m'
export AVM_PROMPT_JOB_COUNT_COLORS="${AVM_PROMPT_JOB_COUNT_COLORS:-\033[35;1m}"
export AVM_PROMPT_GIT_BRANCH_COLORS="${AVM_PROMPT_GIT_BRANCH_COLORS:-\033[0;33m}"
export AVM_PROMPT_SUCCESS_COLORS="${AVM_PROMPT_SUCCESS_COLORS:-\033[0;32m}"
export AVM_PROMPT_FAIL_COLORS="${AVM_PROMPT_FAIL_COLORS:-\033[31;1m}"

# Only for interactive shell
case $- in
    *i*) ;;
    *) return;;
esac

# Calculate and show job count
function __avm_job_count() {
    local s='\j'
    local jobs="$(jobs | wc -l)"

    if [[ "$jobs" -ne "0" ]]
    then
        echo -e " \xE2\x86\xBB ${jobs//[[:space:]]/}"
    fi
}

# Load completions
if test -d "/usr/local/etc/bash_completion.d"
then
    for file in /usr/local/etc/bash_completion.d/*
    do
        . "$file"
    done
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Make 'less' to:
# f - open non-regular files
# F - exit if content is shown on first screen
# R - show ANSI color sequences
# Q - silent mode
# X - no init so do not clear and restore terminal
export LESS=fFRQX

# Set a little bit brighter colors for 'ls'
export LSCOLORS=Exfxcxdxbxegedabagacad

# Append history, ignore duplicates and some generic commands
export HISTCONTROL=ignoreboth
export HISTIGNORE="&:ls:[bf]g:exit"
shopt -s histappend

PS1='$(if [[ $? -eq 0 ]]; then echo -e "\[${AVM_PROMPT_SUCCESS_COLORS}\]\\xE2\\x9C\\x94"; else echo -e "\[${AVM_PROMPT_FAIL_COLORS}\]\\xE2\\x9C\\x98"; fi) \[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w'
# Add background job count
PS1="$PS1\[${AVM_PROMPT_JOB_COUNT_COLORS}\]\$(__avm_job_count)\[${AVM_PROMPT_RESET_COLORS}\]"
if type __git_ps1 > /dev/null 2>&1 ; then
    # Tune Git integration and prompt
    export GIT_PS1_SHOWDIRTYSTATE=1
    PS1="$PS1\\[${AVM_PROMPT_GIT_BRANCH_COLORS}\\]\$(__git_ps1)\\[${AVM_PROMPT_RESET_COLORS}\\]"
fi
PS1="$PS1"'\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Some aliases
alias ls='ls -FG --color=auto'
alias lh='ls -lh'

