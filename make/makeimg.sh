#!/bin/bash

#by 迷路的小新大大

source ./bin.sh
LOCALDIR=`cd "$( dirname $0 )" && pwd`
cd $LOCALDIR

echo "
开始打包

当前img大小为: 

_________________

`du -sh ./out/system | awk '{print $1}'`

`du -sm ./out/system | awk '{print $1}' | sed 's/$/&M/'`

`du -sb ./out/system | awk '{print $1}' | sed 's/$/&B/'`
_________________

使用G为单位打包时必须带单位且为整数
使用B为单位打包时无需带单位且在自动识别的大小添加一定大小
推荐用M为单位大小进行打包需带单位且在自动识别的大小添加至少130M大小
"
 size="$(du -sb "./out/system" | awk '{print $1}')"
 ssize=$(($size+136314880))


#mke2fs+e2fsdroid打包
#$bin/mke2fs -L / -t ext4 -b 4096 ./out/system.img $size
#$bin/e2fsdroid -e -T 0 -S ./out/config/system_file_contexts -C ./out/config/system_fs_config  -a /system -f ./out/system ./out/system.img
$bin/mkuserimg_mke2fs.sh "./out/system/" "./out/system.img" ext4 "/system" $ssize -j "0" -T "1230768000" -C "./out/config/system_fs_config" -L "system" "./out/config/system_file_contexts"

echo "打包完成"
echo "输出至SGSI文件夹"

if [ -e ./SGSI ];then
 rm -rf ./SGSI
 mkdir ./SGSI
else
 mkdir ./SGSI
fi

if [ -e ./SGSI ];then
 mv ./out/system.img ./SGSI
 cp -r ./刷机教程.txt ./SGSI
 #检测精简app的zip
 if [ -e ./out/delete.zip ];then
   mv ./out/delete.zip ./SGSI
 fi
fi
