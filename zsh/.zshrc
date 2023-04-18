# Created by newuser for 5.0.2
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
SAVEHIST=5000
HISTSIZE=2000
# share history across multiple zsh sessions
setopt SHARE_HISTORY
# append to history
setopt APPEND_HISTORY
# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST
# do not store duplications
setopt HIST_IGNORE_DUPS
#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS

setopt combiningchars
setopt prompt_subst

autoload -Uz compinit && compinit
autoload -Uz vcs_info && vcs_info

unsetopt AUTO_MENU

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' formats '%b %u%c'
zstyle ':vcs_info:*' actionformats '%b|%a %u%c'

zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' ignore-parents parent pwd .. directory
zstyle ':completion:*' insert-unambiguous true
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' menu select=long-list select=1
zstyle ':completion:*' original true
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' use-compctl true
#zstyle :compinstall filename '/root/.zshrc'

autoload -Uz compinit
compinit

# The following prompt is derived from Oh-My-Zsh's Agnoster theme
typeset -aHg AGNOSTER_PROMPT_SEGMENTS
AGNOSTER_PROMPT_SEGMENTS=(
    prompt_status
    prompt_context
    #    prompt_virtualenv
    prompt_dir
    prompt_git
    prompt_end
)

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'
if [[ -z "$PRIMARY_FG" ]]; then
    PRIMARY_FG=black
fi

# Characters
SEGMENT_SEPARATOR="\ue0b0"
PLUSMINUS="\u00b1"
BRANCH="\ue0a0"
DETACHED="\u27a6"
CROSS="\u2718"
CHECK="\u2714"
LIGHTNING="\u26a1"
GEAR="\u2699"

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
    local bg fg
    [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
    [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
    if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
        print -n "%{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%}"
    else
        print -n "%{$bg%}%{$fg%}"
    fi
    CURRENT_BG=$1
    [[ -n $3 ]] && print -n $3
}

# End the prompt, closing any open segments
prompt_end() {
    if [[ -n $CURRENT_BG ]]; then
        print -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
    else
        print -n "%{%k%}"
    fi
    print -n "%{%f%}"
    CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
    local user=`whoami`

    if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CONNECTION" ]]; then
        prompt_segment $PRIMARY_FG default "%{%(!.%F{yellow}.)%}$user@%m "
    fi
}

# Git: branch/detached head, dirty status
prompt_git() {
    local color ref
    is_dirty() {
        test -n "$(git status --porcelain --ignore-submodules)"
    }
    ref="$vcs_info_msg_0_"
    if [[ -n "$ref" ]]; then
        if is_dirty; then
            color=yellow
        else
            color=green
        fi
        if git symbolic-ref -q HEAD >/dev/null
        then
            ref="$BRANCH $ref"
        else
            ref="$DETACHED ${ref/.../}"
        fi
        prompt_segment $color $PRIMARY_FG " ${ref%% } "
    fi
}

# Dir: current working directory
prompt_dir() {
    #prompt_segment blue $PRIMARY_FG ' %~ '
    # Invert text according to Putty colors
    prompt_segment blue white ' %~ '
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
    local symbols
    symbols=()
    if [[ $RETVAL -eq 0 ]]
    then
        symbols+="%{%F{green}%}$CHECK"
    else
        symbols+="%{%F{red}%}$CROSS"
    fi
    [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}$LIGHTNING"
    [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}$GEAR"

    [[ -n "$symbols" ]] && prompt_segment $PRIMARY_FG default "$symbols "
}

# Display current virtual environment
prompt_virtualenv() {
    if [[ -n $VIRTUAL_ENV ]]; then
        color=cyan
        prompt_segment $color $PRIMARY_FG
        print -Pn " $(basename $VIRTUAL_ENV) "
    fi
}

## Main prompt
prompt_agnoster_main() {
    RETVAL=$?
    CURRENT_BG='NONE'
    for prompt_segment in "${AGNOSTER_PROMPT_SEGMENTS[@]}"; do
        [[ -n $prompt_segment ]] && $prompt_segment
    done
    echo ' '
}

[[ -z $precmd_functions ]] && precmd_functions=()
[[ -z $preexec_functions ]] && preexec_functions=()

precmd_prompt() {
    vcs_info
    PROMPT='%{%f%b%k%}$(prompt_agnoster_main)'
    if [[ -n "$PROMPT_COMMAND" ]]
    then
        eval "$PROMPT_COMMAND"
    fi
}
precmd_functions+=precmd_prompt

precmd_title() {

    local title=

    if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CONNECTION" ]]
    then
        title=$(print -P "$USER@%m: %~")
    else
        title=$(print -P "%~")
    fi
    builtin echo -ne "\033]0;$title\007"
}
precmd_functions+=precmd_title

preexec_title() {
    local title=

    if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CONNECTION" ]]
    then
        title=$(print -P "$USER@%m: %~ - ${1[(w)1]}")
    else
        local cmd="${1[(w)1]}"

        if [[ "$cmd" = "ssh" ]]
        then
            local skip_next=no
            local user=
            local user_next=no

            for arg in "${(z)1}"
            do
                case "$arg" in

                    -[BbcDEeFIiJLmOopQRSWw])
                        skip_next=yes
                        ;;

                    -l)
                        user_next=yes
                        ;;

                    -*)
                        ;;

                    ssh)
                       ;;

                    *)
                        if [[ "$user_next" = yes ]]
                        then
                            user="$arg@"
                            user_next=no
                        elif [[ "$skip_next" = no ]]
                        then
                            title="SSH: $user$arg"
                            break
                        fi
                        skip_next=no
                    ;;
                esac
            done
        else
            title=$(print -P "%~ - ${cmd}")
        fi
    fi
    builtin echo -ne "\033]0;$title\007"
}
preexec_functions+=preexec_title

prompt_opts=(cr subst percent)

# Global aliases
alias ls='ls -FG --color=auto'
alias lh='ls -lh'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Add XDG bin to PATH if exists
# Duplicated here to avoid overrides for interactive shells
if [[ -d "$HOME/.local/bin" ]]
then
    path=("$HOME/.local/bin" $path)
    export PATH
fi

# Add more key bindings to workaround SSH terminal issues
if [[ -n "$SSH_CONNECTION" ]]
then
    bindkey "^[[7~" beginning-of-line
    bindkey "^[[8~" end-of-line
fi

# Load per-platform and local files
platform="$(uname)"
hostname="$(hostname -s)"
[[ -f "$ZDOTDIR/.zshrc-$platform" ]] && . "$ZDOTDIR/.zshrc-$platform" || true
[[ -f "$ZDOTDIR/.zshrc-$hostname" ]] && . "$ZDOTDIR/.zshrc-$hostname" || true
[[ -f "$ZDOTDIR/.zshrc-local" ]] && . "$ZDOTDIR/.zshrc-local" || true
