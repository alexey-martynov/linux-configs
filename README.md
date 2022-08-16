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
  
  # `ls`
  
  # `fg`
  
  # `bg`
  
  # `exit`
  
  since no reason to store them.
  
* If Git completion is installed the prompt tuned to show current
  branch and dirty state in "yellow" (whatever it means for current
  terminal's color scheme).
  
* Aliases for `ls` added to use colors and file suffixes:
  
  # `ls` - default format
  
  # `lh` - long format with sizes in human readable form.

Usage: source `bashrc` to user's `~/.bashrc`:

```
. configs/bashrc
```
