platform="$(uname)"
hostname="$(hostname -s)"
[[ -f "$ZDOTDIR/.zlogin-$platform" ]] && . "$ZDOTDIR/.zlogin-$platform" || true
[[ -f "$ZDOTDIR/.zlogin-$hostname" ]] && . "$ZDOTDIR/.zlogin-$hostname" || true
[[ -f "$ZDOTDIR/.zlogin-local" ]] && . "$ZDOTDIR/.zlogin-local" || true
