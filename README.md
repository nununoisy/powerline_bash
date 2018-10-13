## powerline_bash

I mean, it's pretty self explanatory.

A powerful powerline PS1 generator written for and in `bash`.

Now with rcaloras' [bash-preexec](https://github.com/rcaloras/bash-preexec)!

## Installation

First, get the dependencies from your package manager:
`awk`, `sed`, `cut`, `tr`, `tput`, `sysstat`, `git` version 1.7+, `bash` version 4

You need to download a patched font for powerline and set up your terminal to use it.

There are a bunch provided [here](https://github.com/powerline/fonts).

Put the powerline.sh file somewhere safe. Make sure it's easy to remember. Place the config file at `~/.config/powerline.cfg`.

Then put this in your `.bashrc`:
```bash
POWERLINEDIR=/path/to/powerline
ln -sf "${POWERLINEDIR}/powerline.cfg" ~/.config/powerline.cfg

source "${POWERLINEDIR}/bash-preexec/bash-preexec.sh"

preexec() {
    ${POWERLINEDIR}/powerline.sh clearTitleBar
}

precmd() {   
    PS1="$(${POWERLINEDIR}/powerline.sh draw $? '')"
}
```