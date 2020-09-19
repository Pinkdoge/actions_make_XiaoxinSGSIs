#!/bin/bash

LOCALDIR=`cd "$( dirname $0 )" && pwd`
cd $LOCALDIR

sudo apt install python python3 brotli p7zip openjdk-8-jdk unzip zip curl cpio wget unace unrar zip unzip p7zip-full p7zip-rar sharutils uudeview mpack arj cabextract file-roller device-tree-compiler liblzma-dev liblz4-tool gawk aria2 python3-pip
sudo apt-get update --fix-missing
#curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
#sudo python get-pip.py
sudo pip3 install protobuf 
sudo pip3 install pycrypto 
sudo pip3 install pycryptodome

python --version 
python3 --version
brotli --version
java -version
pip3 --version

chmod -R 777 ./
chown -R root:root ./
