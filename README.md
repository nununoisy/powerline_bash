## powerline_bash

I mean, it's pretty self explanatory. 

## Installation

Put the powerline.sh file somewhere safe. Cherish it.

Then put this in your `.bashrc`:
```bash
PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
function _update_ps1() {
    PS1="$(/path/to/powerline_bash/powerline.sh $?)"
}
```