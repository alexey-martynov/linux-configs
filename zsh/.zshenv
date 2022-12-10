# Make 'less' to:
# f - open non-regular files
# F - exit if content is shown on first screen
# R - show ANSI color sequences
# Q - silent mode
# X - no init so do not clear and restore terminal
export LESS=fFRQX

# Set a little bit brighter colors for 'ls'
export LSCOLORS=Exfxcxdxbxegedabagacad

# Add XDG bin to PATH if exists
# Duplicated here for non-interactive shells
if [[ -d "$HOME/.local/bin" ]]
then
    path=("$HOME/.local/bin" $path)
    export PATH
fi

# Load per-platform and local files
platform="$(uname)"
[[ -f "$ZDOTDIR/.zshenv-$platform" ]] && . "$ZDOTDIR/.zshenv-$platform"
[[ -f "$ZDOTDIR/.zshenv-local" ]] && . "$ZDOTDIR/.zshenv-local"
