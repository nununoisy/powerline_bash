#!/bin/bash

#grab the config file
source ${HOME}/.config/powerline.cfg

#set up some variables guys
USER="$(whoami)"
DIR="$(pwd)"
PSC=$1
PROCESS=${2//"_update_ps1"/''}
PROCESS=${PROCESS//"unset"/''}

NDIR=${DIR//"$HOME"/'/~'}
NDIR="$(echo $NDIR | cut -c 2-)"
NDIR=${NDIR//\//"\x20${ARROW}\x20"}

NROOTSLASH="/\x20${ARROW}\x20"
if test "${PWD##${HOME}}" != "${PWD}"; then
        NROOTSLASH=""
fi




NDIR="\[\e[48;5;${DIRBG}m\e[38;5;${DIRFG}m\]\x20${NROOTSLASH}${NDIR}\x20\[\e[0m\e[38;5;${DIRBG}m\]${SLDARROW}"

NUSER="\[\e[48;5;${USRBG}m\e[38;5;${USRFG}m\]\x20${USER}\x20\[\e[38;5;${USRBG}m\e[48;5;${DIRBG}m\]${SLDARROW}"
if [ -z $PROCESS ]; then
	ERRTXT=${err[$PSC]}
else
	ERRDB="err${PROCESS}"
	ERRDBVAR=${!ERRDB}
	ERRDBV="$ERRDB[$PSC]"
	if [ -z $ERRDBVAR ]; then
		ERRTXT=${err[$PSC]}
	else
		ERRTXT=${!ERRDBV}
	fi
fi

if [ $PSC != 0 ]; then
	NPSC="\[\e[48;5;${FAILBG}m\e[38;5;${FAILFG}m\]\x20${FAIL}\x20\[\e[38;5;${FAILTXT}m\]${ERRTXT}\[\e[38;5;${FAILBG}m\e[48;5;${USRBG}m\]${SLDARROW}"
else
	NPSC="\[\e[48;5;${CHECKBG}m\e[38;5;${CHECKFG}m\]\x20${CHECK}\x20\[\e[38;5;${CHECKBG}m\e[48;5;${USRBG}m\]${SLDARROW}"
fi

GITBRN="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)" # requires newer git
GITRPO="$(basename \"$(git rev-parse --show-toplevel 2>/dev/null))"
GITCMT="$(git rev-list --left-right --count origin/${GITBRN}...${GITBRN} 2>/dev/null | sed 's:\t:- +:g')"
if [[ $GITCMT -eq '0- +0' ]]; then
	GITCMT="even"
fi
git rev-parse --abbrev-ref HEAD > /dev/null 2>/dev/null
if [ $? -eq 0 ]; then
	GIT="\[\e[48;5;${GITBG}m\e[38;5;${GITFG}m\]\x20git\x20${ARROW}\x20${GITRPO}\x20${ARROW}\x20${GITBRN}\x20${ARROW}\x20${GITCMT}\x20\[\e[0m\e[38;5;${GITBG}m\]${SLDARROW}\[\e[0m\]"
	printf "${GIT}\n"
fi
printf "${NPSC}${NUSER}${NDIR}"
printf "\[\e[0m\]\x20"