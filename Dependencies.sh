#!/bin/bash

beta=true

if [ -e "build" ]; then
echo "[+] Build folder exists! If the script doesn't work please delete the 'Build' folder and run it again"
          
else	
sudo apt-get --fix-broken install
sudo apt-get update
sudo apt-get --fix-broken install
sudo apt-get build-dep
sudo apt-get install -y git build-essential make autoconf \
automake libtool openssl tar perl binutils gcc g++ \
                libc6-dev libssl-dev libusb-1.0-0-dev \
                libcurl4-gnutls-dev fuse libxml2-dev \
                libgcc1 libreadline-dev libglib2.0-dev libzip-dev \
                libclutter-1.0-dev ifuse python3-pip python-pip  \
                libfuse-dev cython python2.7 \
                libncurses5 libusbmuxd-dev usbmuxd libplist++-dev libplist-utils \
                libplist-dev libimobiledevice-dev ideviceinstaller libusb-dev \
                zip unzip libimobiledevice-utils libgcrypt20-doc gnutls-doc \
                gnutls-bin git libplist++ python2.7-dev \
                python3-dev libusbmuxd4 libreadline6-dev libusb-dev \
                libzip-dev libssl-dev m4 bsdiff qemu uml-utilities virt-manager git wget libguestfs-tools
                
cd bin
chmod +x *
cd .. 			 
 mkdir build
  cd build

        libs=( "libusbmuxd" "usbmuxd" "libirecovery" \
                "ideviceinstaller" "libideviceactivation" "ifuse" )
                 
                for i in "${libs[@]}"
                do
                        echo -e "Fetching $i..."
                        git clone https://github.com/libimobiledevice/${i}.git
                        cd $i
                        echo -e "Configuring $i..."
                        ./autogen.sh
                        ./configure
                        echo -e "Building $i..."
                        make && sudo make install
                        echo -e "Installing $i..."
                        cd ..
                  
                done 


echo "==> Checking for libirecovery..."
which irecovery > /dev/null
if [ $? -ne 0 ]; then
	echo "==> Downloading libirecovery..."
	git clone https://github.com/libimobiledevice/libirecovery.git

	echo "==> Making libirecovery..."
	cd libirecovery
        git submodule init && git submodule update
	./autogen.sh && make

	echo
	echo "==> Installing libirecovery. This might ask for your password..."
	sudo make install
	cd ..
	rm -rf libirecovery
fi

echo "==> Checking for libfragmentzip..."
if [ ! -d /usr/local/include/libfragmentzip ]; then
	echo "==> Downloading libfragmentzip..."
	git clone https://github.com/tihmstar/libfragmentzip.git
        git clone https://github.com/tihmstar/libgeneral.git
	echo "==> Making libfragmentzip..."
cd libgeneral
    git submodule init && git submodule update
     
	./autogen.sh && make

	echo
	echo "==> Installing libgeneral. This might ask for your password..."
	sudo make install
	cd ..
	rm -rf libgeneral
	cd libfragmentzip
    git submodule init && git submodule update
     
	./autogen.sh && make

	echo
	echo "==> Installing libfragmentzip. This might ask for your password..."
	sudo make install
	cd ..
	rm -rf libfragmentzip
fi
echo -e "==> Grabbing dependencies and installing!"

                git clone https://github.com/lzfse/lzfse.git
				git clone https://github.com/s0uthwest/libimobiledevice.git
				git clone https://github.com/s0uthwest/idevicerestore.git
				git clone https://github.com/merculous/futurerestore.git
				git clone https://github.com/tihmstar/img4tool.git
				git clone https://github.com/tihmstar/tsschecker.git
                                git clone https://github.com/tihmstar/igetnonce.git


				export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"

			       cd lzfse
                              git submodule init 
                            git submodule update
                             
				./autogen.sh
				./configure
				make 
                                sudo make install
				cd ..
                            cd libimobiledevice
                           git submodule init
                          git submodule update
                            
				./autogen.sh
				./configure
				make 
                              sudo make install
				cd ..
                                 cd idevicerestore
                           git submodule init
                          git submodule update
                            
				./autogen.sh
				./configure
				make 
                              sudo make install
				cd ..
                               cd futurerestore
                           git submodule init 
                          
                           cd external
                           rmdir idevicerestore
                           rmdir tsschecker
                           rmdir img4tool
                           git clone https://github.com/s0uthwest/idevicerestore.git
                           git clone https://github.com/s0uthwest/tsschecker.git
                           git clone https://github.com/tihmstar/img4tool.git
                           cd tsschecker
                           cd external
                        rmdir jssy
                        git clone https://github.com/tihmstar/jssy.git
                           cd ..
                           cd ..
                           
                           cd ..
				./autogen.sh
				./configure
				make && sudo make install
				cd .. 
                               cd img4tool
                          git submodule init 
                       git submodule update
                        
				./autogen.sh
				./configure
				make           
                                sudo make install
				cd ..
                                cd tsschecker
                            git submodule init
                        git submodule update
                        cd external
                        rmdir jssy
                        git clone https://github.com/tihmstar/jssy.git
                         cd ..
				./autogen.sh
				./configure
				make
                                sudo make install
                               cd .. 
                              cd igetnonce
                           git submodule init
                     git submodule update
				./autogen.sh
				./configure
				make 
                               sudo make install
                            cd ..
wget -O support.deb http://archive.ubuntu.com/ubuntu/pool/main/g/glibc/multiarch-support_2.29-0ubuntu2_amd64.deb -q --show-progress
wget -O libssl.deb http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb -q --show-progress
sudo dpkg -i support.deb
sudo dpkg -i libssl.deb
sudo apt-get --fix-broken install
                            cd ..
sudo apt-get install libcurl4-openssl-dev
sudo ln -s libzip.so /usr/lib/x86_64-linux-gnu/libzip.so.2
pip install pyusb
pip3 install pyusb
sudo ldconfig
fi
