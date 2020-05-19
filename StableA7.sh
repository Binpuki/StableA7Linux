#!/bin/bash

clear
echo "**************** StableA7Linux ****************"
echo
echo "=> By Luke:"
echo "=>   - u/TheLukeGuy"
echo "=>   - @ConsoleLogLuke"
echo "=> Port Linux  - @twilightmoon4"


	echo "==> WARNING: This is a beta version. Things might not work properly or at all."
	echo


echo "==> Which futurerestore patch would you like to use?"
echo "==> If you are unsure, choose option 1. This is only present in this beta version."
echo
echo "=> (1) Normal/Auto"
echo "=>   - Inconsistent, sometimes works and sometimes doesn't"
echo "=>   - Works on Debian/Ubuntu more recente"
echo "=>   - Requires Root"
echo
echo
read -p "==> Which patch would you like to use? (1): " patch

if [ "$patch" != 1 ]; then
	echo "==> Invalid patch number, you must choose 1."
	exit 1
fi

echo "==> Creating work directory..."
if [ -d StableA7 ]; then
	rm -r StableA7
fi
mkdir StableA7
if [ -f restore.ipsw ]; then
cp -r *.ipsw StableA7/restore.ipsw
fi
cp -r bin StableA7/bin
cd StableA7

echo "==> Downloading patches..."
wget -O patch.zip https://gitlab.com/devluke/stablea7/-/archive/master/stablea7-master.zip?path=patch -q --show-progress
unzip -q patch.zip
cp -r stablea7-master-patch/patch .
rm -r stablea7-master-patch patch.zip

./bin/igetnonce
read -p "[+]Copy and paste idevice and press enter (ex:iPhone6,2): " identifier
            echo $identifier

model=
if [ $identifier == iPhone6,1 ] || [ $identifier == iPhone6,2 ]; then
	model=iphone6
	echo "==> Your iPhone 5S is supported!"
elif [ $identifier == iPad4,1 ] || [ $identifier == iPad4,2 ]; then
	model=ipad4
	echo "==> Your iPad Air is supported!"
elif [ $identifier == iPad4,4 ] || [ $identifier == iPad4,5 ]; then
	model=ipad4b
	echo "==> Your iPad Mini 2 is supported!"
else
	echo
	echo "==> Your device is not supported. Only the following devices work with this tool:"
	echo
	echo "=>   - iPhone 5S (iPhone6,1 or iPhone6,2)"
	echo "=>   - iPad Air (iPad4,1 or iPad4,2)"
	echo "=>   - iPad Mini 2 (iPad4,4 or iPad4,5)"
	echo
	echo "==> Sorry! ;("
	exit 1
fi

ipsw=${ipsw//\\/}
if [ -f "$ipsw" ]; then
	echo "==> Copying IPSW..."
	cp "$ipsw" . 2> /dev/null
fi

echo "==> Checking for IPSW..."
mv *.ipsw restore.ipsw 2> /dev/null
if [ -f restore.ipsw ]; then
	echo "==> IPSW found!"
fi

echo "==> Extracting IPSW..."
unzip -q -d ipsw restore.ipsw

echo "==> Copying iBEC/iBSS..."
cp ipsw/Firmware/dfu/iBEC.$model.RELEASE.im4p ibec.im4p
cp ipsw/Firmware/dfu/iBSS.$model.RELEASE.im4p ibss.im4p

echo "==> Patching iBEC/iBSS..."
bspatch ibec.im4p ibec.patched.im4p patch/ibec_$model.patch
bspatch ibss.im4p ibss.patched.im4p patch/ibss_$model.patch

echo "==> Copying patched iBEC/iBSS to IPSW..."
rm ipsw/Firmware/dfu/iBEC.$model.RELEASE.im4p
rm ipsw/Firmware/dfu/iBSS.$model.RELEASE.im4p
cp ibec.patched.im4p ipsw/Firmware/dfu/iBEC.$model.RELEASE.im4p
cp ibss.patched.im4p ipsw/Firmware/dfu/iBSS.$model.RELEASE.im4p

echo "==> Creating custom IPSW..."
cd ipsw
zip -q ../custom.ipsw -r0 *
cd ..

echo "==> Cleaning up..."
rm -r ibec.im4p ibss.im4p patch restore.ipsw
echo "==> Downloading ipwndfu..."
if [ $identifier == iPhone6,1 ] || [ $identifier == iPhone6,2 ]; then
git clone https://github.com/LinusHenze/ipwndfu_public.git
mv ipwndfu_public ipwndfu

        cd ipwndfu
        chmod +x ipwndfu
        until [ $string = 1 ];
        do
            
    
			 echo -e "[+]The script will run ipwndfu again and again until the device is in PWNDFU mode"
			
            read -p "[+]Please put your idevice in dfu mode and press enter"
            ./ipwndfu -p &> /dev/null
            ./ipwndfu -p &> /dev/null
            string=$(lsusb | grep -c "Apple, Inc. Mobile Device (DFU Mode)")
        done
        
        
        read -p "[+]Please unplug and plug in your idevice again and press enter"
        ./ipwndfu -p &> /dev/null
        python rmsigchks.py
        cd ..
if [ $string == 1 ]; then
        echo "We seem to be in pwned DFU mode!"

       fi
        
else
git clone https://github.com/twilightmoon4/ipwndfu_public.git
mv ipwndfu_public ipwndfu

        cd ipwndfu
        chmod +x ipwndfu
        until [ $string = 1 ];
        do
            
    
			 echo -e "[+]The script will run ipwndfu again and again until the device is in PWNDFU mode"
			
            read -p "[+]Please put your idevice in dfu mode and press enter"
            ./ipwndfu -p &> /dev/null
            ./ipwndfu -p &> /dev/null
            string=$(lsusb | grep -c "Apple, Inc. Mobile Device (DFU Mode)")
        done
        
        
        read -p "[+]Please unplug and plug in your idevice again and press enter"
        ./ipwndfu -p &> /dev/null
        python rmsigchks.py
        cd ..
if [ $string == 1 ]; then
        echo "We seem to be in pwned DFU mode!"

       fi
fi
        
       

	echo "==> Sending patched iBSS/iBEC to device..."
         sudo ip tuntap add dev tap0 mode tap
         sudo ip link set tap0 up promisc on
         sudo ip link set dev virbr0 up
         sudo ip link set dev tap0 master virbr0	
         sudo virsh net-autostart default
       
	./bin/irecovery -f ibss.patched.im4p
        
	./bin/irecovery -f ibec.patched.im4p

echo "==> Waiting iDevice..."
sleep 10
echo "==> Downloading OTA manifests..."
wget -O manifests.zip https://gitlab.com/devluke/stablea7/raw/master/A7_10.3.3_OTA_Manifests.zip -q --show-progress
unzip -q manifests.zip
rm manifests.zip
	echo "==> Getting ECID and ApNonce..."
        ./bin/igetnonce
	read -p "[+]Copy and paste apnonce and press enter: " apnonce
            read -p "[+]Copy and paste ecid and press enter: " ecid
            echo $identifier   
             echo $ecid
              echo $apnonce


echo "==> Copying OTA manifest..."
cp 10.3.3/BuildManifest_"$identifier"_1033_OTA.plist BuildManifest.plist

if [ $identifier == iPhone6,1 ] || [ $identifier == iPhone6,2 ] || [ $identifier == iPad4,2 ] || [ $identifier == iPad4,5 ]; then
	echo "==> Copying baseband..."
	cp ipsw/Firmware/Mav7Mav8-7.60.00.Release.bbfw baseband.bbfw
	baseband=true
else
	baseband=false
fi

echo "==> Copying SEP..."
if [ $identifier == iPad4,1 ]; then
	cp ipsw/Firmware/all_flash/sep-firmware.j71.RELEASE.im4p sep.im4p
elif [ $identifier == iPad4,2 ]; then
	cp ipsw/Firmware/all_flash/sep-firmware.j72.RELEASE.im4p sep.im4p
elif [ $identifier == iPad4,4 ]; then
	cp ipsw/Firmware/all_flash/sep-firmware.j85.RELEASE.im4p sep.im4p
elif [ $identifier == iPad4,5 ]; then
	cp ipsw/Firmware/all_flash/sep-firmware.j86.RELEASE.im4p sep.im4p
elif [ $identifier == iPhone6,1 ]; then
	cp ipsw/Firmware/all_flash/sep-firmware.n51.RELEASE.im4p sep.im4p
elif [ $identifier == iPhone6,2 ]; then
	cp ipsw/Firmware/all_flash/sep-firmware.n53.RELEASE.im4p sep.im4p
fi


	echo "==> Requesting ticket..."
	./bin/tsschecker -e $ecid -d $identifier -s -o -i 9.9.10.3.3 --buildid 14G60 -m BuildManifest.plist --apnonce $apnonce > /dev/null
	mv *.shsh ota.shsh


echo "==> Cleaning up..."
rm -r 10.3.3 ipsw 


	echo
	read -p "==> Preparation complete! Press enter/return to restore... "

	echo "==> Restoring device to 10.3.3..."
	status=
	if [ $baseband == true ]; then
		./bin/futurerestore -t ota.shsh -s sep.im4p -m BuildManifest.plist -b baseband.bbfw -p BuildManifest.plist custom.ipsw
		status=$?
	else
		./bin/futurerestore -t ota.shsh -s sep.im4p -m BuildManifest.plist --no-baseband custom.ipsw
		status=$?
	fi

	if [ $status -ne 0 ]; then
		echo
		echo "==> Restoring failed. Attempting to exit recovery mode..."
		./bin/futurerestore --exit-recovery &> /dev/null
		if [ $patch == 1 ]; then
			echo "==> You are using the normal patch which probably caused the restore to fail."
			read -p "==> Press enter/return to try restoring again with the rsu patch... "

			read -p "==> Please exit DFU mode and press enter/return... "
			echo "==> Exiting recovery mode..."
			./bin/futurerestore --exit-recovery &> /dev/null

		else
			exit 1
		fi
	fi



echo "==> Deleting work directory..."
cd ..
rm -r StableA7

echo
echo "==> Restore succeeded! Enjoy 10.3.3!"
