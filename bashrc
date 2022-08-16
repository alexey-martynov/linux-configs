# -*- mode: shell-script -*-

# Only for interactive shell
if test "$PS1" ; then
    # Make 'less' to:
    # f - open non-regular files
    # F - exit if content is shown on first screen
    # R - show ANSI color sequences
    # Q - silent mode
    # X - no init so do not clear and restore terminal
    export LESS=fFRQX

    # Set a little bity more bright colors for 'ls'
    export LSCOLORS=Exfxcxdxbxegedabagacad

    # Append history, ignore duplicates and some generic commands
    export HISTCONTROL=ignoredups
    export HISTIGNORE="&:ls:[bf]g:exit"
    shopt -s histappend

    # Tune Git integration and prompt
    export GIT_PS1_SHOWDIRTYSTATE=1
    if type __git_ps1 > /dev/null 2>&1 ; then
        PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[0;33m\]$(__git_ps1)\[\033[00m\]\$ '
    fi

    # Some aliases
    alias ls='ls -FG'
    alias lh='lh -FGlh'
fi
