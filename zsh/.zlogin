platform="$(uname)"
[[ -f "$ZDOTDIR/.zlogin-$platform" ]] && . "$ZDOTDIR/.zlogin-$platform"
[[ -f "$ZDOTDIR/.zlogin-local" ]] && . "$ZDOTDIR/.zlogin-local"
