#!/bin/sh

#  Hax3 Do not seal
#  BigMac MacPro pre-install tool v1.1
#  Created by StarPlayrX on 12.14.2020
hax3="$1"

echo "$hax3"

IsNotRecovery=$(csrutil disable 2>&1)
Recovery="Recovery"
if [[ "$IsNotRecovery" == *"$Recovery"* ]]
    then
        echo "Enabling Mac OS Extended Journaled"
    else
        echo "Enabling JHFS+ and APFS"
fi

if [[ "$IsNotRecovery" == *"$Recovery"* ]]
    then
        echo "Launching sudo hax3 library"
        sudo -u $SUDO_USER launchctl setenv DYLD_INSERT_LIBRARIES "$asentientbot$barrykn"
    else
        echo "Launching root hax3 library"
        launchctl setenv DYLD_INSERT_LIBRARIES "$hax3"
fi
