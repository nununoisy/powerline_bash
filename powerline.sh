#!/bin/bash

USER="$(whoami)"
DIR="$(pwd)"
PSC=$1

NDIR=${DIR//"$HOME"/'/~'}
NDIR="$(echo $NDIR | cut -c 2-)"
NDIR=${NDIR//\//"\x20\xEE\x82\xB1\x20"}

NROOTSLASH="/\x20\xEE\x82\xB1\x20"
if test "${PWD##${HOME}}" != "${PWD}"; then
        NROOTSLASH=""
fi

NDIR="\[\e[48;5;240m\e[38;5;15m\]\x20${NROOTSLASH}${NDIR}\x20\[\e[0m\e[38;5;240m\]\xEE\x82\xB0"


NUSER="\[\e[48;5;208m\e[38;5;15m\]\x20${USER}\x20\[\e[38;5;208m\e[48;5;240m\]\xEE\x82\xB0"

if [ $PSC != 0 ]; then
	if (errno $PSC > /dev/null); then
		PSC="$(errno ${PSC} | awk '{for(i=3;i<=NF;++i)printf $i" "}')"
	else
		PSC="${PSC}\x20"
	fi
	NPSC="\[\e[48;5;9m\e[38;5;15m\]\x20\xE2\x8A\x9D\x20\[\e[38;5;7m\]${PSC}\[\e[38;5;9m\e[48;5;208m\]\xEE\x82\xB0"
else
	NPSC="\[\e[48;5;41m\e[38;5;0m\]\x20\xE2\x9C\x93\x20\[\e[38;5;41m\e[48;5;208m\]\xEE\x82\xB0"
fi

GITBRN="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)" # requires newer git
GITRPO="$(basename \"$(git rev-parse --show-toplevel 2>/dev/null))"
GITCMT="$(git rev-list --left-right --count origin/${GITBRN}...${GITBRN} 2>/dev/null | sed 's:\t:- +:g')"
git rev-parse --abbrev-ref HEAD > /dev/null 2>/dev/null
if [ $? -eq 0 ]; then
	GIT="\[\e[48;5;33m\e[38;5;15m\]\x20git\x20\xEE\x82\xB1\x20${GITRPO}\x20\xEE\x82\xB1\x20${GITBRN}\x20\xEE\x82\xB1\x20${GITCMT}\x20\[\e[0m\e[38;5;33m\]\xEE\x82\xB0\[\e[0m\]"
	printf "${GIT}\n"
fi
printf "${NPSC}${NUSER}${NDIR}"
printf "\[\e[0m\]\x20"
