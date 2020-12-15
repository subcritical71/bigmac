#!/bin/sh

#  startupdisk.sh
#  
#
#  Created by Todd Bruss on 12/11/20.
#

#This script requires Sudo



IFS=$'\n'

list=$(ls /Volumes 2>&1)

match="The blessed volume in this APFS container is "
apfsContainer="APFS container"
volumesFolder="/Volumes/"
counter=0
startup="Startup"
systemdisks+=($systemdisk)
systemnames+=($systemnames)
comdot="com."
snapshot="snapshot"
timemachine="timemachine"


#New Line
n () {
    printf "\n"
}


if [ "$EUID" -ne 0 ]
  then
    n
    printf "Please run with sudo!"
    n;n;
    exit 0
fi


for i in $list
do
    if [[ $i != *'- Data' ]]
        then
            item=$(bless --info "$volumesFolder$i" 2>&1 | grep "$apfsContainer" 2>&1)
            isEmpty=$(diskutil list "$i" 2>&1)
            
            if [ "$item" == "$match\"/\"." ] &&  [[ "$i" != *"$snapshot"* ]] && [[ "$i" != *"$timemachine"* ]]  && [[ "$i" != *"$comdot"* ]] && [ isEmpty != '' ]
                 then
                 counter=$((counter+1))
                
                 printf "$i"
                 n
                 systemdisks+=("/")
                 systemnames+=("$i")
            fi
    fi

done
