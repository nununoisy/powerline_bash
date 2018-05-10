## powerline_bash

I mean, it's pretty self explanatory.

A powerful powerline PS1 generator witten for and in `bash`.

## Installation

You need to download a patched font for powerline and set up your terminal to use it.



There are a bunch provided [here](https://github.com/powerline/fonts).

Put the powerline.sh file somewhere safe. Cherish it.

Then put this in your `.bashrc`:
```bash
PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
function _update_ps1() {
    PS1="$(/path/to/powerline_bash/powerline.sh $?)"
}
```
