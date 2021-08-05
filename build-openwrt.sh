#!/usr/bin/env bash

set -ex

# project_name=`date +lede-%Y%m%d-%H%M`
# git clone https://github.com/coolsnowwolf/lede.git ${project_name} && cd ${project_name}

rm -rf lede
git clone https://github.com/coolsnowwolf/lede.git
cd lede

# lede.patch
git apply << EOF
diff --git a/feeds.conf.default b/feeds.conf.default
index 416da4b0c..fe8644f74 100644
--- a/feeds.conf.default
+++ b/feeds.conf.default
@@ -1,8 +1,5 @@
-src-git packages https://github.com/coolsnowwolf/packages
-src-git luci https://github.com/coolsnowwolf/luci
+src-git packages https://github.com/coolsnowwolf/packages.git
+src-git luci https://github.com/coolsnowwolf/luci.git
 src-git routing https://git.openwrt.org/feed/routing.git
 src-git telephony https://git.openwrt.org/feed/telephony.git
-#src-git video https://github.com/openwrt/video.git
-#src-git targets https://github.com/openwrt/targets.git
-#src-git oldpackages http://git.openwrt.org/packages.git
-#src-link custom /usr/src/openwrt/custom-feed
+src-git helloworld https://github.com/fw876/helloworld.git
diff --git a/package/base-files/files/bin/config_generate b/package/base-files/files/bin/config_generate
index 1a047eb37..9eb42167b 100755
--- a/package/base-files/files/bin/config_generate
+++ b/package/base-files/files/bin/config_generate
@@ -296,9 +296,8 @@ generate_static_system() {
 		delete system.ntp
 		set system.ntp='timeserver'
 		set system.ntp.enabled='1'
-		set system.ntp.enable_server='0'
+		set system.ntp.enable_server='1'
 		add_list system.ntp.server='ntp.aliyun.com'
-		add_list system.ntp.server='time1.cloud.tencent.com'
 		add_list system.ntp.server='time.ustc.edu.cn'
 		add_list system.ntp.server='cn.pool.ntp.org'
 	EOF
diff --git a/package/lean/default-settings/files/zzz-default-settings b/package/lean/default-settings/files/zzz-default-settings
index a6e6fa618..208cce36c 100755
--- a/package/lean/default-settings/files/zzz-default-settings
+++ b/package/lean/default-settings/files/zzz-default-settings
@@ -7,9 +7,6 @@ uci set system.@system[0].timezone=CST-8
 uci set system.@system[0].zonename=Asia/Shanghai
 uci commit system
 
-uci set fstab.@global[0].anon_mount=1
-uci commit fstab
-
 rm -f /usr/lib/lua/luci/view/admin_status/index/mwan.htm
 rm -f /usr/lib/lua/luci/view/admin_status/index/upnp.htm
 rm -f /usr/lib/lua/luci/view/admin_status/index/ddns.htm
@@ -30,11 +27,12 @@ sed -i 's/services/nas/g'  /usr/lib/lua/luci/view/minidlna_status.htm
 ln -sf /sbin/ip /usr/bin/ip
 
 sed -i 's#downloads.openwrt.org#mirrors.cloud.tencent.com/lede#g' /etc/opkg/distfeeds.conf
-sed -i 's/root::0:0:99999:7:::/root:\$1\$V4UetPzk\$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow
 
 sed -i "s/# //g" /etc/opkg/distfeeds.conf
 sed -i '/openwrt_luci/ { s/snapshots/releases\/18.06.9/g; }'  /etc/opkg/distfeeds.conf
 
+sed -i '/helloworld/d' /etc/opkg/distfeeds.conf
+
 sed -i '/REDIRECT --to-ports 53/d' /etc/firewall.user
 echo 'iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53' >> /etc/firewall.user
 echo 'iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 53' >> /etc/firewall.user
diff --git a/package/lean/luci-app-adbyby-plus/luasrc/controller/adbyby.lua b/package/lean/luci-app-adbyby-plus/luasrc/controller/adbyby.lua
index 8945605d6..adb78f20f 100644
--- a/package/lean/luci-app-adbyby-plus/luasrc/controller/adbyby.lua
+++ b/package/lean/luci-app-adbyby-plus/luasrc/controller/adbyby.lua
@@ -6,7 +6,7 @@ function index()
 		return
 	end
 	
-	entry({"admin", "services", "adbyby"}, alias("admin", "services", "adbyby", "base"), _("ADBYBY Plus +"), 9).dependent = true
+	entry({"admin", "services", "adbyby"}, alias("admin", "services", "adbyby", "base"), _("ADBYBY Plus +"), 11).dependent = true
 	
 	entry({"admin", "services", "adbyby", "base"}, cbi("adbyby/base"), _("Base Setting"), 10).leaf = true
 	entry({"admin", "services", "adbyby", "advanced"}, cbi("adbyby/advanced"), _("Advance Setting"), 20).leaf = true
@@ -83,4 +83,4 @@ end
 end
 luci.http.prepare_content("application/json")
 luci.http.write_json({ ret=retstring ,retcount=icount})
-end
\ No newline at end of file
+end
diff --git a/package/lean/luci-app-turboacc/po/zh-cn/turboacc.po b/package/lean/luci-app-turboacc/po/zh-cn/turboacc.po
index 9111e3fc4..d6bb3ee95 100644
--- a/package/lean/luci-app-turboacc/po/zh-cn/turboacc.po
+++ b/package/lean/luci-app-turboacc/po/zh-cn/turboacc.po
@@ -1,5 +1,5 @@
 msgid "Turbo ACC Center"
-msgstr "Turbo ACC 网络加速"
+msgstr "网络加速"
 
 msgid "Turbo ACC Acceleration Settings"
 msgstr "Turbo ACC 网络加速设置"
diff --git a/package/lean/luci-app-unblockmusic/luasrc/controller/unblockmusic.lua b/package/lean/luci-app-unblockmusic/luasrc/controller/unblockmusic.lua
index f57543443..c9e9779fc 100644
--- a/package/lean/luci-app-unblockmusic/luasrc/controller/unblockmusic.lua
+++ b/package/lean/luci-app-unblockmusic/luasrc/controller/unblockmusic.lua
@@ -6,7 +6,7 @@ function index()
 		return
 	end
 
-	entry({"admin", "services", "unblockmusic"}, firstchild(), _("Unblock Netease Music"), 50).dependent = false
+	entry({"admin", "services", "unblockmusic"}, firstchild(), _("Unblock Netease Music"), 20).dependent = false
 	
 	entry({"admin", "services", "unblockmusic", "general"}, cbi("unblockmusic/unblockmusic"), _("Base Setting"), 1)
 	entry({"admin", "services", "unblockmusic", "log"}, form("unblockmusic/unblockmusiclog"), _("Log"), 2)
diff --git a/package/lean/luci-app-vlmcsd/luasrc/controller/vlmcsd.lua b/package/lean/luci-app-vlmcsd/luasrc/controller/vlmcsd.lua
index 2a8ab5b13..3a21c1fbe 100644
--- a/package/lean/luci-app-vlmcsd/luasrc/controller/vlmcsd.lua
+++ b/package/lean/luci-app-vlmcsd/luasrc/controller/vlmcsd.lua
@@ -5,7 +5,7 @@ function index()
 		return
 	end
 
-	entry({"admin", "services", "vlmcsd"}, cbi("vlmcsd"), _("KMS Server"), 100).dependent = true
+	entry({"admin", "services", "vlmcsd"}, cbi("vlmcsd"), _("KMS Server"), 80).dependent = true
 	entry({"admin", "services", "vlmcsd", "status"}, call("act_status")).leaf = true
 end
 
diff --git a/package/lean/luci-app-zerotier/luasrc/controller/zerotier.lua b/package/lean/luci-app-zerotier/luasrc/controller/zerotier.lua
index 3ff3eb208..8a6164646 100644
--- a/package/lean/luci-app-zerotier/luasrc/controller/zerotier.lua
+++ b/package/lean/luci-app-zerotier/luasrc/controller/zerotier.lua
@@ -5,14 +5,12 @@ function index()
 		return
 	end
 
-	entry({"admin","vpn"}, firstchild(), "VPN", 45).dependent = false
+	entry({"admin", "services", "zerotier"},firstchild(), _("ZeroTier"), 40).dependent = false
 
-	entry({"admin", "vpn", "zerotier"},firstchild(), _("ZeroTier")).dependent = false
+	entry({"admin", "services", "zerotier", "general"}, cbi("zerotier/settings"), _("Base Setting"), 1)
+	entry({"admin", "services", "zerotier", "log"}, form("zerotier/info"), _("Interface Info"), 2)
 
-	entry({"admin", "vpn", "zerotier", "general"}, cbi("zerotier/settings"), _("Base Setting"), 1)
-	entry({"admin", "vpn", "zerotier", "log"}, form("zerotier/info"), _("Interface Info"), 2)
-
-	entry({"admin", "vpn", "zerotier", "status"}, call("act_status"))
+	entry({"admin", "services", "zerotier", "status"}, call("act_status"))
 end
 
 function act_status()
EOF

./scripts/feeds update -a
./scripts/feeds install -a

# luci.patch
cd feeds/luci
git apply << EOF
diff --git a/applications/luci-app-upnp/luasrc/controller/upnp.lua b/applications/luci-app-upnp/luasrc/controller/upnp.lua
index 95a0ef4..9fbffdf 100644
--- a/applications/luci-app-upnp/luasrc/controller/upnp.lua
+++ b/applications/luci-app-upnp/luasrc/controller/upnp.lua
@@ -11,7 +11,7 @@ function index()
 
 	local page
 
-	page = entry({"admin", "services", "upnp"}, cbi("upnp/upnp"), _("UPnP"))
+	page = entry({"admin", "services", "upnp"}, cbi("upnp/upnp"), _("UPnP"), 60)
 	page.dependent = true
 
 	entry({"admin", "services", "upnp", "status"}, call("act_status")).leaf = true
diff --git a/modules/luci-mod-admin-full/luasrc/controller/admin/network.lua b/modules/luci-mod-admin-full/luasrc/controller/admin/network.lua
index 3792492..d72e88c 100644
--- a/modules/luci-mod-admin-full/luasrc/controller/admin/network.lua
+++ b/modules/luci-mod-admin-full/luasrc/controller/admin/network.lua
@@ -133,11 +133,6 @@ function index()
 		page.title  = _("Static Routes")
 		page.order  = 50
 
-		page = node("admin", "network", "diagnostics")
-		page.target = template("admin_network/diagnostics")
-		page.title  = _("Diagnostics")
-		page.order  = 60
-
 		page = entry({"admin", "network", "diag_ping"}, post("diag_ping"), nil)
 		page.leaf = true
 
EOF
cd -

# packages.patch
cd feeds/packages
git apply << EOF
diff --git a/net/ddns-scripts/files/ddns.config b/net/ddns-scripts/files/ddns.config
index 2f3ed52..96a4b31 100644
--- a/net/ddns-scripts/files/ddns.config
+++ b/net/ddns-scripts/files/ddns.config
@@ -3,7 +3,7 @@
 #
 config ddns "global"
 	option ddns_dateformat "%F %R"
-#	option ddns_rundir "/var/run/ddns"
-#	option ddns_logdir "/var/log/ddns"
+	option ddns_rundir "/var/run/ddns"
+	option ddns_logdir "/var/log/ddns"
 	option ddns_loglines "250"
 	option upd_privateip "0"
diff --git a/net/miniupnpd/files/upnpd.config b/net/miniupnpd/files/upnpd.config
index 9a65bfa..5bf58f4 100644
--- a/net/miniupnpd/files/upnpd.config
+++ b/net/miniupnpd/files/upnpd.config
@@ -1,5 +1,5 @@
 config upnpd config
-	option enabled		0
+	option enabled		1
 	option enable_natpmp	1
 	option enable_upnp	1
 	option secure_mode	1
EOF
cd -

# default.config
cat > ./.config << EOF
CONFIG_TARGET_x86=y
CONFIG_TARGET_x86_64=y
CONFIG_TARGET_x86_64_DEVICE_generic=y
# CONFIG_GRUB_CONSOLE is not set
# CONFIG_VMDK_IMAGES is not set
EOF

make defconfig
make -j8 download
make -j$(nproc) || make -j1 V=s

rm -rf bin/targets

# custom.config
cat > ./.config << EOF
CONFIG_TARGET_x86=y
CONFIG_TARGET_x86_64=y
CONFIG_TARGET_x86_64_DEVICE_generic=y
# CONFIG_GRUB_CONSOLE is not set
# CONFIG_PACKAGE_UnblockNeteaseMusic-Go is not set
# CONFIG_PACKAGE_adbyby is not set
# CONFIG_PACKAGE_autosamba is not set
CONFIG_PACKAGE_boost=y
CONFIG_PACKAGE_boost-date_time=y
CONFIG_PACKAGE_boost-program_options=y
CONFIG_PACKAGE_boost-system=y
CONFIG_PACKAGE_ca-certificates=y
# CONFIG_PACKAGE_coremark is not set
CONFIG_PACKAGE_ip6tables=y
CONFIG_PACKAGE_ipt2socks=y
# CONFIG_PACKAGE_iptables-mod-ipsec is not set
CONFIG_PACKAGE_kcptun-client=y
CONFIG_PACKAGE_kcptun-config=y
# CONFIG_PACKAGE_kmod-bonding is not set
# CONFIG_PACKAGE_kmod-crypto-cbc is not set
# CONFIG_PACKAGE_kmod-crypto-deflate is not set
# CONFIG_PACKAGE_kmod-crypto-des is not set
# CONFIG_PACKAGE_kmod-crypto-echainiv is not set
# CONFIG_PACKAGE_kmod-crypto-md5 is not set
# CONFIG_PACKAGE_kmod-ipsec is not set
# CONFIG_PACKAGE_kmod-ipt-ipsec is not set
# CONFIG_PACKAGE_kmod-iptunnel6 is not set
# CONFIG_PACKAGE_kmod-nf-conntrack-netlink is not set
CONFIG_PACKAGE_libatomic=y
CONFIG_PACKAGE_libevent2=y
# CONFIG_PACKAGE_libgmp is not set
# CONFIG_PACKAGE_luci-app-adbyby-plus is not set
# CONFIG_PACKAGE_luci-app-arpbind is not set
# CONFIG_PACKAGE_luci-app-autoreboot is not set
# CONFIG_PACKAGE_luci-app-diskman_INCLUDE_btrfs_progs is not set
# CONFIG_PACKAGE_luci-app-diskman_INCLUDE_lsblk is not set
# CONFIG_PACKAGE_luci-app-filetransfer is not set
# CONFIG_PACKAGE_luci-app-ipsec-vpnd is not set
# CONFIG_PACKAGE_luci-app-nlbwmon is not set
# CONFIG_PACKAGE_luci-app-qbittorrent is not set
# CONFIG_PACKAGE_luci-app-ramfree is not set
# CONFIG_PACKAGE_luci-app-rclone_INCLUDE_fuse-utils is not set
# CONFIG_PACKAGE_luci-app-rclone_INCLUDE_rclone-ng is not set
# CONFIG_PACKAGE_luci-app-rclone_INCLUDE_rclone-webui is not set
# CONFIG_PACKAGE_luci-app-samba is not set
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Kcptun=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_NaiveProxy=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Redsocks2=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Rust_Client=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Rust_Server=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Trojan=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_V2ray_Plugin=y
# CONFIG_PACKAGE_luci-app-unblockmusic is not set
# CONFIG_PACKAGE_luci-app-unblockmusic_INCLUDE_UnblockNeteaseMusic_Go is not set
# CONFIG_PACKAGE_luci-app-uugamebooster is not set
# CONFIG_PACKAGE_luci-app-vsftpd is not set
# CONFIG_PACKAGE_luci-app-xlnetacc is not set
# CONFIG_PACKAGE_luci-lib-fs is not set
# CONFIG_PACKAGE_luci-proto-bonding is not set
CONFIG_PACKAGE_luci-proto-ipv6=y
CONFIG_PACKAGE_naiveproxy=y
# CONFIG_PACKAGE_nlbwmon is not set
CONFIG_PACKAGE_odhcp6c=y
CONFIG_PACKAGE_odhcp6c_ext_cer_id=0
CONFIG_PACKAGE_odhcpd=y
CONFIG_PACKAGE_odhcpd_full_ext_cer_id=0
# CONFIG_PACKAGE_proto-bonding is not set
# CONFIG_PACKAGE_qBittorrent-static is not set
CONFIG_PACKAGE_redsocks2=y
# CONFIG_PACKAGE_samba36-server is not set
CONFIG_PACKAGE_shadowsocks-rust-sslocal=y
CONFIG_PACKAGE_shadowsocks-rust-ssserver=y
# CONFIG_PACKAGE_strongswan is not set
CONFIG_PACKAGE_trojan=y
# CONFIG_PACKAGE_uugamebooster is not set
CONFIG_PACKAGE_v2ray-plugin=y
# CONFIG_PACKAGE_vsftpd-alt is not set
# CONFIG_PACKAGE_wsdd2 is not set
# CONFIG_UNBLOCKNETEASEMUSIC_GO_COMPRESS_UPX is not set
# CONFIG_VMDK_IMAGES is not set
CONFIG_boost-compile-visibility-hidden=y
CONFIG_boost-runtime-shared=y
CONFIG_boost-static-and-shared-libs=y
CONFIG_boost-variant-release=y
EOF

make defconfig
make -j8 download
make -j$(nproc) || make -j1 V=s
date
echo "编译完成!"
