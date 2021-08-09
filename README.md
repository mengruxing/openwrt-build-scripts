# OpenWrt 自动编译脚本


## build-env.sh
本脚本配置搭建编译环境


## build-openwrt.sh

本脚本做了以下工作:
1. 自动下载和更新源码
3. 自定义选择功能
3. 自动完成代码定制
4. 自动编译

脚本运行流程
1. 下载最新的`LEDE`源码
2. 应用`lede`补丁
3. 下载子模块
4. 应用`luci`补丁
5. 应用`packages`补丁
6. 生成自定义`.config`
7. 编译

## 自定义功能

### 1. 功能选择
```

# 去除的功能

Target Image
    Use Console Terminal
    Build VMware image files (VMDK)

Global build settings
    Enable IPv6 support in packages <如果不需要IPV6的话>

Extra packages
    autosamba

LuCI
    3. Applications
        luci-app-adbyby-plus
        luci-app-arpbind
        luci-app-autoreboot
        luci-app-diskman
            Include btrfs-progs
            Include lsblk
        luci-app-filetransfer
        luci-app-ipsec-vpnc
        luci-app-nlbwmon
        luci-app-qbittorrent
        luci-app-ramfree
        luci-app-rclone
            Include rclone-webui
            Include rclone-ng
            Include fuse-utils
        luci-app-samba
        luci-app-unblockmusic
            UnblockNeteaseMusic Golang Version
        luci-app-uugamebooster
        luci-app-vsftpd
        luci-app-xlnetacc
    5. Protocols
        luci-proto-bonding

Utilities
    coremark

Multimedia
    Compress executable files with UPX



# 增加的功能

Extra packages
    ipv6helper <如果需要IPV6的话>

LuCI
    3. Applications
        luci-app-ssr-plus
            Include Kcptun
            Include NaiveProxy
            Include Redsocks2
            Include Shadowsocks Rust Client
            Include Shadowsocks Rust Server
            Include Trojan
            Include Shadowsocks V2ray Plugin

```

你可以根据自己的需求，在`build-openwrt.sh`文件中修改

### 2. 菜单顺序调整

```
ShadowdocksR Plus+      10
广告屏蔽大师 Plus+      11 <- 9
解锁网易云灰色歌曲      20 <- 50
上网时间控制            30
ZeroTier                40*
动态 DNS                59
UPnP                    60 <- none (luci)
KMS 服务器              80 <- 100
网络唤醒                90
```
