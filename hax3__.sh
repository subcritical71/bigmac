#!/bin/sh

#  Hax3 Do not seal
#  BigMac MacPro pre-install tool v1.1
#  Created by StarPlayrX on 12.14.2020
hax3="$1"
echo "$hax3"
echo "Launching hax3 library"
launchctl setenv DYLD_INSERT_LIBRARIES "$hax3"

