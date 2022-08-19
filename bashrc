# -*- mode: shell-script -*-

# Only for interactive shell
case $- in
    *i*) ;;
      *) return;;
esac

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
export HISTCONTROL=ignoredups
export HISTIGNORE="&:ls:[bf]g:exit"
shopt -s histappend

if type __git_ps1 > /dev/null 2>&1 ; then
    # Tune Git integration and prompt
    export GIT_PS1_SHOWDIRTYSTATE=1
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[0;33m\]$(__git_ps1)\[\033[00m\]\$ '
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Some aliases
alias ls='ls -FG --color=auto'
alias lh='ls -lh'

