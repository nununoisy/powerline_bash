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
	err=( "0" "Operation not permitted " "No such file or directory " "No such process " "Interrupted system call " "Input/output error " "No such device or address " "Argument list too long " "Exec format error " "Bad file descriptor " "No child processes " "Resource temporarily unavailable " "Cannot allocate memory " "Permission denied " "Bad address " "Block device required " "Device or resource busy " "File exists " "Invalid cross-device link " "No such device " "Not a directory " "Is a directory " "Invalid argument " "Too many open files in system " "Too many open files " "Inappropriate ioctl for device " "Text file busy " "File too large " "No space left on device " "Illegal seek " "Read-only file system " "Too many links " "Broken pipe " "Numerical argument out of domain " "Numerical result out of range " "Resource deadlock avoided " "File name too long " "No locks available " "Function not implemented " "Directory not empty " "Too many levels of symbolic links " "41" "No message of desired type " "Identifier removed " "Channel number out of range " "Level 2 not synchronized " "Level 3 halted " "Level 3 reset " "Link number out of range " "Protocol driver not attached " "No CSI structure available " "Level 2 halted " "Invalid exchange " "Invalid request descriptor " "Exchange full " "No anode " "Invalid request code " "Invalid slot " "58" "Bad font file format " "Device not a stream " "No data available " "Timer expired " "Out of streams resources " "Machine is not on the network " "Package not installed " "Object is remote " "Link has been severed " "Advertise error " "Srmount error " "Communication error on send " "Protocol error " "Multihop attempted " "RFS specific error " "Bad message " "Value too large for defined data type " "Name not unique on network " "File descriptor in bad state " "Remote address changed " "Can not access a needed shared library " "Accessing a corrupted shared library " ".lib section in a.out corrupted " "Attempting to link in too many shared libraries " "Cannot exec a shared library directly " "Invalid or incomplete multibyte or wide character " "Interrupted system call should be restarted " "Streams pipe error " "Too many users " "Socket operation on non-socket " "Destination address required " "Message too long " "Protocol wrong type for socket " "Protocol not available " "Protocol not supported " "Socket type not supported " "Operation not supported " "Protocol family not supported " "Address family not supported by protocol " "Address already in use " "Cannot assign requested address " "Network is down " "Network is unreachable " "Network dropped connection on reset " "Software caused connection abort " "Connection reset by peer " "No buffer space available " "Transport endpoint is already connected " "Transport endpoint is not connected " "Cannot send after transport endpoint shutdown " "Too many references: cannot splice " "Connection timed out " "Connection refused " "Host is down " "No route to host " "Operation already in progress " "Operation now in progress " "Stale file handle " "Structure needs cleaning " "Not a XENIX named type file " "No XENIX semaphores available " "Is a named type file " "Remote I/O error " "Disk quota exceeded " "No medium found " "Wrong medium type " "Operation canceled " "Required key not available " "Key has expired " "Key has been revoked " "Key was rejected by service " "Owner died " "State not recoverable " "Operation not possible due to RF-kill " "Memory page has hardware error " "134" "135" "136" "137" "138" "139" "140" "141" "142" "143" "144" "145" "146" "147" "148" "149" "150" "151" "152" "153" "154" "155" "156" "157" "158" "159" "160" "161" "162" "163" "164" "165" "166" "167" "168" "169" "170" "171" "172" "173" "174" "175" "176" "177" "178" "179" "180" "181" "182" "183" "184" "185" "186" "187" "188" "189" "190" "191" "192" "193" "194" "195" "196" "197" "198" "199" "200" "201" "202" "203" "204" "205" "206" "207" "208" "209" "210" "211" "212" "213" "214" "215" "216" "217" "218" "219" "220" "221" "222" "223" "224" "225" "226" "227" "228" "229" "230" "231" "232" "233" "234" "235" "236" "237" "238" "239" "240" "241" "242" "243" "244" "245" "246" "247" "248" "249" "250" "251" "252" "253" "254" "255" )
	NPSC="\[\e[48;5;9m\e[38;5;15m\]\x20\xE2\x8A\x9D\x20\[\e[38;5;7m\]${err[$PSC]}\[\e[38;5;9m\e[48;5;208m\]\xEE\x82\xB0"
else
	NPSC="\[\e[48;5;41m\e[38;5;0m\]\x20\xE2\x9C\x93\x20\[\e[38;5;41m\e[48;5;208m\]\xEE\x82\xB0"
fi

GITBRN="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)" # requires newer git
GITRPO="$(basename \"$(git rev-parse --show-toplevel 2>/dev/null))"
GITCMT="$(git rev-list --left-right --count origin/${GITBRN}...${GITBRN} 2>/dev/null | sed 's:\t:- +:g')"
if [[ $GITCMT -eq '0- +0' ]]; then
        GITCMT="even"
fi
git rev-parse --abbrev-ref HEAD > /dev/null 2>/dev/null
if [ $? -eq 0 ]; then
	GIT="\[\e[48;5;33m\e[38;5;15m\]\x20git\x20\xEE\x82\xB1\x20${GITRPO}\x20\xEE\x82\xB1\x20${GITBRN}\x20\xEE\x82\xB1\x20${GITCMT}\x20\[\e[0m\e[38;5;33m\]\xEE\x82\xB0\[\e[0m\]"
	printf "${GIT}\n"
fi
printf "${NPSC}${NUSER}${NDIR}"
printf "\[\e[0m\]\x20"
