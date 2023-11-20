#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic s9xxx tv box
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/coolsnowwolf/lede / Branch: master
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
# sed -i 's/luci-theme-bootstrap/luci-theme-material/g' ./feeds/luci/collections/luci/Makefile

# Add autocore support for armvirt
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/lean/default-settings/files/zzz-default-settings
echo "DISTRIB_SOURCECODE='lede'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate

# Replace the default software source
# sed -i 's#openwrt.proxy.ustclug.org#mirrors.bfsu.edu.cn\\/openwrt#' package/lean/default-settings/files/zzz-default-settings
#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic

# Fix runc version error
# rm -rf ./feeds/packages/utils/runc/Makefile
# svn export https://github.com/openwrt/packages/trunk/utils/runc/Makefile ./feeds/packages/utils/runc/Makefile

# coolsnowwolf default software package replaced with Lienol related software package
# rm -rf feeds/packages/utils/{containerd,libnetwork,runc,tini}
# svn co https://github.com/Lienol/openwrt-packages/trunk/utils/{containerd,libnetwork,runc,tini} feeds/packages/utils

# Add third-party software packages (The entire repository)
# git clone https://github.com/libremesh/lime-packages.git package/lime-packages
# Add third-party software packages (Specify the package)
# svn co https://github.com/libremesh/lime-packages/trunk/packages/{shared-state-pirania,pirania-app,pirania} package/lime-packages/packages
# Add to compile options (Add related dependencies according to the requirements of the third-party software package Makefile)
# sed -i "/DEFAULT_PACKAGES/ s/$/ pirania-app pirania ip6tables-mod-nat ipset shared-state-pirania uhttpd-mod-lua/" target/linux/armvirt/Makefile

# Apply patch
# git apply ../config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# 修改内核6.1
# sed -i 's/KERNEL_PATCHVER:=5.15/KERNEL_PATCHVER:=6.1/g' target/linux/x86/Makefile
# sed -i 's/KERNEL_TESTING_PATCHVER:=6.1/KERNEL_TESTING_PATCHVER:=5.15/g' target/linux/x86/Makefile

# 修改openwrt登陆地址,把下面的192.168.6.1修改成你想要的就可以了
sed -i 's/192.168.1.1/192.168.5.2/g' package/base-files/files/bin/config_generate

# 修改主机名字，把OpenWrt-1.0修改你喜欢的就行（不能纯数字或者使用中文）
# sed -i '/uci commit system/i\uci set system.@system[0].hostname='OpenWrt-1.0'' package/lean/default-settings/files/zzz-default-settings

# 版本号里显示一个自己的名字（Lan build $(TZ=UTC-8 date "+%Y.%m.%d") @ 这些都是后增加的）
sed -i "s/OpenWrt /Lan build $(TZ=UTC-8 date "+%Y%m%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings
       
# 修改argon为默认主题,可根据你喜欢的修改成其他的（不选择那些会自动改变为默认主题的主题才有效果）
# sed -i 's/luci-theme-bootstrap/luci-theme-argon-lean/g' feeds/luci/collections/luci/Makefile

# 设置密码为空（安装固件时无需密码登陆，然后自己修改想要的密码）
# sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' package/lean/default-settings/files/zzz-default-settings

# 修改概览里时间显示为中文数字
# sed -i 's/os.date()/os.date("%Y年%m月%d日") .. " " .. translate(os.date("%A")) .. " " .. os.date("%X")/g' package/lean/autocore/files/arm/index.htm
sed -i 's/os.date()/os.date("%Y年%m月%d日") .. " " .. translate(os.date("%A")) .. " " .. os.date("%X")/g' package/lean/autocore/files/x86/index.htm

# 修改插件名字（修改名字后不知道会不会对插件功能有影响，自己多测试）
sed -i 's/"网络存储"/"存储"/g' feeds/luci/applications/luci-app-vsftpd/po/zh-cn/vsftpd.po
sed -i 's/"网络存储"/"存储"/g' feeds/luci/applications/luci-app-usb-printer/po/zh-cn/usb-printer.po
# sed -i 's/"BaiduPCS Web"/"百度网盘"/g' feeds/luci/applications/luci-app-baidupcs-web/luasrc/controller/baidupcs-web.lua
sed -i 's/"带宽监控"/"带宽"/g' feeds/luci/applications/luci-app-nlbwmon/po/zh-cn/nlbwmon.po
sed -i 's/"实时流量监测"/"流量"/g' feeds/luci/applications/luci-app-wrtbwmon/po/zh-cn/wrtbwmon.po

# ------------------------------- Other ends -------------------------------
