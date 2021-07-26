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
```

# 基础配置

Target Images
    Build LiveCD image (ISO)
    Build PVE/KVM image files (QCOW2)
    Build VirtualBox image files (VDI)
    Build Hyper-V image files (VHDX)
    Build VMware image files (VMDK)


# 删除部分

Target Image
    Use Console Terminal

Extra packages
    autosamba

LuCI
    3. Applications
        luci-app-arpbind
        luci-app-autoreboot
        luci-app-diskman
            Include btrfs-progs
            Include lsblk
        luci-app-filetransfer
        luci-app-ipsec-vpnc
        luci-app-qbittorrent
        luci-app-ramfree
        luci-app-rclone
            Include rclone-webui
            Include rclone-ng
            Include fuse-utils
        luci-app-samba
        luci-app-uugamebooster
        luci-app-vsftpd
        luci-app-xlnetacc
    5. Protocols
        luci-proto-bonding

Utilities
    coremark


# 增加部分

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
    5. Protocols
        luci-proto-ipv6

Network
    odhcp6c
```


你可以根据自己的需求来修改里面的内容
