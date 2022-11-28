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

Xkb Russian Macintosh Layout
----------------------------

The default Russian keyboard layouts in Linux have the following
issues:

* They don't allow to enter most of symbols used as good typography
  practice, for example, dashes or ellipsis.
  
* The Macintosh layout allows to enter Rouble sign but it is placed to
  button different from Mac layout.

The `xkb/ru-mac.patch` fixes theses issues by moving Rouble sign to
`RAlt-8` and adding more symbols.

Differences in the updated layout:

* it is still incomplete because of amount of required work and

* some Greek symbols requires often but unavailable from US and RU
  layouts so the added to Russian layout to level 3: Greek small
  lambda (on the 'l' key) and Greek small epsilon (on the 'e' key).

To install please execute

```
patch -p0 < ~/configs/ru-mac.patch
```

in the directory with X11 Xkb layouts (usually
`/usr/share/X11/Xkb/symbols`).
