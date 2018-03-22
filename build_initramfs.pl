#!/usr/bin/perl -w

use Term::ANSIColor;
use Term::ANSIColor qw(:constants);
use strict;

my $initrd_dir = "/home/ming/initramfs/initramfs";
my $latest_kernel = `uname -r`;
chomp($latest_kernel);
my $modules_dir = "/lib/modules/$latest_kernel";

my $files = <<"FILES_END";
kernel
kernel/arch
kernel/arch/x86
kernel/arch/x86/crypto
kernel/arch/x86/crypto/ablk_helper.ko.xz
kernel/arch/x86/crypto/aesni-intel.ko.xz
kernel/arch/x86/crypto/blowfish-x86_64.ko.xz
kernel/arch/x86/crypto/camellia-aesni-avx-x86_64.ko.xz
kernel/arch/x86/crypto/camellia-aesni-avx2.ko.xz
kernel/arch/x86/crypto/camellia-x86_64.ko.xz
kernel/arch/x86/crypto/cast5-avx-x86_64.ko.xz
kernel/arch/x86/crypto/cast6-avx-x86_64.ko.xz
kernel/arch/x86/crypto/crc32-pclmul.ko.xz
kernel/arch/x86/crypto/crc32c-intel.ko.xz
kernel/arch/x86/crypto/crct10dif-pclmul.ko.xz
kernel/arch/x86/crypto/ghash-clmulni-intel.ko.xz
kernel/arch/x86/crypto/glue_helper.ko.xz
kernel/arch/x86/crypto/salsa20-x86_64.ko.xz
kernel/arch/x86/crypto/serpent-avx-x86_64.ko.xz
kernel/arch/x86/crypto/serpent-avx2.ko.xz
kernel/arch/x86/crypto/serpent-sse2-x86_64.ko.xz
kernel/arch/x86/crypto/sha-mb
kernel/arch/x86/crypto/sha-mb/sha1-mb.ko.xz
kernel/arch/x86/crypto/sha256-mb
kernel/arch/x86/crypto/sha256-mb/sha256-mb.ko.xz
kernel/arch/x86/crypto/sha512-mb
kernel/arch/x86/crypto/sha512-mb/sha512-mb.ko.xz
kernel/arch/x86/crypto/sha512-ssse3.ko.xz
kernel/arch/x86/crypto/twofish-avx-x86_64.ko.xz
kernel/arch/x86/crypto/twofish-x86_64-3way.ko.xz
kernel/arch/x86/crypto/twofish-x86_64.ko.xz
kernel/crypto
kernel/crypto/algif_rng.ko.xz
kernel/crypto/ansi_cprng.ko.xz
kernel/crypto/anubis.ko.xz
kernel/crypto/arc4.ko.xz
kernel/crypto/async_tx
kernel/crypto/async_tx/async_memcpy.ko.xz
kernel/crypto/async_tx/async_pq.ko.xz
kernel/crypto/async_tx/async_raid6_recov.ko.xz
kernel/crypto/async_tx/async_tx.ko.xz
kernel/crypto/async_tx/async_xor.ko.xz
kernel/crypto/async_tx/raid6test.ko.xz
kernel/crypto/authenc.ko.xz
kernel/crypto/authencesn.ko.xz
kernel/crypto/twofish_generic.ko.xz
kernel/crypto/blowfish_common.ko.xz
kernel/crypto/wp512.ko.xz
kernel/crypto/blowfish_generic.ko.xz
kernel/crypto/vmac.ko.xz
kernel/crypto/camellia_generic.ko.xz
kernel/crypto/cast5_generic.ko.xz
kernel/crypto/cast6_generic.ko.xz
kernel/crypto/cast_common.ko.xz
kernel/crypto/ccm.ko.xz
kernel/crypto/cmac.ko.xz
kernel/crypto/crc32_generic.ko.xz
kernel/crypto/xcbc.ko.xz
kernel/crypto/crct10dif_common.ko.xz
kernel/crypto/xor.ko.xz
kernel/crypto/crct10dif_generic.ko.xz
kernel/crypto/cryptd.ko.xz
kernel/crypto/crypto_null.ko.xz
kernel/crypto/crypto_user.ko.xz
kernel/crypto/cts.ko.xz
kernel/crypto/deflate.ko.xz
kernel/crypto/des_generic.ko.xz
kernel/crypto/dh_generic.ko.xz
kernel/crypto/drbg.ko.xz
kernel/crypto/fcrypt.ko.xz
kernel/crypto/gcm.ko.xz
kernel/crypto/gf128mul.ko.xz
kernel/crypto/ghash-generic.ko.xz
kernel/crypto/xts.ko.xz
kernel/crypto/jitterentropy_rng.ko.xz
kernel/crypto/khazad.ko.xz
kernel/crypto/lrw.ko.xz
kernel/crypto/mcryptd.ko.xz
kernel/crypto/md4.ko.xz
kernel/crypto/michael_mic.ko.xz
kernel/crypto/pcbc.ko.xz
kernel/crypto/pcrypt.ko.xz
kernel/crypto/rmd128.ko.xz
kernel/crypto/rmd160.ko.xz
kernel/crypto/rmd256.ko.xz
kernel/crypto/rmd320.ko.xz
kernel/crypto/rsa_generic.ko.xz
kernel/crypto/zlib.ko.xz
kernel/crypto/salsa20_generic.ko.xz
kernel/crypto/seed.ko.xz
kernel/crypto/serpent_generic.ko.xz
kernel/crypto/sha512_generic.ko.xz
kernel/crypto/tcrypt.ko.xz
kernel/crypto/tea.ko.xz
kernel/crypto/tgr192.ko.xz
kernel/crypto/twofish_common.ko.xz
kernel/drivers
kernel/drivers/acpi
kernel/drivers/acpi/video.ko.xz
kernel/drivers/ata
kernel/drivers/ata/ahci.ko.xz
kernel/drivers/ata/ata_generic.ko.xz
kernel/drivers/ata/ata_piix.ko.xz
kernel/drivers/ata/libahci.ko.xz
kernel/drivers/ata/libata.ko.xz
kernel/drivers/ata/pata_acpi.ko.xz
kernel/drivers/block
kernel/drivers/block/virtio_blk.ko.xz
kernel/drivers/char
kernel/drivers/char/virtio_console.ko.xz
kernel/drivers/dca
kernel/drivers/dca/dca.ko.xz
kernel/drivers/i2c
kernel/drivers/i2c/i2c-core.ko.xz
kernel/drivers/i2c/algos
kernel/drivers/i2c/algos/i2c-algo-bit.ko.xz
kernel/drivers/i2c/busses
kernel/drivers/i2c/busses/i2c-piix4.ko.xz
kernel/drivers/input
kernel/drivers/input/serio
kernel/drivers/input/serio/serio_raw.ko.xz
kernel/drivers/md
kernel/drivers/md/dm-crypt.ko.xz
kernel/drivers/md/dm-log-userspace.ko.xz
kernel/drivers/md/dm-log.ko.xz
kernel/drivers/md/dm-mirror.ko.xz
kernel/drivers/md/dm-mod.ko.xz
kernel/drivers/md/dm-raid.ko.xz
kernel/drivers/md/dm-region-hash.ko.xz
kernel/drivers/md/linear.ko.xz
kernel/drivers/md/raid0.ko.xz
kernel/drivers/md/raid1.ko.xz
kernel/drivers/md/raid10.ko.xz
kernel/drivers/md/raid456.ko.xz
kernel/drivers/mmc
kernel/drivers/mmc/core
kernel/drivers/mmc/core/mmc_core.ko.xz
kernel/drivers/net
kernel/drivers/net/mdio.ko.xz
kernel/drivers/net/ethernet
kernel/drivers/net/ethernet/broadcom
kernel/drivers/net/ethernet/broadcom/b44.ko.xz
kernel/drivers/net/ethernet/broadcom/bnx2.ko.xz
kernel/drivers/net/ethernet/broadcom/bnx2x
kernel/drivers/net/ethernet/broadcom/bnx2x/bnx2x.ko.xz
kernel/drivers/net/ethernet/broadcom/bnxt
kernel/drivers/net/ethernet/broadcom/bnxt/bnxt_en.ko.xz
kernel/drivers/net/ethernet/broadcom/cnic.ko.xz
kernel/drivers/net/ethernet/broadcom/tg3.ko.xz
kernel/drivers/net/ethernet/intel
kernel/drivers/net/ethernet/intel/e1000
kernel/drivers/net/ethernet/intel/e1000/e1000.ko.xz
kernel/drivers/net/ethernet/intel/e1000e
kernel/drivers/net/ethernet/intel/e1000e/e1000e.ko.xz
kernel/drivers/net/ethernet/intel/igb
kernel/drivers/net/ethernet/intel/igb/igb.ko.xz
kernel/drivers/net/ethernet/intel/igbvf
kernel/drivers/net/ethernet/intel/igbvf/igbvf.ko.xz
kernel/drivers/net/ethernet/intel/ixgbe
kernel/drivers/net/ethernet/intel/ixgbe/ixgbe.ko.xz
kernel/drivers/net/ethernet/intel/ixgbevf
kernel/drivers/net/ethernet/intel/ixgbevf/ixgbevf.ko.xz
kernel/drivers/net/ethernet/realtek
kernel/drivers/net/ethernet/realtek/8139cp.ko.xz
kernel/drivers/net/ethernet/realtek/8139too.ko.xz
kernel/drivers/net/ethernet/realtek/r8169.ko.xz
kernel/drivers/net/mii.ko.xz
kernel/drivers/net/ifb.ko.xz
kernel/drivers/net/vxlan.ko.xz
kernel/drivers/net/ppp
kernel/drivers/net/ppp/bsd_comp.ko.xz
kernel/drivers/net/ppp/ppp_async.ko.xz
kernel/drivers/net/ppp/ppp_deflate.ko.xz
kernel/drivers/net/ppp/ppp_generic.ko.xz
kernel/drivers/net/ppp/ppp_mppe.ko.xz
kernel/drivers/net/ppp/ppp_synctty.ko.xz
kernel/drivers/net/ppp/pppoe.ko.xz
kernel/drivers/net/ppp/pppox.ko.xz
kernel/drivers/net/ppp/pptp.ko.xz
kernel/drivers/net/tun.ko.xz
kernel/drivers/net/virtio_net.ko.xz
kernel/drivers/ptp
kernel/drivers/ptp/ptp.ko.xz
kernel/drivers/pps
kernel/drivers/pps/pps_core.ko.xz
kernel/drivers/scsi
kernel/drivers/scsi/iscsi_boot_sysfs.ko.xz
kernel/drivers/scsi/iscsi_tcp.ko.xz
kernel/drivers/scsi/libiscsi.ko.xz
kernel/drivers/scsi/libiscsi_tcp.ko.xz
kernel/drivers/scsi/sd_mod.ko.xz
kernel/drivers/scsi/sr_mod.ko.xz
kernel/drivers/scsi/virtio_scsi.ko.xz
kernel/drivers/ssb
kernel/drivers/ssb/ssb.ko.xz
kernel/drivers/uio
kernel/drivers/uio/uio.ko.xz
kernel/drivers/virtio
kernel/drivers/virtio/virtio.ko.xz
kernel/drivers/virtio/virtio_pci.ko.xz
kernel/drivers/virtio/virtio_input.ko.xz
kernel/drivers/virtio/virtio_ring.ko.xz
kernel/fs
kernel/fs/mbcache.ko.xz
kernel/fs/ext4
kernel/fs/ext4/ext4.ko.xz
kernel/fs/fat
kernel/fs/fat/fat.ko.xz
kernel/fs/fat/msdos.ko.xz
kernel/fs/fat/vfat.ko.xz
kernel/fs/jbd2
kernel/fs/jbd2/jbd2.ko.xz
kernel/fs/nfs
kernel/fs/nfs/blocklayout
kernel/fs/nfs/blocklayout/blocklayoutdriver.ko.xz
kernel/fs/nfs/filelayout
kernel/fs/nfs/filelayout/nfs_layout_nfsv41_files.ko.xz
kernel/fs/nfs/flexfilelayout
kernel/fs/nfs/flexfilelayout/nfs_layout_flexfiles.ko.xz
kernel/fs/nfs/nfs.ko.xz
kernel/fs/nfs/nfsv3.ko.xz
kernel/fs/nfs/nfsv4.ko.xz
kernel/fs/nfs/objlayout
kernel/fs/nfs/objlayout/objlayoutdriver.ko.xz
kernel/fs/nfs_common
kernel/fs/nfs_common/grace.ko.xz
kernel/fs/nfs_common/nfs_acl.ko.xz
kernel/fs/nfsd
kernel/fs/nfsd/nfsd.ko.xz
kernel/fs/overlayfs
kernel/fs/overlayfs/overlay.ko.xz
kernel/fs/squashfs
kernel/fs/squashfs/squashfs.ko.xz
kernel/fs/xfs
kernel/fs/xfs/xfs.ko.xz
kernel/lib
kernel/lib/crc-itu-t.ko.xz
kernel/lib/crc-t10dif.ko.xz
kernel/lib/libcrc32c.ko.xz
kernel/net/
kernel/net/802
kernel/net/802/stp.ko.xz
kernel/net/8021q
kernel/net/8021q/8021q.ko.xz
kernel/net/bridge
kernel/net/bridge/br_netfilter.ko.xz
kernel/net/bridge/bridge.ko.xz
kernel/net/bridge/netfilter
kernel/net/bridge/netfilter/ebt_802_3.ko.xz
kernel/net/bridge/netfilter/ebt_among.ko.xz
kernel/net/bridge/netfilter/ebt_arp.ko.xz
kernel/net/bridge/netfilter/ebt_arpreply.ko.xz
kernel/net/bridge/netfilter/ebt_dnat.ko.xz
kernel/net/bridge/netfilter/ebt_ip.ko.xz
kernel/net/bridge/netfilter/ebt_ip6.ko.xz
kernel/net/bridge/netfilter/ebt_limit.ko.xz
kernel/net/bridge/netfilter/ebt_log.ko.xz
kernel/net/bridge/netfilter/ebt_mark.ko.xz
kernel/net/bridge/netfilter/ebt_mark_m.ko.xz
kernel/net/bridge/netfilter/ebt_nflog.ko.xz
kernel/net/bridge/netfilter/ebt_pkttype.ko.xz
kernel/net/bridge/netfilter/ebt_redirect.ko.xz
kernel/net/bridge/netfilter/ebt_snat.ko.xz
kernel/net/bridge/netfilter/ebt_stp.ko.xz
kernel/net/bridge/netfilter/ebt_ulog.ko.xz
kernel/net/bridge/netfilter/ebt_vlan.ko.xz
kernel/net/bridge/netfilter/ebtable_broute.ko.xz
kernel/net/bridge/netfilter/ebtable_filter.ko.xz
kernel/net/bridge/netfilter/ebtable_nat.ko.xz
kernel/net/bridge/netfilter/ebtables.ko.xz
kernel/net/bridge/netfilter/nf_log_bridge.ko.xz
kernel/net/bridge/netfilter/nf_tables_bridge.ko.xz
kernel/net/bridge/netfilter/nft_meta_bridge.ko.xz
kernel/net/bridge/netfilter/nft_reject_bridge.ko.xz
kernel/net/core
kernel/net/core/devlink.ko.xz
kernel/net/core/pktgen.ko.xz
kernel/net/dns_resolver
kernel/net/dns_resolver/dns_resolver.ko.xz
kernel/net/ipv4
kernel/net/ipv4/ah4.ko.xz
kernel/net/ipv4/esp4.ko.xz
kernel/net/ipv4/gre.ko.xz
kernel/net/ipv4/inet_diag.ko.xz
kernel/net/ipv4/ip_gre.ko.xz
kernel/net/ipv4/ip_tunnel.ko.xz
kernel/net/ipv4/ip_vti.ko.xz
kernel/net/ipv4/ipcomp.ko.xz
kernel/net/ipv4/ipip.ko.xz
kernel/net/ipv4/netfilter
kernel/net/ipv4/netfilter/arp_tables.ko.xz
kernel/net/ipv4/netfilter/arpt_mangle.ko.xz
kernel/net/ipv4/netfilter/arptable_filter.ko.xz
kernel/net/ipv4/netfilter/ip_tables.ko.xz
kernel/net/ipv4/netfilter/ipt_CLUSTERIP.ko.xz
kernel/net/ipv4/netfilter/ipt_ECN.ko.xz
kernel/net/ipv4/netfilter/ipt_MASQUERADE.ko.xz
kernel/net/ipv4/netfilter/ipt_REJECT.ko.xz
kernel/net/ipv4/netfilter/ipt_SYNPROXY.ko.xz
kernel/net/ipv4/netfilter/ipt_ULOG.ko.xz
kernel/net/ipv4/netfilter/ipt_ah.ko.xz
kernel/net/ipv4/netfilter/ipt_rpfilter.ko.xz
kernel/net/ipv4/netfilter/iptable_filter.ko.xz
kernel/net/ipv4/netfilter/iptable_mangle.ko.xz
kernel/net/ipv4/netfilter/iptable_nat.ko.xz
kernel/net/ipv4/netfilter/iptable_raw.ko.xz
kernel/net/ipv4/netfilter/iptable_security.ko.xz
kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko.xz
kernel/net/ipv4/netfilter/nf_defrag_ipv4.ko.xz
kernel/net/ipv4/netfilter/nf_dup_ipv4.ko.xz
kernel/net/ipv4/netfilter/nf_log_ipv4.ko.xz
kernel/net/ipv4/netfilter/nf_nat_h323.ko.xz
kernel/net/ipv4/netfilter/nf_nat_ipv4.ko.xz
kernel/net/ipv4/netfilter/nf_nat_masquerade_ipv4.ko.xz
kernel/net/ipv4/netfilter/nf_nat_pptp.ko.xz
kernel/net/ipv4/netfilter/nf_nat_proto_gre.ko.xz
kernel/net/ipv4/netfilter/nf_nat_snmp_basic.ko.xz
kernel/net/ipv4/netfilter/nf_reject_ipv4.ko.xz
kernel/net/ipv4/netfilter/nf_tables_arp.ko.xz
kernel/net/ipv4/netfilter/nf_tables_ipv4.ko.xz
kernel/net/ipv4/netfilter/nft_chain_nat_ipv4.ko.xz
kernel/net/ipv4/netfilter/nft_chain_route_ipv4.ko.xz
kernel/net/ipv4/netfilter/nft_dup_ipv4.ko.xz
kernel/net/ipv4/netfilter/nft_masq_ipv4.ko.xz
kernel/net/ipv4/netfilter/nft_redir_ipv4.ko.xz
kernel/net/ipv4/netfilter/nft_reject_ipv4.ko.xz
kernel/net/ipv4/tcp_bic.ko.xz
kernel/net/ipv4/tcp_dctcp.ko.xz
kernel/net/ipv4/tcp_diag.ko.xz
kernel/net/ipv4/tcp_highspeed.ko.xz
kernel/net/ipv4/tcp_htcp.ko.xz
kernel/net/ipv4/tcp_hybla.ko.xz
kernel/net/ipv4/tcp_illinois.ko.xz
kernel/net/ipv4/tcp_lp.ko.xz
kernel/net/ipv4/tcp_scalable.ko.xz
kernel/net/ipv4/tcp_vegas.ko.xz
kernel/net/ipv4/tcp_veno.ko.xz
kernel/net/ipv4/tcp_westwood.ko.xz
kernel/net/ipv4/tcp_yeah.ko.xz
kernel/net/ipv4/tunnel4.ko.xz
kernel/net/ipv4/udp_diag.ko.xz
kernel/net/ipv4/udp_tunnel.ko.xz
kernel/net/ipv4/xfrm4_mode_beet.ko.xz
kernel/net/ipv4/xfrm4_mode_transport.ko.xz
kernel/net/ipv4/xfrm4_mode_tunnel.ko.xz
kernel/net/ipv4/xfrm4_tunnel.ko.xz
kernel/net/ipv6
kernel/net/ipv6/ah6.ko.xz
kernel/net/ipv6/esp6.ko.xz
kernel/net/ipv6/ip6_gre.ko.xz
kernel/net/ipv6/ip6_tunnel.ko.xz
kernel/net/ipv6/ip6_udp_tunnel.ko.xz
kernel/net/ipv6/ip6_vti.ko.xz
kernel/net/ipv6/ipcomp6.ko.xz
kernel/net/ipv6/mip6.ko.xz
kernel/net/ipv6/netfilter
kernel/net/ipv6/netfilter/ip6_tables.ko.xz
kernel/net/ipv6/netfilter/ip6t_MASQUERADE.ko.xz
kernel/net/ipv6/netfilter/ip6t_NPT.ko.xz
kernel/net/ipv6/netfilter/ip6t_REJECT.ko.xz
kernel/net/ipv6/netfilter/ip6t_SYNPROXY.ko.xz
kernel/net/ipv6/netfilter/ip6t_ah.ko.xz
kernel/net/ipv6/netfilter/ip6t_eui64.ko.xz
kernel/net/ipv6/netfilter/ip6t_frag.ko.xz
kernel/net/ipv6/netfilter/ip6t_hbh.ko.xz
kernel/net/ipv6/netfilter/ip6t_ipv6header.ko.xz
kernel/net/ipv6/netfilter/ip6t_mh.ko.xz
kernel/net/ipv6/netfilter/ip6t_rpfilter.ko.xz
kernel/net/ipv6/netfilter/ip6t_rt.ko.xz
kernel/net/ipv6/netfilter/ip6table_filter.ko.xz
kernel/net/ipv6/netfilter/ip6table_mangle.ko.xz
kernel/net/ipv6/netfilter/ip6table_nat.ko.xz
kernel/net/ipv6/netfilter/ip6table_raw.ko.xz
kernel/net/ipv6/netfilter/ip6table_security.ko.xz
kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko.xz
kernel/net/ipv6/netfilter/nf_defrag_ipv6.ko.xz
kernel/net/ipv6/netfilter/nf_dup_ipv6.ko.xz
kernel/net/ipv6/netfilter/nf_log_ipv6.ko.xz
kernel/net/ipv6/netfilter/nf_nat_ipv6.ko.xz
kernel/net/ipv6/netfilter/nf_nat_masquerade_ipv6.ko.xz
kernel/net/ipv6/netfilter/nf_reject_ipv6.ko.xz
kernel/net/ipv6/netfilter/nf_tables_ipv6.ko.xz
kernel/net/ipv6/netfilter/nft_chain_nat_ipv6.ko.xz
kernel/net/ipv6/netfilter/nft_chain_route_ipv6.ko.xz
kernel/net/ipv6/netfilter/nft_dup_ipv6.ko.xz
kernel/net/ipv6/netfilter/nft_masq_ipv6.ko.xz
kernel/net/ipv6/netfilter/nft_redir_ipv6.ko.xz
kernel/net/ipv6/netfilter/nft_reject_ipv6.ko.xz
kernel/net/ipv6/sit.ko.xz
kernel/net/ipv6/tunnel6.ko.xz
kernel/net/ipv6/xfrm6_mode_beet.ko.xz
kernel/net/ipv6/xfrm6_mode_ro.ko.xz
kernel/net/ipv6/xfrm6_mode_transport.ko.xz
kernel/net/ipv6/xfrm6_mode_tunnel.ko.xz
kernel/net/ipv6/xfrm6_tunnel.ko.xz
kernel/net/key
kernel/net/key/af_key.ko.xz
kernel/net/l2tp
kernel/net/l2tp/l2tp_core.ko.xz
kernel/net/l2tp/l2tp_debugfs.ko.xz
kernel/net/l2tp/l2tp_eth.ko.xz
kernel/net/l2tp/l2tp_ip.ko.xz
kernel/net/l2tp/l2tp_ip6.ko.xz
kernel/net/l2tp/l2tp_netlink.ko.xz
kernel/net/l2tp/l2tp_ppp.ko.xz
kernel/net/llc
kernel/net/llc/llc.ko.xz
kernel/net/mac80211
kernel/net/mac80211/mac80211.ko.xz
kernel/net/mac802154
kernel/net/mac802154/mac802154.ko.xz
kernel/net/netfilter
kernel/net/netfilter/ipset
kernel/net/netfilter/ipset/ip_set.ko.xz
kernel/net/netfilter/ipset/ip_set_bitmap_ip.ko.xz
kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.ko.xz
kernel/net/netfilter/ipset/ip_set_bitmap_port.ko.xz
kernel/net/netfilter/ipset/ip_set_hash_ip.ko.xz
kernel/net/netfilter/ipset/ip_set_hash_ipport.ko.xz
kernel/net/netfilter/ipset/ip_set_hash_ipportip.ko.xz
kernel/net/netfilter/ipset/ip_set_hash_ipportnet.ko.xz
kernel/net/netfilter/ipset/ip_set_hash_net.ko.xz
kernel/net/netfilter/ipset/ip_set_hash_netiface.ko.xz
kernel/net/netfilter/ipset/ip_set_hash_netport.ko.xz
kernel/net/netfilter/ipset/ip_set_list_set.ko.xz
kernel/net/netfilter/ipvs
kernel/net/netfilter/ipvs/ip_vs.ko.xz
kernel/net/netfilter/ipvs/ip_vs_dh.ko.xz
kernel/net/netfilter/ipvs/ip_vs_ftp.ko.xz
kernel/net/netfilter/ipvs/ip_vs_lblc.ko.xz
kernel/net/netfilter/ipvs/ip_vs_lblcr.ko.xz
kernel/net/netfilter/ipvs/ip_vs_lc.ko.xz
kernel/net/netfilter/ipvs/ip_vs_nq.ko.xz
kernel/net/netfilter/ipvs/ip_vs_pe_sip.ko.xz
kernel/net/netfilter/ipvs/ip_vs_rr.ko.xz
kernel/net/netfilter/ipvs/ip_vs_sed.ko.xz
kernel/net/netfilter/ipvs/ip_vs_sh.ko.xz
kernel/net/netfilter/ipvs/ip_vs_wlc.ko.xz
kernel/net/netfilter/ipvs/ip_vs_wrr.ko.xz
kernel/net/netfilter/xt_cluster.ko.xz
kernel/net/netfilter/nf_conntrack.ko.xz
kernel/net/netfilter/xt_CHECKSUM.ko.xz
kernel/net/netfilter/nf_conntrack_amanda.ko.xz
kernel/net/netfilter/nft_reject.ko.xz
kernel/net/netfilter/xt_set.ko.xz
kernel/net/netfilter/nf_conntrack_broadcast.ko.xz
kernel/net/netfilter/xt_CLASSIFY.ko.xz
kernel/net/netfilter/nf_conntrack_ftp.ko.xz
kernel/net/netfilter/xt_LOG.ko.xz
kernel/net/netfilter/xt_u32.ko.xz
kernel/net/netfilter/nf_conntrack_h323.ko.xz
kernel/net/netfilter/xt_NETMAP.ko.xz
kernel/net/netfilter/nf_conntrack_irc.ko.xz
kernel/net/netfilter/nft_reject_inet.ko.xz
kernel/net/netfilter/nf_conntrack_netbios_ns.ko.xz
kernel/net/netfilter/xt_NFLOG.ko.xz
kernel/net/netfilter/nf_conntrack_netlink.ko.xz
kernel/net/netfilter/xt_NFQUEUE.ko.xz
kernel/net/netfilter/nf_conntrack_pptp.ko.xz
kernel/net/netfilter/xt_LED.ko.xz
kernel/net/netfilter/xt_physdev.ko.xz
kernel/net/netfilter/nf_conntrack_proto_gre.ko.xz
kernel/net/netfilter/xt_RATEEST.ko.xz
kernel/net/netfilter/nf_conntrack_sane.ko.xz
kernel/net/netfilter/xt_REDIRECT.ko.xz
kernel/net/netfilter/nf_conntrack_sip.ko.xz
kernel/net/netfilter/xt_SECMARK.ko.xz
kernel/net/netfilter/nf_conntrack_snmp.ko.xz
kernel/net/netfilter/xt_TCPMSS.ko.xz
kernel/net/netfilter/nf_conntrack_tftp.ko.xz
kernel/net/netfilter/xt_comment.ko.xz
kernel/net/netfilter/nf_log_common.ko.xz
kernel/net/netfilter/xt_connbytes.ko.xz
kernel/net/netfilter/nf_nat.ko.xz
kernel/net/netfilter/xt_connlabel.ko.xz
kernel/net/netfilter/nf_nat_amanda.ko.xz
kernel/net/netfilter/xt_connlimit.ko.xz
kernel/net/netfilter/nf_nat_ftp.ko.xz
kernel/net/netfilter/xt_connmark.ko.xz
kernel/net/netfilter/nf_nat_irc.ko.xz
kernel/net/netfilter/xt_TCPOPTSTRIP.ko.xz
kernel/net/netfilter/nf_nat_redirect.ko.xz
kernel/net/netfilter/xt_conntrack.ko.xz
kernel/net/netfilter/nf_nat_sip.ko.xz
kernel/net/netfilter/xt_cpu.ko.xz
kernel/net/netfilter/nf_nat_tftp.ko.xz
kernel/net/netfilter/xt_TEE.ko.xz
kernel/net/netfilter/nf_synproxy_core.ko.xz
kernel/net/netfilter/xt_dccp.ko.xz
kernel/net/netfilter/nf_tables.ko.xz
kernel/net/netfilter/xt_TPROXY.ko.xz
kernel/net/netfilter/nf_tables_inet.ko.xz
kernel/net/netfilter/xt_devgroup.ko.xz
kernel/net/netfilter/nfnetlink.ko.xz
kernel/net/netfilter/xt_TRACE.ko.xz
kernel/net/netfilter/nfnetlink_acct.ko.xz
kernel/net/netfilter/xt_addrtype.ko.xz
kernel/net/netfilter/nfnetlink_cthelper.ko.xz
kernel/net/netfilter/xt_bpf.ko.xz
kernel/net/netfilter/nfnetlink_cttimeout.ko.xz
kernel/net/netfilter/xt_dscp.ko.xz
kernel/net/netfilter/nfnetlink_log.ko.xz
kernel/net/netfilter/xt_cgroup.ko.xz
kernel/net/netfilter/nfnetlink_queue.ko.xz
kernel/net/netfilter/xt_ecn.ko.xz
kernel/net/netfilter/nft_compat.ko.xz
kernel/net/netfilter/xt_esp.ko.xz
kernel/net/netfilter/nft_counter.ko.xz
kernel/net/netfilter/xt_hashlimit.ko.xz
kernel/net/netfilter/nft_ct.ko.xz
kernel/net/netfilter/xt_helper.ko.xz
kernel/net/netfilter/nft_exthdr.ko.xz
kernel/net/netfilter/xt_ipvs.ko.xz
kernel/net/netfilter/nft_hash.ko.xz
kernel/net/netfilter/xt_iprange.ko.xz
kernel/net/netfilter/nft_limit.ko.xz
kernel/net/netfilter/xt_length.ko.xz
kernel/net/netfilter/nft_log.ko.xz
kernel/net/netfilter/xt_limit.ko.xz
kernel/net/netfilter/nft_masq.ko.xz
kernel/net/netfilter/xt_mac.ko.xz
kernel/net/netfilter/nft_meta.ko.xz
kernel/net/netfilter/xt_mark.ko.xz
kernel/net/netfilter/nft_nat.ko.xz
kernel/net/netfilter/xt_multiport.ko.xz
kernel/net/netfilter/nft_queue.ko.xz
kernel/net/netfilter/xt_nat.ko.xz
kernel/net/netfilter/nft_rbtree.ko.xz
kernel/net/netfilter/xt_nfacct.ko.xz
kernel/net/netfilter/nft_redir.ko.xz
kernel/net/netfilter/xt_AUDIT.ko.xz
kernel/net/netfilter/xt_CONNSECMARK.ko.xz
kernel/net/netfilter/xt_pkttype.ko.xz
kernel/net/netfilter/xt_CT.ko.xz
kernel/net/netfilter/xt_osf.ko.xz
kernel/net/netfilter/xt_DSCP.ko.xz
kernel/net/netfilter/xt_policy.ko.xz
kernel/net/netfilter/xt_HL.ko.xz
kernel/net/netfilter/xt_owner.ko.xz
kernel/net/netfilter/xt_HMARK.ko.xz
kernel/net/netfilter/xt_IDLETIMER.ko.xz
kernel/net/netfilter/xt_quota.ko.xz
kernel/net/netfilter/xt_hl.ko.xz
kernel/net/netfilter/xt_rateest.ko.xz
kernel/net/netfilter/xt_realm.ko.xz
kernel/net/netfilter/xt_recent.ko.xz
kernel/net/netfilter/xt_sctp.ko.xz
kernel/net/netfilter/xt_socket.ko.xz
kernel/net/netfilter/xt_state.ko.xz
kernel/net/netfilter/xt_statistic.ko.xz
kernel/net/netfilter/xt_string.ko.xz
kernel/net/netfilter/xt_tcpmss.ko.xz
kernel/net/netfilter/xt_time.ko.xz
kernel/net/netlink
kernel/net/netlink/netlink_diag.ko.xz
kernel/net/openvswitch
kernel/net/openvswitch/openvswitch.ko.xz
kernel/net/openvswitch/vport-geneve.ko.xz
kernel/net/openvswitch/vport-gre.ko.xz
kernel/net/openvswitch/vport-vxlan.ko.xz
kernel/net/packet
kernel/net/packet/af_packet_diag.ko.xz
kernel/net/rfkill
kernel/net/rfkill/rfkill.ko.xz
kernel/net/sched
kernel/net/sched/sch_teql.ko.xz
kernel/net/sched/act_csum.ko.xz
kernel/net/sched/act_gact.ko.xz
kernel/net/sched/act_ipt.ko.xz
kernel/net/sched/act_mirred.ko.xz
kernel/net/sched/act_nat.ko.xz
kernel/net/sched/act_pedit.ko.xz
kernel/net/sched/act_police.ko.xz
kernel/net/sched/act_simple.ko.xz
kernel/net/sched/act_skbedit.ko.xz
kernel/net/sched/sch_tbf.ko.xz
kernel/net/sched/act_tunnel_key.ko.xz
kernel/net/sched/act_vlan.ko.xz
kernel/net/sched/cls_basic.ko.xz
kernel/net/sched/cls_bpf.ko.xz
kernel/net/sched/cls_flow.ko.xz
kernel/net/sched/cls_flower.ko.xz
kernel/net/sched/cls_fw.ko.xz
kernel/net/sched/cls_matchall.ko.xz
kernel/net/sched/cls_route.ko.xz
kernel/net/sched/cls_rsvp.ko.xz
kernel/net/sched/cls_rsvp6.ko.xz
kernel/net/sched/cls_tcindex.ko.xz
kernel/net/sched/cls_u32.ko.xz
kernel/net/sched/em_cmp.ko.xz
kernel/net/sched/em_ipset.ko.xz
kernel/net/sched/em_meta.ko.xz
kernel/net/sched/em_nbyte.ko.xz
kernel/net/sched/em_text.ko.xz
kernel/net/sched/em_u32.ko.xz
kernel/net/sched/sch_atm.ko.xz
kernel/net/sched/sch_cbq.ko.xz
kernel/net/sched/sch_choke.ko.xz
kernel/net/sched/sch_codel.ko.xz
kernel/net/sched/sch_drr.ko.xz
kernel/net/sched/sch_dsmark.ko.xz
kernel/net/sched/sch_fq.ko.xz
kernel/net/sched/sch_fq_codel.ko.xz
kernel/net/sched/sch_gred.ko.xz
kernel/net/sched/sch_hfsc.ko.xz
kernel/net/sched/sch_htb.ko.xz
kernel/net/sched/sch_ingress.ko.xz
kernel/net/sched/sch_mqprio.ko.xz
kernel/net/sched/sch_multiq.ko.xz
kernel/net/sched/sch_netem.ko.xz
kernel/net/sched/sch_plug.ko.xz
kernel/net/sched/sch_prio.ko.xz
kernel/net/sched/sch_qfq.ko.xz
kernel/net/sched/sch_red.ko.xz
kernel/net/sched/sch_sfb.ko.xz
kernel/net/sched/sch_sfq.ko.xz
kernel/net/sctp
kernel/net/sctp/sctp.ko.xz
kernel/net/sctp/sctp_diag.ko.xz
kernel/net/sctp/sctp_probe.ko.xz
kernel/net/sunrpc/xprtrdma
kernel/net/sunrpc/xprtrdma/rpcrdma.ko.xz
kernel/net/unix
kernel/net/unix/unix_diag.ko.xz
kernel/net/xfrm
kernel/net/xfrm/xfrm_ipcomp.ko.xz
kernel/virt
kernel/virt/lib
kernel/virt/lib/irqbypass.ko.xz
kernel/drivers/usb/class
kernel/drivers/usb/class/cdc-acm.ko.xz
kernel/drivers/usb/serial
kernel/drivers/usb/serial/pl2303.ko.xz
kernel/drivers/usb/storage
kernel/drivers/usb/storage/usb-storage.ko.xz
vdso
vdso/vdso.so
vdso/vdso32-int80.so
vdso/vdso32-syscall.so
vdso/vdso32-sysenter.so
misc
misc/vboxguest.ko
misc/vboxsf.ko
misc/vboxvideo.ko
modules.block
modules.drm
modules.modesetting
modules.networking
modules.builtin
modules.order
modules.dep
modules.dep.bin
modules.alias
modules.alias.bin
modules.softdep
modules.symbols
modules.symbols.bin
modules.builtin.bin
modules.devname
FILES_END

sub PrintInfo
{
  my $msg = shift;
  print '[', YELLOW, "INFO", CLEAR, "]\t$msg\n";
}

sub PrintError
{
  my $msg = shift;
  print '[', RED, "ERROR", CLEAR, "]\t$msg\n";
}

sub PrintOk
{
  my $msg = shift;
  print '[', GREEN, "OK", CLEAR, "]\t$msg\n";
}

sub ExecShellCmd2
{
  my $cmd = shift;
  my $print_result = shift;
  $print_result = 1 unless defined $print_result;
  my $output = `$cmd`;
  # http://perldoc.perl.org/perlvar.html#$CHILD%5FERROR
  my $exit_code = $?>>8;
  if ($print_result) {
    if ($exit_code == 0) {
      PrintOk "$cmd";
    } else {
      PrintError "\"$cmd\" return error $exit_code\n--------------\n$output\n--------------\n";
    }
  }
  return ($output, $exit_code);
}

sub ExecShellCmd
{
  my $cmd = shift;
  my $print_result = shift;
  my ($output, $exit_code) = ExecShellCmd2($cmd, $print_result);
  exit 1 if ($exit_code != 0);
  return $output;
}


sub Update () {
#------------------------------------------------------------------------------
# Install kernel modules
#------------------------------------------------------------------------------
  if (! -e "$initrd_dir/$modules_dir") {
    print ("Find a new kernel \"$latest_kernel\", install modules...\n");
    ExecShellCmd("mkdir -p $initrd_dir/$modules_dir");
  }

  my @file_list = split(/\n/,$files);
  foreach my $file (@file_list) {
    chomp($file);
    my $src = "$modules_dir/$file";
    my $dest = "${initrd_dir}$modules_dir/$file";

    if (-d $src) {
      if (! -e $dest) {
        ExecShellCmd("mkdir -p \"$dest\"");
      }
    } elsif (-e $src) {
      if (! -e $dest) {
        ExecShellCmd("cp \"$src\" \"$dest\"");
      } else {
        my ($output, $result) = ExecShellCmd2("diff \"$src\" \"$dest\"", 0);
        if ($result != 0) {
          PrintInfo("Need to update $dest.");
          ExecShellCmd("cp \"$src\" \"$dest\"");
        }
      }
    } else {
      PrintError "$src file doesn't exist.";
    }
  }

#------------------------------------------------------------------------------
# Update program and library
#------------------------------------------------------------------------------
  UpdateFilesInDir("usr/sbin");
  UpdateFilesInDir("usr/lib64");
}

sub UpdateFilesInDir {
  my $path = shift || "";
  return if length ($path) < 3;
  my ($file_ls, $result)= ExecShellCmd("ls $initrd_dir/$path", 0);
  my @file_list = split(/[\s ,\n]/,$file_ls);
  my @child_dir =();

  foreach my $file (@file_list) {
    my $src = "/$path/$file";
    my $dest = "$initrd_dir/$path/$file";
    if (-l $dest) {
      # Symbolic links
      my $link = `readlink -f $dest`;
      next if ($link =~/busybox$/);

      my ($output, $result) = ExecShellCmd2("file $link", 0);
      if ($result != 0) {
        PrintError("dangling link $link");
        next;
      }
    }
    if (-d $dest) {
      push @child_dir, $file;
      next;
    }

    if (not (-e $src)) {
      PrintInfo("Need to update $dest, but $src doesn't exist");
      next;
    }

    my ($output, $result) = ExecShellCmd2("diff --no-dereference \"$src\" \"$dest\"", 0);
    if ($result != 0) {
      PrintInfo("Need to update $dest.");
        ExecShellCmd("cp -d \"$src\" \"$dest\"");
    }
  }

  foreach my $dir(@child_dir) {
    UpdateFilesInDir("$path/$dir");
  }
}

sub Build() {
  my $initramfs_name = `basename $initrd_dir`;
  chomp($initramfs_name);
  ExecShellCmd2("cd $initrd_dir ; find . | cpio --quiet -H newc -o | gzip -9 -n > ../${initramfs_name}.img");
}

my $command = shift @ARGV || "";
$initrd_dir = shift @ARGV || "/home/ming/initramfs/initramfs-rescue";
if ($command eq "build") {
  Build();
} else {
  Update();
}
