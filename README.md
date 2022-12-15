Linux Configuration Files
=========================

This repository contains various configuration files for Linux
environment.

Rxvt Unicode
------------

Directory: `rxvt-unicode`

The default Rxvt Unicode settings tuned in files:

1. `Xresources-common`

   * Scroll bar placed on right side of window.
   * Scroll buffer increased to 10 000 lines.

2. `Xresources-twilight`

   Twilight color scheme.

Usage: include corresponding file to user's `~/.Xresources` file

```
#include "configs/rxvt-unicode/Xresources-common"
```

Please note that this requires C Preprocessor. The comments in file
are started from exclamation mark (`!`).

Bash Configuration
------------------

The file `bashrc` contains the following tweaks for Bash configuration
which are applied for interactive shell only:

* `less` command tuned to show colors, be silent, exit if content to
  show fits single screen and skip `ncurses` initialization and
  deinitialization (this preserves `less` output after exit).

* `ls` colors tuned to be a little bit brighter for Twilight terminal
  color scheme.

* The history tuned to avoid storing duplicates, always append history
  and ignore common commands:

    - `ls`

    - `fg`

    - `bg`

    - `exit`

  since no reason to store them.

* If Git completion is installed the prompt tuned to show current
  branch and dirty state in "yellow" (whatever it means for current
  terminal's color scheme).

* Aliases for `ls` added to use colors and file suffixes:

    - `ls` - default format

    - `lh` - long format with sizes in human readable form.

Bash prompt parts colors can be overridden with the following variables:

* `AVM_PROMPT_JOB_COUNT_COLORS`

  Colors for job count information (magenta by default).

* `AVM_PROMPT_GIT_BRANCH_COLORS`

  Colors for Git branch and status (yellow by default).

* `AVM_PROMPT_SUCCESS_COLORS`

  Colors for succeeded last command (green by default).

* `AVM_PROMPT_FAIL_COLORS`

  Colors for failed last command (red by default).

Usage: source `bashrc` to user's `~/.bashrc`:

```
. configs/bashrc
```

Xkb Layouts
-----------

The default Russian keyboard layouts in Linux have the following
issues:

* They don't allow to enter most of symbols used as good typography
  practice, for example, dashes or ellipsis.
  
* The Macintosh layout allows to enter Rouble sign but it is placed to
  button different from Mac layout.

Additional Xkb layouts placed to `xkb` subdirectory. The provide:

* Updated layout 'Russian (Macintosh)' to include more symbols for true
  MacOS layout.
  
* Additional layout 'Russian (Macintosh, Alexey Martynov)' which
  places the following characters (letters in English):
  
  - 'λ' on 'RAlt-l'
  - 'ε' on 'RAlt-e'
  - 'combining acute' on 'RAlt-Shift-e', used to show stress in words
  - 'non-breaking space' on 'RAlt-Space'
  - 'zero-width joiner' on 'RAlt-Shift-Space'
  
* Additional layout 'US (Macintosh, Alexey Martynov) providing:

  - 'non-breaking space' on 'RAlt-Space'
  - 'zero-width joiner' on 'RAlt-Shift-Space'
  - 'combining acute' on 'RAlt-Shift-e' (instead of simple acute),
    used to show stress in words

To install please execute

```
patch -p0 < ~/configs/ru-mac.patch
```

or 

```
patch -p0 < ~/configs/us-mac.patch
```

in the directory with X11 Xkb layouts (usually
`/usr/share/X11/Xkb/symbols`).

To get new layouts available the XSLT tranformations added to patch
`evdev.xml`. Please run one of the commands to apply them:

``` shellsession
# cp evdev.xml evdev.xml.orig && xsltproc ~/configs/xkb/install-ru.xslt evdev.xml.orig > evdev.xml
# cp evdev.xml evdev.xml.orig && xsltproc ~/configs/xkb/install-us.xslt evdev.xml.orig > evdev.xml
# cp evdev.xml evdev.xml.orig && xsltproc ~/configs/xkb/install-ru.xslt evdev.xml.orig | xsltproc ~/configs/xkb/install-us.xslt - > evdev.xml
```

Zsh Configuration
-----------------

To use this configuration files the following should be written to
`.zshenv` (assuming that repository is checked out to
`$HOME/configs`:

```
export ZDOTDIR="$HOME/configs/zsh"

. "$ZDOTDIR/.zshenv"
```

To properly show Powerline segments in prompt the fonts from
https://github.com/powerline/fonts should be installed and selected
for terminal application.

All platform-dependent configuration should go to files with suffix
`-$(uname)`. For example, MacOS (actually, Darwin) environment goes to
`.zshenv-Darwin`.
