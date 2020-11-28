#!/bin/sh

#  sudo ./postinstall.sh
#  BigMac MacPro post install tool v11.0.1 build 0.1
#  Created by StarPlayrX on 11.17.2020


#Auto Switch to the current directory
dir=$(dirname "$0")
cd "$dir"

if [ "$EUID" -ne 0 ]
  then
    n
    printf "Please run with sudo!"
    n
    exit 0
fi

#Black background
k () {
    printf '\e[K'
    printf "\e[48;5;0m"
    printf '\e[K'
}

#New Line
n () {
    k
    printf "\n"
    k
}

#Orange Text
o () {
    k
    printf "\e[38;5;172m"
    k
}

#Green Text
g () {
    k
    printf "\e[38;5;112m"
    k
}


bigmac="$(pwd)"
echo $bigmac
k
n
o
printf "—————————————————————————————————————————————————————————————————"
n
g
printf " StarPlayrX -> Big Mac Post Installation Tool for Mac Pros 1.0.3 "
n
o
printf "—————————————————————————————————————————————————————————————————"
n
g


n
o
printf "—————————————————————————————————————————————————————————————————"
n
g
printf " 🍔  Apple HD Audio, SSE4.1 Telemetry, SuperDrive Support        "
n
printf " 🧀  MouSSE 4.2 Emulator for AMD Radeon Video Drivers            "
n
printf " 🍺  HDMI Audio, USB Map                        		         "
n
printf " 📸  Snapshot Removal Tool by StarPlayrX                         "
n
o
printf "—————————————————————————————————————————————————————————————————"
n
g
destVolume="/"
kexts="/🍔/"
cheese="/🧀/"
beer="/🍺/"
boot="/💾/"

bigsur="bigsur/"

source=$(pwd)$kexts
cheesey=$(pwd)$cheese
rootbeer=$(pwd)$beer
bootdisk=$(pwd)$boot

#Apple Kexts
appleHDA="AppleHDA.kext"
ioATAFamily="IOATAFamily.kext"
ioUSBFamily="IOUSBFamily.kext"
ioUSBHostFamily="IOUSBHostFamily.kext"



#SSE4.1 compatible plugin
telemetry="com.apple.telemetry.plugin"

#Third Party Kexts
LegacyUSBInjector="LegacyUSBInjector.kext"
SXHCD="SXHCD.kext"
AAAMouSSE="AAAMouSSE.kext"
SIPManager="SIPManager.kext"
HDMIAudio="HDMIAudio.kext"
bootplist="com.apple.Boot.plist"

n
o
printf "————————————————–––––————————————"
n
g
printf " 💾 Select System Disk To Patch"
n
o
printf "————————————————–––––————————————"
n
g
systemsetup=""
while [[ "$systemsetup" != *"System/Library/CoreServices"* ]]
do
    systemsetup=$(systemsetup -liststartupdisks)
done


IFS=$'\n' #Breaks for in loops at line ending and ignores spaces

counter=0
systemdisks=()
space=" "
dot="."
suffix="System/Library/CoreServices"
slash="/"
startupdisk="/"
#Display the Disk Menu, routine by StarPlayrX
for sys in $systemsetup
do
     
     counter=$((counter+1))
     long=$(echo $sys | awk '{ printf $0 }' )
     systemdisk=${long%"$suffix"}
     
     if [[ "$systemdisk" != *"/Volumes"* ]]
        then
            g;n;
            systemdisk="/"
            printf "$counter$dot$space$systemdisk"
            systemdisks+=($systemdisk)
        else
            g;n;
            systemdisk=${systemdisk%"$slash"}
            printf "$counter$dot$space$systemdisk"
            systemdisks+=($systemdisk)
    fi
done

counter=$((counter+1)) #Sets up # Entry for the Startup Disk menu
n;n;
read -p " 🎯 Target | / = Startup Disk | System Disk # : " destVolume2

if [ "$destVolume2" != "" ] && [ "$destVolume2" != "/" ] && [ -n "$destVolume2" ] && [ "$destVolume2" -eq "$destVolume2" ] 2>/dev/null
    then
        if  [[ $((destVolume2+0)) < counter ]]
            then
            destVolume2=$((destVolume2-1))
            destVolume2=${systemdisks[destVolume2]}
        fi
fi

if [ "$destVolume2" != "" ] && [ "$destVolume2" != "/" ]
 then
   mount -uw "$destVolume2"
   destVolume="$destVolume2"
 else
   destVolume2="/"
   destVolume="$destVolume2"

   mount -uw /
fi

if [ ! -d "$destVolume2" ]
    then
    n
    printf "Can't find the disk. Please pay attention! Exiting..."
    n
fi

n;o;
printf "————————————————–––––—————————————————"
n;
g;
printf " 🎯 Target ";o;printf "——>";g; printf " $destVolume"
n;
printf " 🍔 Source ";o;printf "——>";g; printf " $source"
n;o;
printf "————————————————–––––—————————————————"
n;g;
read -p "Press RETURN to proceed:" proceed

kext="/System/Library/Extensions/"
libKext="/Library/Extensions/"
plugins="/System/Library/UserEventPlugins/"
systemconfig="/Library/Preferences/SystemConfiguration/"
bootplist="com.apple.Boot.plist"
coreservices="/System/Library/CoreServices/"
buildmanifest="BuildManifest.plist"
platformsupport="PlatformSupport.plist"

restore="/restore/"
ghost="/👻/" #Preboot temporary mount point

n;o;
printf "————————————————–––––————————————"
n;g;
printf "Boot.plist installation"
n;o;
printf "————————————————–––––————————————"
n;g;

#cp "$bootdisk$bigsur$bootplist" "$(pwd)$systemconfig$bootplist"
ditto -v "$bootdisk$bigsur$bootplist" "$destVolume$systemconfig$bootplist"
echo "$destVolume$systemconfig$bootplist"
chmod 755 "$destVolume$systemconfig$bootplist"
chown 0:0 "$destVolume$systemconfig$bootplist"

ditto -v "$bootdisk$bigsur$platformsupport" "$destVolume$coreservices$platformsupport" 
chmod 755 "$destVolume$coreservices$platformsupport"
chown 0:0 "$destVolume$coreservices$platformsupport"

#Preboot work
preboot=$( diskutil list $destVolume | grep Preboot | grep disk | awk '{ printf $7 }' )

prebootlocation=$bigmac$ghost
prebootid=""
loc=""
slash=""

restoremanifest="/restore/BuildManifest.plist"

if [ $destVolume != "/" ]
    then
      printf "Testing Preboot mount..."
      test=$(diskutil umount force "$preboot")
      printf "Mounting Preboot Volume..."
      diskutil mount -mountPoint "$prebootlocation" "$preboot"
      sleep 1
      prebootid=$( diskutil info "$destVolume" | grep Group | awk '{ printf $4 }' )
      loc=$prebootlocation$prebootid$slash
      #mount -uw $prebootlocation

      #read ""
    else
      #Preboot Volumes are already mounted on Startup disks
      prebootlocation="/System/Volumes/Preboot/"
      prebootid=$( diskutil info / | grep Group | awk '{ printf $4 }' )
      loc=$prebootlocation$prebootid$slash
      echo $loc
      #mount -uw $prebootlocation
      #read ""
     #echo $loc
     #exit
fi


if [ ! -d "$prebootlocation$prebootid" ]
    then
        echo "Could not find Preboot Volume exiting... If this persists, reboot."
        diskutil umount force $preboot
        exit 0
fi

sleep 1

ditto -v "$bootdisk$bigsur$bootplist" "$loc$systemconfig$bootplist"
chmod 755 "$loc$systemconfig$bootplist"
chown 0:0 "$loc$systemconfig$bootplist"

ditto -v "$bootdisk$bigsur$buildmanifest" "$loc$restoremanifest"
chmod 755 "$loc$restoremanifest"
chown 0:0 "$loc$restoremanifest"

ditto -v "$bootdisk$bigsur$platformsupport" "$loc$coreservices$platformsupport"
chmod 755 "$loc$coreservices$platformsupport"
chown 0:0 "$loc$coreservices$platformsupport"

diskutil umount force "$preboot"


sleep 3


sleep 0.3

cd $bigmac

n
printf "SSE 4.2 AMD Radeon Driver Emulator MouSSE"
n
rm -Rf "$destVolume$libKext$AAAMouSSE"
sleep 0.1
ditto -v "$cheesey$AAAMouSSE" "$destVolume$libKext$AAAMouSSE"
chown -R 0:0 "$destVolume$libKext$AAAMouSSE"
chmod -R 755 "$destVolume$libKext$AAAMouSSE"

n
printf "HDMI Audio"
n
rm -Rf "$destVolume$libKext$HDMIAudio"
sleep 0.1
ditto -v "$rootbeer$HDMIAudio" "$destVolume$libKext$HDMIAudio"
chown -R 0:0 "$destVolume$libKext$HDMIAudio"
chmod -R 755 "$destVolume$libKext$HDMIAudio"


## Don't quite have this working yet
#
n
printf "LegacyUSBInjector"
n
rm -Rf "$libKext$LegacyUSBInjector"
sleep 0.1
ditto -v "$rootbeer$LegacyUSBInjector" "$destVolume$libKext$LegacyUSBInjector"
chown -R 0:0 "$destVolume$libKext$LegacyUSBInjector"
chmod -R 755 "$destVolume$libKext$LegacyUSBInjector"
#

## Don't quite have this working yet
#
n

printf "SXHCD USB 3.0 Driver"
n
rm -Rf "$libKext$SXHCD"
sleep 0.1
ditto -v "$rootbeer$SXHCD" "$destVolume$libKext$SXHCD"
chown -R 0:0 "$destVolume$libKext$SXHCD"
chmod -R 755 "$destVolume$libKext$SXHCD"
#




n
printf "SSE4.1 compatible Telemetry plugin"
n
rm -Rf "$destVolume$plugins$telemetry"
sleep 0.1
ditto -v "$source$telemetry" "$destVolume$plugins$telemetry"
chown -R 0:0 "$destVolume$plugins$telemetry"
chmod -R 755 "$destVolume$plugins$telemetry"


n
printf "CD/DVD SuperDrive Intel PIIX ATA"
n
rm -Rf "$destVolume$kext$ioATAFamily"
sleep 0.1
ditto -v "$source$ioATAFamily" "$destVolume$kext$ioATAFamily"
chown -R 0:0 "$destVolume$kext$ioATAFamily"
chmod -R 755 "$destVolume$kext$ioATAFamily"


n
printf "CD/DVD SuperDrive Intel PIIX ATA"
n
rm -Rf "$destVolume$kext$ioATAFamily"
sleep 0.1
ditto -v "$source$ioATAFamily" "$destVolume$kext$ioATAFamily"
chown -R 0:0 "$destVolume$kext$ioATAFamily"
chmod -R 755 "$destVolume$kext$ioATAFamily"



##This also fixes USB Video crash bug in Quicktime Player.
n
printf "Apple HDA"
n
rm -Rf "$destVolume$kext$appleHDA"
sleep 0.1
ditto -v "$source$appleHDA" "$destVolume$kext$appleHDA"
chown -R 0:0 "$destVolume$kext$appleHDA"
chmod -R 755 "$destVolume$kext$appleHDA"

#n
##printf "AppleNMI"
#n
#rm -Rf "$destVolume$kext$AppleNMI"
#sleep 0.1
#ditto -v "$source$AppleNMI" "$destVolume$kext$AppleNMI"
#chown -R 0:0 "$destVolume$kext$AppleNMI"
#chmod -R 755 "$destVolume$kext$AppleNMI"

#n
#printf "ApplePlatformFamily"
#n
#rm -Rf "$destVolume$kext$ApplePlatformFamily"
#sleep 0.1
#ditto -v "$source$ApplePlatformFamily" "$destVolume$kext$ApplePlatformFamily"
#chown -R 0:0 "$destVolume$kext$ApplePlatformFamily"
#chmod -R 755 "$destVolume$kext$ApplePlatformFamily"

#n
#printf "AppleNMI"
#n
#rm -Rf "$destVolume$kext$AppleNMI"
#sleep 0.1
#ditto -v "$source$AppleNMI" "$destVolume$kext$AppleNMI"
#chown -R 0:0 "$destVolume$kext$AppleNMI"
#chmod -R 755 "$destVolume$kext$AppleNMI"

#n
#printf "BSDKernel"
#n
#rm -Rf "$destVolume$kext$BSDKernel"
#sleep 0.1
#ditto -v "$source$BSDKernel" "$destVolume$kext$BSDKernel"
#chown -R 0:0 "$destVolume$kext$BSDKernel"
#chmod -R 755 "$destVolume$kext$BSDKernel"

#n
#printf "IOKit"
#n
#rm -Rf "$destVolume$kext$IOKit"
#sleep 0.1
#ditto -v "$source$IOKit" "$destVolume$kext$IOKit"
#chown -R 0:0 "$destVolume$kext$IOKit"
#chmod -R 755 "$destVolume$kext$IOKit"

#n
#printf "IOSystemManagement"
#n
#rm -Rf "$destVolume$kext$IOSystemManagement"
#sleep 0.1
#ditto -v "$source$IOSystemManagement" "$destVolume$kext$IOSystemManagement"
#chown -R 0:0 "$destVolume$kext$IOSystemManagement"
#chmod -R 755 "$destVolume$kext$IOSystemManagement"

#n
#printf "Kasan"
#n
#rm -Rf "$destVolume$kext$Kasan"
#sleep 0.1
#ditto -v "$source$Kasan" "$destVolume$kext$Kasan"
#chown -R 0:0 "$destVolume$kext$Kasan"
#chmod -R 755 "$destVolume$kext$Kasan"

#n
#printf "Libkern"
#n
#rm -Rf "$destVolume$kext$Libkern"
#sleep 0.1
#ditto -v "$source$Libkern" "$destVolume$kext$Libkern"
#chown -R 0:0 "$destVolume$kext$Libkern"
#chmod -R 755 "$destVolume$kext$Libkern"

#n
#printf "MACFramework"
#n
#rm -Rf "$destVolume$kext$MACFramework"
#sleep 0.1
#ditto -v "$source$MACFramework" "$destVolume$kext$MACFramework"
#chown -R 0:0 "$destVolume$kext$MACFramework"
#chmod -R 755 "$destVolume$kext$MACFramework"

#n
#printf "Mach"
#n
#rm -Rf "$destVolume$kext$Mach"
#sleep 0.1
#ditto -v "$source$Mach" "$destVolume$kext$Mach"
#chown -R 0:0 "$destVolume$kext$Mach"
#chmod -R 755 "$destVolume$kext$Mach"

#n
#printf "Private"
#n
#rm -Rf "$destVolume$kext$Private"
#sleep 0.1
#ditto -v "$source$Private" "$destVolume$kext$Private"
#chown -R 0:0 "$destVolume$kext$Private"
#chmod -R 755 "$destVolume$kext$Private"

#n
#printf "Unsupported"
#n
#rm -Rf "$destVolume$kext$Unsupported"
#sleep 0.1
#ditto -v "$source$Unsupported" "$destVolume$kext$Unsupported"
#chown -R 0:0 "$destVolume$kext$Unsupported"
#chmod -R 755 "$destVolume$kext$Unsupported"

##This also fixes USB Video crash bug in Quicktime Player.
#
#printf "io Apple USB 2.0 ioUSBFamily"
#n

#rm -Rf "$destVolume$kext$ioUSBFamily"
#sleep 0.1
#ditto -v "$source$appleHDA" "$destVolume$kext$ioUSBFamily"
#chown -R 0:0 "$destVolume$kext$ioUSBFamily"
#chmod -R 755 "$destVolume$kext$ioUSBFamily"

##This also fixes USB Video crash bug in Quicktime Player.
#n
#printf "io Apple USB 2.0 ioUSBHostFamily"
#n

#rm -Rf "$destVolume$kext$ioUSBHostFamily"
#sleep 0.1
#ditto -v "$source$appleHDA" "$destVolume$kext$ioUSBHostFamily"
#chown -R 0:0 "$destVolume$kext$ioUSBHostFamily"
#chmod -R 755 "$destVolume$kext$ioUSBHostFamily"

bin="/📠/"
vers="/sw_vers"
sw=$(pwd)$bin$vers

n
printf "Software Version Check"
n
version=$($sw '-productVersion')
printf $version
n
if [[ $version != *"11."* ]]
    then
        ## Use is Big Sur Disk
        if [ "$destVolume" == "/" ]
        then
            n
            printf "Updating System Prelinked Kernel..."
            
            kextcache -system-prelinked-kernel
            n
            printf "Updating System Caches..."
            n
            kextcache -system-caches
        else
            n
            printf "Updating kextcache on volume $destVolume..."
            n
            kextcache -u "$destVolume"
            
            printf "Updating startup kextcache check on volume $destVolume..."
            n
            kextcache -U "$destVolume"
        fi
        
        if [ "$destVolume" == "/" ]
            then
                chown -R 0:0 /System/Library/Extensions/
                chmod -R 755 /System/Library/Extensions/
                kextcache -i /
            else
                chown -R 0:0 "$destVolume"/System/Library/Extensions/
                chmod -R 755 "$destVolume"/System/Library/Extensions/
                kextcache -i "$destVolume"
        fi
    else
    
        if [ "$destVolume" == "/" ]
            then
            	n
       			printf "Updating Library Kernel Extensions..."
       			n
       			
                chown -R 0:0 /System/Library/Extensions/
                chmod -R 755 /System/Library/Extensions/
                kmutil install --volume-root "/" --check-rebuild

                n
       			printf "Updating Kernel Extensions..."
       			n
                kmutil create -n sys --kernel /System/Libary/Kernels/kernel --variant-suffix release --volume-root "$destVolume" --system-path /System/Library/KernelCollections/SystemKernelExtensions.kc --boot-path /System/Library/KernelCollections/BootKernelExtensions.kc
                n
                
                kcditto="kcditto"
                $kcditto
            else
        
            	n
       			printf "Updating Library Kernel Extensions..."
       			n
       			
        	    chown -R 0:0 "$destVolume"/System/Library/Extensions/
                chmod -R 755 "$destVolume"/System/Library/Extensions/
                kmutil install --volume-root "$destVolume" --check-rebuild
                
                n
       			printf "Updating Kernel Extensions..."
       			n
                kmutil create -n sys --kernel /System/Libary/Kernels/kernel --variant-suffix release --volume-root "$destVolume" --system-path /System/Library/KernelCollections/SystemKernelExtensions.kc --boot-path /System/Library/KernelCollections/BootKernelExtensions.kc
                n
                
                kcditto="kcditto"
                sbin="/usr/sbin/"
                "$destVolume$sbin$kcditto"
        fi
       
      
fi

#Snapshot deletion code by StarPlayrX 2020
snapshots=$(diskutil apfs listsnapshots "$destVolume" | grep +-- | sed 's/^.\{4\}//') #to do replace with AWK

n
printf 'Checking snapshots.'
n
for uuid in $snapshots
do
    n
    printf ' 📸 Attempting to delete snapshot => 's
    n
    printf ' '
    printf $uuid
    n
    
    diskutil apfs deletesnapshot "$destVolume" -uuid $uuid
done


#Bless with snapshot
#bless --folder "$destVolume"/System/Library/CoreServices --bootefi --last-sealed-snapshot
#bless --folder "$destVolume"/System/Library/CoreServices --bootefi --create-snapshot

#New way to bless
if [ "$destVolume" == "/" ]
    then
        n
        systemsetup -setstartupdisk "/System/Library/CoreServices"
        n
        #test=$(sudo bless --verbose -i /Volumes/myBigMac | grep Preboot)
        #echo "$test" | grep "Preboot Volumes"
    else
        n
        systemsetup -setstartupdisk "$destVolume/System/Library/CoreServices"
        n
        #test=$(sudo bless --verbose -i /Volumes/myBigMac | grep Preboot)
        #echo "$test" | grep "Preboot Volumes"
fi


n
printf "If your system gets locked with a snapshot try cloning it with:"

n
printf "sudo asr -s / -t /Volumes/target -er -nov"

n;n;
printf " 💰 Tips via PayPal are accepted here: https://tinyurl.com/y2dsjtq3"

n
read -p "Press RETURN to Reboot [ options : q for quick ]: " rebootArgs

n
if [ "$rebootArgs" != "" ]
then
    reboot "-$rebootArgs"
else
    reboot
fi
