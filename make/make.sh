#!/bin/bash

#by 迷路的小新大大

source ./bin.sh

echo "环境初始化中 请稍候......."
chmod -R 777 ./
chown -R root:root ./
rm -rf ./out
rm -rf ./SGSI
echo "初始化环境完成"
echo "请把要解压的刷机包放入tmp文件夹中"
read -p "请输入需要解压的zip包名: " zip
echo "解压当前目录的刷机包中......"
cd ./tmp

if [ -e ./$zip ];then
 7z x ./$zip
 echo "解压zip完成"
else
 echo "当前所输入的刷机包不存在"
fi

#payload.bin检测
if [ -e './payload.bin' ];then
 mv ./payload.bin ../payload
 echo "解压payload.bin中......."
 cd ../
 cd ./payload
 python3 ./payload.py ./payload.bin ./out
 mv ./payload.bin ../tmp
 echo "移动img至输出目录......."

 if [ -e "./out/product.img" ];then
  mv ./out/product.img ../tmp/
 fi

 if [ -e "./out/reserve.img" ];then
  mv ./out/reserve.img ../tmp/
 fi
 
 mv ./out/system.img ../tmp/
 mv ./out/vendor.img ../tmp/
 rm -rf ./out/*
 cd ../
 cd ./tmp
 mv ./system.img ../
 mv ./vendor.img ../

 if [ -e "./product.img" ];then
  mv ./product.img ../
 fi
 
 if [ -e "./res:erve.img" ];then
  mv ./reserve.img ../
 fi
 
 echo "转换完成"
fi

#br检测
if [ -e ./system.new.dat.br ];then
 echo "正在解压system.new.br"
 if [ -e ./system.new.dat.br ];then
  brotli -d system.new.dat.br
  python $bin/sdat2img.py system.transfer.list system.new.dat ./system.img
  mv ./system.img ../
  rm -rf ./system.new.dat
 fi

 if [ -e ./vendor.new.dat.br ];then
  echo "正在解压vendor.new.br"
  brotli -d vendor.new.dat.br
  python $bin/sdat2img.py vendor.transfer.list vendor.new.dat ./vendor.img
  mv ./vendor.img ../
 fi

 if [ -e ./product.new.dat.br ];then
  echo "正在解压product.new.br"
  brotli -d product.new.dat.br
  python $bin/sdat2img.py product.transfer.list product.new.dat ./product.img
  mv ./product.img ../
 fi

 if [ -e ./system_ext.new.dat.br ];then
  echo "正在解压system_ext.new.br"
  brotli -d system_ext.new.dat.br
  python $bin/sdat2img.py system_ext.transfer.list system_ext.new.dat ./system_ext.img
  mv ./system_ext.img ../
 fi
fi

#dat检测
if [ -e ./system.new.dat ];then
 echo "正在转换system.new.dat"
 if [ -e ./system.new.dat ];then
  python $bin/sdat2img.py system.transfer.list system.new.dat ./system.img
  mv ./system.img ../
 fi

 if [ -e ./vendor.new.dat ];then
  python $bin/sdat2img.py vendor.transfer.list vendor.new.dat ./vendor.img
  mv ./vendor.img ../
 fi

 if [ -e ./product.new.dat ];then
  python $bin/sdat2img.py product.transfer.list product.new.dat ./product.img
  mv ./product.img ../
 fi
 
 if [ -e ./system_ext.new.dat ];then
  echo "正在解压system_ext.new.dat"
  python $bin/sdat2img.py system_ext.transfer.list system_ext.new.dat ./system_ext.img
  mv ./system_ext.img ../
 fi
fi

#img检测
if [ -e ./system.img ];then
  mv ./*.img ../
fi

cd ../
if [ -e ./system.img ];then
 ./SGSI.sh
 exit
else
 echo "没有检测到system.img 无法制作SGSI"
fi
