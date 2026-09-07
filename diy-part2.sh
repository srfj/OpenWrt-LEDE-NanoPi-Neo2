#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.0.3/g' package/base-files/files/bin/config_generate

# Modify default theme
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
sed -i 's/OpenWrt/LEDE-srfj/g' package/base-files/files/bin/config_generate

# 设置密码为空（安装固件时无需密码登陆，然后自己修改想要的密码）
sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' package/lean/default-settings/files/zzz-default-settings

# =========修复sunxi A64 ATF + U‑BOOT rmdir目录非空报错=========
# 修复trusted‑firmware‑a
if [ -d package/boot/trusted-firmware-a ]; then
    sed -i 's/rmdir /rm -rf /g' package/boot/trusted-firmware-a/Makefile
fi
# 修复所有u‑boot包，全局替换Makefile内rmdir → rm‑rf
if [ -d package/boot/u-boot ]; then
    find package/boot/u-boot -name "Makefile" -exec sed -i 's/rmdir /rm -rf /g' {} \;
fi

# make defconfig
sed -i 's/^[ \t]*//g' ./.config
make defconfig

# 移除 luci-app-ssr-plus（兜底，防止 defconfig 后回归）
sed -i 's/^CONFIG_DEFAULT_luci-app-ssr-plus=y$/# CONFIG_DEFAULT_luci-app-ssr-plus is not set/' .config
sed -i '/^CONFIG_PACKAGE_luci-app-ssr-plus=y$/d' .config
sed -i '/^CONFIG_PACKAGE_luci-i18n-ssr-plus-zh-cn=y$/d' .config
make defconfig 2>&1 | tail -5

# 验证 ssr-plus 是否已从配置中移除
if grep -q "luci-app-ssr-plus" .config; then
    echo "WARN: luci-app-ssr-plus still present in .config:"
    grep "luci-app-ssr-plus" .config
else
    echo "OK: luci-app-ssr-plus has been removed from .config"
fi
