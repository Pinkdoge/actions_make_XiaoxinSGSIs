#!/bin/bash

#from 迷路的小新大大
#action适配 by Pinkdoge

source ./bin.sh

#静态制作

rm -rf ./out
rm -rf ./SGSI
mkdir ./out

if [ -e ./vendor.img ];then

 echo "解压vendor.img中......"
 python3 $bin/imgextractor.py ./vendor.img ./out
fi

echo "解压system.img中......"
python3 $bin/imgextractor.py ./system.img ./out

cd ./make
./new_fs.sh
cd ../

model="$(cat ./out/system/system/build.prop | grep 'model' | cat)"
echo "当前原包机型为:"
echo "$model"

function normal (){

 echo "当前为正常pt 启用正常处理方案"

 read -p "按任意键开始处理" var
 echo "SGSI化处理开始......."
 
 echo "正在修改system外层"
 cd ./make/ab_boot
 ./ab_boot.sh
 cd ../../
 echo "修改完成"
 
 if [ -e ./out/vendor/euclid/ ];then
  echo "检测到OPPO_Color 启用专用处理......."
  ./oppo.sh
  echo "处理完成 请检查细节部分"
 else
  if [ -e ./out/vendor/oppo/ ];then  
   echo "检测到OPPO_Color 启用专用处理......."
   ./oppo.sh
   echo "处理完成 请检查细节部分"
  fi
 fi

 #重置make
  echo "正在重置make文件夹数据....."
  true > ./make/add_etc/vintf/manifest2
  echo "<!-- oem自定义接口 -->" >> ./make/add_etc/vintf/manifest2
  sed -i '/oem自定义接口/{x;p;x;G}' ./make/add_etc/vintf/manifest2

  true > ./make/add_build/build2
  echo "#oem厂商自定义属性" >> ./make/add_build/build2
  sed -i '/oem厂商自定义属性/{x;p;x;G}' ./make/add_build/build2
 
  true > ./make/add_build/build3
  echo "#oem厂商odm自定义属性" >> ./make/add_build/build3
  sed -i '/oem厂商odm自定义属性/{x;p;x;G}' ./make/add_build/build3
  echo "重置完成"
 
 read -p "请手动修改make_add_build2" var
 read -p "请手动修改make_add_build3" var
 read -p "请手动修改make_add_manifest2" var
 
 echo "" > /dev/null 2>&1
 
 #系统种类检测
 cd ./make
 ./romtype.sh
 cd ../
 
 #抓logcat
 cp -frp ./make/cp_logcat/bin/* ./out/system/system/bin/
 cp -frp ./make/cp_logcat/etc/* ./out/system/system/etc/

 #manifest.xml处理
 rm -rf ./vintf
 rm -rf ./temp
 mkdir ./vintf
 mkdir ./temp

 cp -frp $(find ./out/system/ -type f -name 'manifest.xml') ./vintf/

 manifest="./vintf/manifest.xml"

 if [ ! $manifest = "" ];then
  cp -frp $manifest ./temp/manifest.xml
  rm -rf $manifest
  while IFS= read -r line ;do
  $flag && echo "$line" >> $manifest
   if [ "$line" = "    </vendor-ndk>" ];then
    flag=false
   fi
   if ! $flag && [ "$line" = "    <system-sdk>" ];then
    flag=true 
    cat ./make/add_etc/vintf/manifest1 >> $manifest
    cat ./make/add_etc/vintf/manifest2 >> $manifest
    echo "" >> $manifest
    echo "$line" >> $manifest
   fi
  done < ./temp/manifest.xml
 fi
 cp -frp $manifest ./out/system/system/etc/vintf/
 rm -rf ./vintf
 rm -rf ./temp
 rm -rf ./make/add_etc/vintf/*.bak

 #usb通用化处理
 cp -frp ./make/cp_usb/* ./out/system/

 #selinux通用化处理
 sed -i "/typetransition location_app/d" ./out/system/system/etc/selinux/plat_sepolicy.cil
 sed -i '/vendor/d' ./out/system/system/etc/selinux/plat_property_contexts
 sed -i 's/sys.usb.config          u:object_r:system_radio_prop:s0//g' ./out/system/system/etc/selinux/plat_property_contexts
 sed -i 's/ro.build.fingerprint    u:object_r:fingerprint_prop:s0//g' ./out/system/system/etc/selinux/plat_property_contexts

 #build处理
 sed -i '/ro.apex.updatable/d' ./out/system/system/build.prop
 sed -i '/ro.apex.updatable/d' ./out/system/system/product/build.prop
 echo "#关闭apex更新" >> ./out/system/system/build.prop
 echo "ro.apex.updatable=false" >> ./out/system/system/build.prop
 sed -i 's/ro.product.system./ro.product./g' ./out/system/system/build.prop
 #sed -i '/ro.build.ab_update/d' ./out/system/system/build.prop
 sed -i '/system_root_image/d' ./out/system/system/build.prop
 sed -i '/ro.control_privapp_permissions/d'  ./out/system/system/build.prop 
 sed -i 's/ro.sf.lcd/#&/' ./out/system/system/build.prop
 sed -i 's/ro.sf.lcd/#&/' ./out/system/system/product/build.prop
 cat ./make/add_build/build1 >> ./out/system/system/build.prop
 cat ./make/add_build/build2 >> ./out/system/system/build.prop
 cat ./make/add_build/build3 >> ./out/system/system/build.prop
 rm -rf ./make/add_build/*.bak

 mainkeys="$(grep 'qemu.hw.mainkeys=' ./out/system/system/build.prop)"
 
 if [ $mainkeys ];then
  sed -i 's/qemu.hw.mainkeys\=1/qemu.hw.mainkeys\=0/g' ./out/system/system/build.prop
 else
  echo "" >> ./out/system/system/build.prop
  echo "#启用虚拟键" >> ./out/system/system/build.prop
  echo "qemu.hw.mainkeys=0" >> ./out/system/system/build.prop
 fi

 #删除多余文件
 rm -rf ./out/system/verity_key
 rm -rf ./out/system/sbin/dashd
 rm -rf ./out/system/system/recovery-from-boot.p
 rm -rf ./out/system/system/recovery-from-boot.bak
 rm -rf ./out/system/system/priv-app/com.qualcomm.location
 rm -rf ./out/system/system/etc/permissions/qti_permissions.xml

 #复制文件
 cp -frp ./make/cp_bin/* ./out/system/system/bin/
 cp -frp ./make/cp_etc/* ./out/system/system/etc/

 #lib层处理
 rm -rf ./out/system/system/lib/vndk-29 
 rm -rf ./out/system/system/lib/vndk-sp-29
 rm -rf ./out/system/system/lib64/vndk-29 
 rm -rf ./out/system/system/lib64/vndk-sp-29
 cp -frp ./make/cp_lib/* ./out/system/system/lib
 cp -frp ./make/cp_lib64/* ./out/system/system/lib64
 rm -rf ./out/system/system/lib/*.sh
 rm -rf ./out/system/system/lib64/*.sh
 cd ./make/cp_lib
 ./add_lib_fs.sh
 cd ../../
 cd ./make/cp_lib64
 ./add_lib64_fs.sh
 cd ../../
 sed -i '/vndk-29/ s/^/#/g' ./out/config/system_file_contexts
 sed -i '/vndk-sp-29/ s/^/#/g' ./out/config/system_file_contexts
 sed -i '/vndk-29/ s/^/#/g' ./out/config/system_fs_config
 sed -i '/vndk-sp-29/ s/^/#/g' ./out/config/system_fs_config
 #sed -i '/libdrm\.so/ s/^/#/g' ./out/config/system_file_contexts
 sed -i '/libdrm.so/ s/^/#/g' ./out/config/system_fs_config
 
 #default处理
 sed -i 's/persist.sys.usb.config=none/persist.sys.usb.config=adb/g' ./out/system/system/etc/prop.default
 sed -i 's/ro.secure=1/ro.secure=0/g' ./out/system/system/etc/prop.default
 sed -i 's/ro.debuggable=0/ro.debuggable=1/g' ./out/system/system/etc/prop.default
 #sed -i 's/ro.adb.secure=1/ro.adb.secure=0/g' ./out/system/system/etc/prop.default
 
 if [ -e ./out/vendor ];then
  rm -rf ./default.txt
  cat ./out/vendor/default.prop | grep 'surface_flinger' > ./default.txt 
 fi

 default="$(find ./ -type f -name 'prop.default')"
 if [ ! $default = "" ];then
  if [ -e ./default.txt ];then
   surface_flinger (){
    default="$(find ./ -type f -name 'prop.default')"
    cat $default | grep 'surface_flinger'
   }
   if surface_flinger ;then
    rm -rf ./default.txt
   else
    echo "" >> $default
    cat ./default.txt >> $default
    rm -rf ./default.txt
   fi
  fi
 fi

 #phh化处理
 cp -frp ./make/cp_phh/bin/* ./out/system/system/bin/
 cp -frp ./make/cp_phh/etc/* ./out/system/system/etc/
 cp -frp ./make/cp_phh/framework/* ./out/system/system/framework/
 #cp -frp ./make/cp_phh/lib/* ./out/system/system/lib/
 cp -frp ./make/cp_phh/lib64/* ./out/system/system/lib64/
 #rm -rf ./out/system/system/lib/*.sh
 rm -rf ./out/system/system/lib64/*.sh
 #cd ./make/cp_phh/lib
 #./add_phh_lib_fs.sh
 #cd ../../../
 cd ./make/cp_phh/lib64
 ./add_phh_lib64_fs.sh
 cd ../../../

 #fs数据整合
 cat ./make/add_fs/contexts >> ./out/config/system_file_contexts
 cat ./make/add_fs/fs >> ./out/config/system_fs_config
 cat ./make/add_phh_fs/contexts >> ./out/config/system_file_contexts
 cat ./make/add_phh_fs/fs >> ./out/config/system_fs_config
 cat ./make/add_logcat_fs/contexts >> ./out/config/system_file_contexts
 cat ./make/add_logcat_fs/fs >> ./out/config/system_fs_config
 cd ./make/new_fs
 ./mergefs.sh
 cd ../../
 
 #亮度修复
  echo "启用亮度修复"
  cp -frp $(find ./out/system/ -type f -name 'services.jar') ./fixbug/lightfix/
  cd ./fixbug/lightfix
  ./brightness_fix.sh
  dist="$(find ./services.jar.out/ -type d -name 'dist')"
  if [ ! $dist = "" ];then
   cp -frp $dist/services.jar ../../out/system/system/framework/
  fi
  cd ../../
 
 #bug修复
  echo "启用bug修复"
  cd ./fixbug
   ./fixbug.sh
   cd ../
 
 echo "SGSI化处理完成"
 rm -rf ./make/new_fs
 ./makeimg.sh

}

function mandatory_pt (){

 echo ""
 
}

if [ -L ./out/system/vendor ];then
 mandatory_pt
else
 normal
fi

echo "正在清理工作目录"

if [ -e "./tmp/payload.bin" ];then
 mv ./tmp/*.zip ./
 mv ./tmp/*.bin ./
 rm -rf ./tmp/*
 rm -rf ./compatibility.zip 
 mv ./*.zip ./tmp/
 mv ./*.bin ./tmp/
 rm -rf ./tmp/*.bin
else
 mv ./tmp/*.zip ./
 rm -rf ./tmp/*
 rm -rf ./compatibility.zip
 mv ./*.zip ./tmp/
fi
