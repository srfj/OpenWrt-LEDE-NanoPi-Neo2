#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Themes
# 移除要替换的包
rm -rf feeds/luci/themes/luci-theme-argon
# 添加主题
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon


# 添加软件包
git clone https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall
git clone https://github.com/xiaorouji/openwrt-passwall package/luci-app-passwall
