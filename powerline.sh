#!/bin/bash

#grab the config file
source ${HOME}/.config/powerline.cfg

#now with bash-preexec!!

#set up some variables guys
USER="$(whoami)"
DIR="$(pwd)"
MODE="$1"
PSC=$2
PROCESS=${3//"_update_ps1"/''}
PROCESS=${PROCESS//"unset"/''}

if [[ $DIR != '/' ]]; then
	NDIR=${DIR//"$HOME"/'/~'}
	NDIR="$(echo $NDIR | cut -c 2-)"
	NDIR=${NDIR//\//"\x20${ARROW}\x20"}
else
	NDIR=""
fi

NROOTSLASH="/\x20${ARROW}\x20"
if [[ "${PWD##${HOME}}" != "${PWD}" ]]; then
    NROOTSLASH=""
fi

if [[ "$DIR" == '/' ]]; then
	NROOTSLASH="/"
fi

#nice function (thx Dennis Williamson)
cursorPosition() {
	exec < /dev/tty
	oldstty=$(stty -g)
	stty raw -echo min 0
	# on my system, the following line can be replaced by the line below it
	echo -en "\033[6n" > /dev/tty
	# tput u7 > /dev/tty    # when TERM=xterm (and relatives)
	IFS=';' read -r -d R -a pos
	stty $oldstty
	# change from one-based to zero based so they work with: tput cup $row $col
	row=$((${pos[0]:2} - 1))    # strip off the esc-[
	col=$((${pos[1]} - 1))
	echo "${row};${col}"
}

drawTitleBar() {
	oldCursorPosition=$(cursorPosition)
	if [[ $oldCursorPosition == "$(($(tput lines) - 1));0" ]]; then
		clearTitleBar
		printf '\n'
		oldCursorPosition="$(($(tput lines) - 2));0"
	fi
	printf "\[\e[48;5;${DIRBG}m\e[%s;0H\]" "$(tput lines)"
	printf '%*s' "${COLUMNS:-$(tput cols)}" ''
	datenow=$(date +'%A, %B %d, %Y')
	timenow=$(date +'%H:%M')
	printf "\[\e[%s;0H\e[48;5;${USRBG}m\e[38;5;${USRFG}m\]\x20${datenow}\x20\[\e[48;5;${DIRBG}m\e[38;5;${USRBG}m\]${SLDARROW}\x20\[\e[38;5;${DIRFG}m\]${timenow}" "$(tput lines)"
	#only if they have a battery
	batfile="/sys/class/power_supply/BAT${BATNO}/uevent"
	#testing
	#batfile="$HOME/batfile"
	if [[ -f $batfile ]]; then
		batterylevel=$(cat $batfile | grep -wE "POWER_SUPPLY_CAPACITY" | cut -f 2 -d '=')
		rawchrgrstatus=$(cat $batfile | grep -wE "POWER_SUPPLY_STATUS" | cut -f 2 -d '=')
		chargestatus=''
		if [[ $rawchrgrstatus == 'Charging' ]]; then
			chargestatus=" ${CHRGARROW}"
		fi
		printf "\x20${ARROW}${chargestatus}\x20${batterylevel}%%\x20"

		batterychunks=$((( $batterylevel / 10 )))
		batterychunks=$(printf '%.0f' $batterychunks)
		for i in $(seq 1 9); do
			if (( $i <= $batterychunks )); then
				printf "\[\e[48;5;${CHECKBG}m\]\x20"
			else
				printf "\[\e[48;5;${FAILBG}m\]\x20"
			fi
		done
		if [[ $batterychunks == 10 ]]; then
			printf "\[\e[38;5;${CHECKBG}m\]"
		else
			printf "\[\e[38;5;${FAILBG}m\]"
		fi
		printf "\[\e[48;5;${DIRBG}m\]${SLDARROW}"
	fi
	GITBRN="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)" # requires newer git
	GITRPO="$(basename \"$(git rev-parse --show-toplevel 2>/dev/null))"
	#hacky but it works
	GITCMT=$(printf "${GITDNARROW}" | xargs printf "%s $(git rev-list --left-right --count origin/${GITBRN}...${GITBRN} 2>/dev/null | sed 's:\t: '${GITUPARROW}' :g')")
	EMPCMT=$(printf "${GITDNARROW} 0 ${GITUPARROW} 0")
	GITCMTLEN=${#GITCMT}
	if [[ $GITCMT == $EMPCMT ]]; then
		GITCMT="${CHECK}"
		GITCMTLEN=1
	fi
	git rev-parse --abbrev-ref HEAD > /dev/null 2>/dev/null
	if [ $? -eq 0 ]; then
		#calculate length and move there onscreen
		GITLEN=$(( ${#GITBRN} + ${#GITRPO} + ${GITCMTLEN} + 16 ))
		printf '\e[%sC\e[%sD' "$(tput cols)" "${GITLEN}"
		GIT="\[\e[48;5;${DIRBG}m\e[38;5;${GITBG}m\]${LSLDARROW}\[\e[48;5;${GITBG}m\e[38;5;${GITFG}m\]\x20git\x20${LARROW}\x20${GITRPO}\x20${LARROW}\x20${GITARROW}\x20${GITBRN}\x20${LARROW}\x20${GITCMT}\x20\[\e[0m\e[38;5;${GITBG}m\]\[\e[0m\]"
		printf "${GIT}"
		printf '\r'
	fi
	printf '\e[%sH\n' "${oldCursorPosition}"
}

clearTitleBar() {
	oldCursorPosition=$(cursorPosition)
	printf '\e[%s;0H\e[K' "$(tput lines)"
	printf '\e[%sH\n' "${oldCursorPosition}"
}

if [[ "$MODE" == "clearTitleBar" ]]; then
	clearTitleBar
	exit
elif [[ "$MODE" == "bashrc" ]]; then
	# I symlink the config file to ~/.config since that's a pretty standard location
	POWERLINEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
	cat <<- EOF
	ln -sf "${POWERLINEDIR}/powerline.cfg" ~/.config/powerline.cfg;
	source "${POWERLINEDIR}/bash-preexec/bash-preexec.sh";
	preexec() {
	    ${POWERLINEDIR}/powerline.sh clearTitleBar;
	};
	precmd() {
	EOF
    echo -ne '	PS1="$('
    echo -ne "${POWERLINEDIR}"
    echo '/powerline.sh draw $? 0)";'
	echo '}'
	exit 0
elif [[ "$MODE" != "draw" ]]; then
	echo "This is not meant to be called interactively."
	echo "If you didn't, check your .bashrc"
	exit 1
fi

drawTitleBar

ROOTPROMPT='$'
if [[ $(id -u) == '0' ]]; then
	ROOTPROMPT="\[\e[48;5;${ERRBG}\e[38;5;${ERRFG}\]#"
fi

NDIR="\[\e[48;5;${DIRBG}m\e[38;5;${DIRFG}m\]\x20${NROOTSLASH}${NDIR}\x20${ARROW}\x20${ROOTPROMPT}\x20\[\e[0m\e[38;5;${DIRBG}m\]${SLDARROW}"

NUSER="\[\e[48;5;${USRBG}m\e[38;5;${USRFG}m\]\x20${USER}\x20\[\e[38;5;${USRBG}m\e[48;5;${DIRBG}m\]${SLDARROW}"

ERRTXT=${err[$PSC]}

if [ $PSC != 0 ]; then
	NPSC="\[\e[48;5;${FAILBG}m\e[38;5;${FAILFG}m\]\x20${FAIL}\x20\[\e[38;5;${FAILTXT}m\]${ERRTXT}\[\e[38;5;${FAILBG}m\e[48;5;${USRBG}m\]${SLDARROW}"
else
	NPSC="\[\e[48;5;${CHECKBG}m\e[38;5;${CHECKFG}m\]\x20${CHECK}\x20\[\e[38;5;${CHECKBG}m\e[48;5;${USRBG}m\]${SLDARROW}"
fi
printf "${NPSC}${NUSER}${NDIR}"
printf "\[\e[0m\]\x20"
