#/bin/bash

#color专用

source ./bin.sh

if [ -e ./out/vendor/euclid ];then
 
 echo "解压img中........"
 mv ./out/vendor/euclid/product.img ./
 mv ./out/vendor/euclid/engineering.aging.img ./
 mv ./out/vendor/euclid/engineering.preversion.img ./
 python3 $bin/imgextractor.py ./product.img ./out
 python3 $bin/imgextractor.py ./engineering.aging.img ./out
 python3 $bin/imgextractor.py ./engineering.preversion.img ./out
fi

echo "解压完成"

echo "开始处理......"

#make_patch
cd ./make
./add_build.sh
./add_etc_vintf_patch/color/add_vintf.sh
cd ../

#build处理
cat ./out/system/system/euclid_build.prop >> ./out/system/system/build.prop
rm -rf ./out/system/system/euclid_build.prop

echo "
#Enable OPPO reserved partition
ro.oppo.oppo_engineer_root=/oppo_engineering
ro.oppo.oppo_product_root=/oppo_product
ro.oppo.oppo_version_root=/oppo_version
" >> ./out/system/system/build.prop

#oppo_selinux通用化处理
selinux="./out/system/system/etc/selinux/"

cp -frp ./make/cp_oppo_selinux/selinux/* ./out/system/system/etc/selinux/
#sed -i '/fingerprint/d' $selinux/mapping/29.0.cil
#sed -i '/oppo/d' $selinux/mapping/29.0.cil
sed -i '/my/d' $selinux/plat_file_contexts
sed -i '/oppo_fingerprint/d' $selinux/plat_property_contexts
sed -i '/key_transfer/d' $selinux/plat_property_contexts
sed -i 's/persist.sys.sr_start        u:object_r:exported_system_prop:s0//g' $selinux/plat_property_contexts
sed -i 's/persist.sys.sr_end          u:object_r:exported_system_prop:s0//g' $selinux/plat_property_contexts
sed -i 's/persist.sys.sau_from_ver    u:object_r:exported_system_prop:s0//g' $selinux/plat_property_contexts
sed -i 's/persist.sys.sau_to_ver      u:object_r:exported_system_prop:s0//g' $selinux/plat_property_contexts
sed -i 's/persist.sys.rbsreason       u:object_r:exported_system_prop:s0//g' $selinux/plat_property_contexts
sed -i 's/user\=smartcard domain\=platform_app type\=app_data_file//g' $selinux/plat_seapp_contexts
sed -i 's/user\=spi domain\=platform_app type\=app_data_file//g' $selinux/plat_seapp_contexts
sed -i 's/user\=_app seinfo\=oppo_theme domain\=oppotheme_app type\=app_data_file levelFrom\=user//g' $selinux/plat_seapp_contexts

#清理空行
sed -i '/^\s*$/d' $selinux/plat_seapp_contexts

rm -rf ./out/system/system/etc/selinux/plat_sepolicy_and_mapping_debug.sha256
rm -rf ./out/system/system/etc/selinux/plat_sepolicy_debug.cil

if [ -e ./out/system/system/product/etc/selinux/mapping ];then

 cp -frp ./make/cp_product_selinux/product_sepolicy.cil ./out/system/system/product/etc/selinux/
 rm -rf ./out/system/system/product/etc/selinux/product_sepolicy_and_mapping_debug.sha256
else
 rm -rf ./out/system/system/product/etc/selinux/product_sepolicy_and_mapping_debug.sha256
fi

#selinux通用化处理
sed -i "/typetransition location_app/d" ./out/system/system/etc/selinux/plat_sepolicy.cil
sed -i '/vendor/d' ./out/system/system/etc/selinux/plat_property_contexts
sed -i 's/sys.usb.config          u:object_r:system_radio_prop:s0//g' ./out/system/system/etc/selinux/plat_property_contexts
sed -i 's/ro.build.fingerprint    u:object_r:fingerprint_prop:s0//g' ./out/system/system/etc/selinux/plat_property_contexts

#合并分区
mv ./out/product/* ./out/system/oppo_product
mv ./out/engineering/* ./out/system/oppo_engineering
rm -rf ./out/system/oppo_product/vendor/firmware
rm -rf ./out/system/oppo_product/vendor/etc/*.png
rm -rf ./out/system/oppo_product/lost+found
rm -rf ./out/system/oppo_engineering/lost+found

#product
sed -i '1d' ./out/config/product_file_contexts
sed -i '1d' ./out/config/product_fs_config

sed -i 's#/product/#/system/oppo_product/#g' ./out/config/product_file_contexts
echo "/system/oppo_product/product u:object_r:system_file:s0" >> ./out/config/product_file_contexts
sed -i 's#product/product#oppo_productt/productt#g' ./out/config/product_fs_config
sed -i 's#product#system/oppo_product#g' ./out/config/product_fs_config
sed -i 's#productt#product#g' ./out/config/product_fs_config
sed -i 's#oppo_system/oppo_product/system/oppo_product#system/oppo_product/product#g' ./out/config/product_fs_config
#sed -i 's#product#system/oppo_product#g' ./out/config/product_fs_config
sed -i '/\/ 0 0 0755/d' ./out/config/product_fs_config

#engineering
sed -i '1d' ./out/config/engineering_file_contexts
sed -i '1d' ./out/config/engineering_fs_config

sed -i '/\?/d' ./out/config/engineering_file_contexts
#sed -i 's#/engineering/#/system/oppo_engineering/#g' ./out/config/engineering_file_contexts
sed -i 's#/engineering#/system/oppo_engineering#g' ./out/config/engineering_file_contexts
sed -i 's#engineering#system/oppo_engineering#g' ./out/config/engineering_fs_config
#sed -i 's#engineering#system/oppo_engineering#g' ./out/config/engineering_fs_config
sed -i '/\/ 0 0 0755/d' ./out/config/engineering_fs_config

#清理空行
sed -i '/^\s*$/d' ./out/config/product_fs_config
sed -i '/^\s*$/d' ./out/config/engineering_fs_config

#fs数据合并
cat ./out/config/product_file_contexts >> ./out/config/system_file_contexts
cat ./out/config/product_fs_config >> ./out/config/system_fs_config
cat ./out/config/engineering_file_contexts >> ./out/config/system_file_contexts
cat ./out/config/engineering_fs_config >> ./out/config/system_fs_config

#删除多余文件
rm -rf ./out/system/system/*.zip
rm -rf ./out/system/ueventd.reserve.rc
rm -rf ./out/system/vendor/*
rm -rf ./out/system/*.qcom
rm -rf ./out/system/system/bin/engineer_system_shell.sh
find ./out/system/oppo_product/decouping_wallpaper/common/ -type f -name 'product_*.png' -delete #> /dev/null 2>&1

#精简
app="./out/system/system/app"
priv="./out/system/system/priv-app"
product_app="./out/system/system/product/app"
product_priv="./out/system/system/product/priv-app"
delete1="./delete/app"
delete2="./delete/priv_app"
delete3="./delete/product/app"
delete4="./delete/product/priv_app"

 echo "精简中........"
 rm -rf ./delete
 mkdir -p ./delete/app
 mkdir -p ./delete/priv_app
 mkdir -p ./delete/product/app
 mkdir -p ./delete/product/priv_app
 
 mv $app/BaiduInput $delete1
 mv $app/OppoCamera $delete1
 mv $app/OppoEngineerCamera $delete1
 #mv $priv/Browser $delete2
 #mv $priv/KeKeMarket $delete2
 #mv $priv/KeKeThemeStore $delete2
 mv $priv/OppoGallery2 $delete2
 mv $product_priv/GooglePlayServicesUpdater $delete4
 mv $product_priv/GmsCore $delete4
 
 echo ""
 echo "精简完成"
 echo "正在压缩精简app......"
 zip -r ./delete.zip ./delete > /dev/null 2>&1
 rm -rf ./out/delete.zip
 mv ./delete.zip ./out
 delete="$(du -sm ./delete | awk '{print $1}' | sed 's/$/&MB/')"
 echo "已精简:$delete"
 rm -rf ./delete
 echo "压缩完成 输出至out目录......"
 
#解压version.img
 mv `find ./out/vendor/euclid -name 'version.*.img'` ./
 python3 $bin/imgextractor.py ./version.*.img ./out
 echo "解压完成"
 cp -frp ./out/version/build.prop ./
 cat ./build.prop >> ./out/system/system/build.prop
 rm -rf ./build.prop
 