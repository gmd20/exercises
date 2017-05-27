#!/usr/bin/perl -w

use Term::ANSIColor;
use Term::ANSIColor qw(:constants);
use strict;

my $initrd_dir = "/home/ming/initrd-busybox";
my $latest_kernel = `uname -r`;
chomp($latest_kernel);
my $modules_dir = "/lib/modules/$latest_kernel";

my $files = <<"FILES_END";
kernel
kernel/arch
kernel/arch/x86
kernel/arch/x86/crypto
kernel/arch/x86/crypto/crc32c-intel.ko
kernel/arch/x86/crypto/crct10dif-pclmul.ko
kernel/crypto
kernel/crypto/crct10dif_common.ko
kernel/crypto/crct10dif_generic.ko
kernel/drivers
kernel/drivers/ata
kernel/drivers/ata/ahci.ko
kernel/drivers/ata/ata_generic.ko
kernel/drivers/ata/ata_piix.ko
kernel/drivers/ata/libahci.ko
kernel/drivers/ata/libata.ko
kernel/drivers/ata/pata_acpi.ko
kernel/drivers/block
kernel/drivers/block/virtio_blk.ko
kernel/drivers/cdrom
kernel/drivers/cdrom/cdrom.ko
kernel/drivers/char
kernel/drivers/char/virtio_console.ko
kernel/drivers/firmware
kernel/drivers/firmware/iscsi_ibft.ko
kernel/drivers/input
kernel/drivers/input/serio
kernel/drivers/input/serio/serio_raw.ko
kernel/drivers/md
kernel/drivers/md/dm-log.ko
kernel/drivers/md/dm-mirror.ko
kernel/drivers/md/dm-mod.ko
kernel/drivers/md/dm-region-hash.ko
kernel/drivers/net
kernel/drivers/net/ethernet
kernel/drivers/net/ethernet/intel
kernel/drivers/net/ethernet/intel/e1000
kernel/drivers/net/ethernet/intel/e1000/e1000.ko
kernel/drivers/net/ethernet/intel/e1000e
kernel/drivers/net/ethernet/intel/e1000e/e1000e.ko
kernel/drivers/net/ethernet/intel/igb
kernel/drivers/net/ethernet/intel/igb/igb.ko
kernel/drivers/net/ethernet/broadcom
kernel/drivers/net/ethernet/broadcom/tg3.ko
kernel/drivers/net/ethernet/realtek
kernel/drivers/net/ethernet/realtek/8139cp.ko
kernel/drivers/net/ethernet/realtek/8139too.ko
kernel/drivers/net/ethernet/realtek/r8169.ko
kernel/drivers/net/fjes
kernel/drivers/net/fjes/fjes.ko
kernel/drivers/net/mii.ko
kernel/drivers/net/ifb.ko
kernel/drivers/net/vxlan.ko
kernel/drivers/net/ppp
kernel/drivers/net/ppp/bsd_comp.ko
kernel/drivers/net/ppp/ppp_async.ko
kernel/drivers/net/ppp/ppp_deflate.ko
kernel/drivers/net/ppp/ppp_generic.ko
kernel/drivers/net/ppp/ppp_mppe.ko
kernel/drivers/net/ppp/ppp_synctty.ko
kernel/drivers/net/ppp/pppoe.ko
kernel/drivers/net/ppp/pppox.ko
kernel/drivers/net/ppp/pptp.ko
kernel/drivers/net/tun.ko
kernel/drivers/scsi
kernel/drivers/scsi/iscsi_boot_sysfs.ko
kernel/drivers/scsi/sd_mod.ko
kernel/drivers/scsi/sr_mod.ko
kernel/drivers/scsi/virtio_scsi.ko
kernel/drivers/virtio
kernel/drivers/virtio/virtio.ko
kernel/drivers/virtio/virtio_pci.ko
kernel/drivers/virtio/virtio_ring.ko
kernel/fs
kernel/fs/xfs
kernel/fs/xfs/xfs.ko
kernel/fs/ext4
kernel/fs/ext4/ext4.ko
kernel/fs/jbd2
kernel/fs/jbd2/jbd2.ko
kernel/lib
kernel/lib/crc-t10dif.ko
kernel/lib/libcrc32c.ko
kernel/net
kernel/net/802
kernel/net/802/stp.ko
kernel/net/bridge
kernel/net/bridge/bridge.ko
kernel/net/bridge/br_netfilter.ko
kernel/net/bridge/netfilter
kernel/net/bridge/netfilter/ebt_802_3.ko
kernel/net/bridge/netfilter/ebt_among.ko
kernel/net/bridge/netfilter/ebt_arp.ko
kernel/net/bridge/netfilter/ebt_arpreply.ko
kernel/net/bridge/netfilter/ebt_dnat.ko
kernel/net/bridge/netfilter/ebt_ip.ko
kernel/net/bridge/netfilter/ebt_ip6.ko
kernel/net/bridge/netfilter/ebt_limit.ko
kernel/net/bridge/netfilter/ebt_log.ko
kernel/net/bridge/netfilter/ebt_mark.ko
kernel/net/bridge/netfilter/ebt_mark_m.ko
kernel/net/bridge/netfilter/ebt_nflog.ko
kernel/net/bridge/netfilter/ebt_pkttype.ko
kernel/net/bridge/netfilter/ebt_redirect.ko
kernel/net/bridge/netfilter/ebt_snat.ko
kernel/net/bridge/netfilter/ebt_stp.ko
kernel/net/bridge/netfilter/ebt_ulog.ko
kernel/net/bridge/netfilter/ebt_vlan.ko
kernel/net/bridge/netfilter/ebtable_broute.ko
kernel/net/bridge/netfilter/ebtable_filter.ko
kernel/net/bridge/netfilter/ebtable_nat.ko
kernel/net/bridge/netfilter/ebtables.ko
kernel/net/bridge/netfilter/nf_tables_bridge.ko
kernel/net/bridge/netfilter/nft_meta_bridge.ko
kernel/net/bridge/netfilter/nft_reject_bridge.ko
kernel/net/llc
kernel/net/llc/llc.ko
kernel/net/netfilter
kernel/net/netfilter/ipset
kernel/net/netfilter/ipset/ip_set.ko
kernel/net/netfilter/ipset/ip_set_bitmap_ip.ko
kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.ko
kernel/net/netfilter/ipset/ip_set_bitmap_port.ko
kernel/net/netfilter/ipset/ip_set_hash_ip.ko
kernel/net/netfilter/ipset/ip_set_hash_ipport.ko
kernel/net/netfilter/ipset/ip_set_hash_ipportip.ko
kernel/net/netfilter/ipset/ip_set_hash_ipportnet.ko
kernel/net/netfilter/ipset/ip_set_hash_net.ko
kernel/net/netfilter/ipset/ip_set_hash_netiface.ko
kernel/net/netfilter/ipset/ip_set_hash_netport.ko
kernel/net/netfilter/ipset/ip_set_list_set.ko
kernel/net/netfilter/ipvs
kernel/net/netfilter/ipvs/ip_vs.ko
kernel/net/netfilter/ipvs/ip_vs_dh.ko
kernel/net/netfilter/ipvs/ip_vs_ftp.ko
kernel/net/netfilter/ipvs/ip_vs_lblc.ko
kernel/net/netfilter/ipvs/ip_vs_lblcr.ko
kernel/net/netfilter/ipvs/ip_vs_lc.ko
kernel/net/netfilter/ipvs/ip_vs_nq.ko
kernel/net/netfilter/ipvs/ip_vs_pe_sip.ko
kernel/net/netfilter/ipvs/ip_vs_rr.ko
kernel/net/netfilter/ipvs/ip_vs_sed.ko
kernel/net/netfilter/ipvs/ip_vs_sh.ko
kernel/net/netfilter/ipvs/ip_vs_wlc.ko
kernel/net/netfilter/ipvs/ip_vs_wrr.ko
kernel/net/netfilter/xt_TPROXY.ko
kernel/net/netfilter/nf_conntrack.ko
kernel/net/netfilter/nft_queue.ko
kernel/net/netfilter/xt_realm.ko
kernel/net/netfilter/nf_conntrack_amanda.ko
kernel/net/netfilter/nft_rbtree.ko
kernel/net/netfilter/nf_conntrack_broadcast.ko
kernel/net/netfilter/xt_TRACE.ko
kernel/net/netfilter/nf_conntrack_ftp.ko
kernel/net/netfilter/nft_redir.ko
kernel/net/netfilter/xt_recent.ko
kernel/net/netfilter/nf_conntrack_h323.ko
kernel/net/netfilter/xt_addrtype.ko
kernel/net/netfilter/nf_conntrack_irc.ko
kernel/net/netfilter/nft_reject.ko
kernel/net/netfilter/nf_conntrack_netbios_ns.ko
kernel/net/netfilter/nft_reject_inet.ko
kernel/net/netfilter/nf_conntrack_netlink.ko
kernel/net/netfilter/xt_IDLETIMER.ko
kernel/net/netfilter/nf_conntrack_pptp.ko
kernel/net/netfilter/xt_LED.ko
kernel/net/netfilter/xt_sctp.ko
kernel/net/netfilter/nf_conntrack_proto_dccp.ko
kernel/net/netfilter/xt_LOG.ko
kernel/net/netfilter/xt_set.ko
kernel/net/netfilter/nf_conntrack_proto_gre.ko
kernel/net/netfilter/xt_NETMAP.ko
kernel/net/netfilter/xt_socket.ko
kernel/net/netfilter/nf_conntrack_proto_sctp.ko
kernel/net/netfilter/xt_statistic.ko
kernel/net/netfilter/xt_state.ko
kernel/net/netfilter/nf_conntrack_proto_udplite.ko
kernel/net/netfilter/xt_NFLOG.ko
kernel/net/netfilter/xt_string.ko
kernel/net/netfilter/nf_conntrack_sane.ko
kernel/net/netfilter/xt_bpf.ko
kernel/net/netfilter/nf_conntrack_sip.ko
kernel/net/netfilter/xt_NFQUEUE.ko
kernel/net/netfilter/nf_conntrack_snmp.ko
kernel/net/netfilter/xt_RATEEST.ko
kernel/net/netfilter/nf_conntrack_tftp.ko
kernel/net/netfilter/xt_cgroup.ko
kernel/net/netfilter/nf_log_common.ko
kernel/net/netfilter/xt_mac.ko
kernel/net/netfilter/nf_nat.ko
kernel/net/netfilter/xt_cluster.ko
kernel/net/netfilter/nf_nat_amanda.ko
kernel/net/netfilter/xt_comment.ko
kernel/net/netfilter/nf_nat_ftp.ko
kernel/net/netfilter/xt_connbytes.ko
kernel/net/netfilter/nf_nat_irc.ko
kernel/net/netfilter/xt_REDIRECT.ko
kernel/net/netfilter/nf_nat_proto_dccp.ko
kernel/net/netfilter/xt_SECMARK.ko
kernel/net/netfilter/nf_nat_proto_sctp.ko
kernel/net/netfilter/xt_TCPMSS.ko
kernel/net/netfilter/xt_tcpmss.ko
kernel/net/netfilter/nf_nat_proto_udplite.ko
kernel/net/netfilter/xt_connlabel.ko
kernel/net/netfilter/nf_nat_redirect.ko
kernel/net/netfilter/xt_connlimit.ko
kernel/net/netfilter/nf_nat_sip.ko
kernel/net/netfilter/xt_connmark.ko
kernel/net/netfilter/nf_nat_tftp.ko
kernel/net/netfilter/xt_conntrack.ko
kernel/net/netfilter/nf_synproxy_core.ko
kernel/net/netfilter/xt_cpu.ko
kernel/net/netfilter/nf_tables.ko
kernel/net/netfilter/xt_dccp.ko
kernel/net/netfilter/nf_tables_inet.ko
kernel/net/netfilter/xt_devgroup.ko
kernel/net/netfilter/nfnetlink.ko
kernel/net/netfilter/xt_dscp.ko
kernel/net/netfilter/nfnetlink_acct.ko
kernel/net/netfilter/xt_TCPOPTSTRIP.ko
kernel/net/netfilter/nfnetlink_cthelper.ko
kernel/net/netfilter/xt_TEE.ko
kernel/net/netfilter/xt_time.ko
kernel/net/netfilter/nfnetlink_cttimeout.ko
kernel/net/netfilter/xt_ecn.ko
kernel/net/netfilter/nfnetlink_log.ko
kernel/net/netfilter/xt_esp.ko
kernel/net/netfilter/nfnetlink_queue.ko
kernel/net/netfilter/xt_hashlimit.ko
kernel/net/netfilter/nft_compat.ko
kernel/net/netfilter/xt_helper.ko
kernel/net/netfilter/nft_counter.ko
kernel/net/netfilter/xt_mark.ko
kernel/net/netfilter/nft_ct.ko
kernel/net/netfilter/xt_hl.ko
kernel/net/netfilter/nft_exthdr.ko
kernel/net/netfilter/xt_multiport.ko
kernel/net/netfilter/nft_hash.ko
kernel/net/netfilter/xt_iprange.ko
kernel/net/netfilter/nft_limit.ko
kernel/net/netfilter/xt_nat.ko
kernel/net/netfilter/nft_log.ko
kernel/net/netfilter/xt_nfacct.ko
kernel/net/netfilter/nft_masq.ko
kernel/net/netfilter/xt_osf.ko
kernel/net/netfilter/nft_meta.ko
kernel/net/netfilter/xt_owner.ko
kernel/net/netfilter/nft_nat.ko
kernel/net/netfilter/xt_AUDIT.ko
kernel/net/netfilter/xt_ipvs.ko
kernel/net/netfilter/xt_CHECKSUM.ko
kernel/net/netfilter/xt_length.ko
kernel/net/netfilter/xt_CLASSIFY.ko
kernel/net/netfilter/xt_limit.ko
kernel/net/netfilter/xt_CONNSECMARK.ko
kernel/net/netfilter/xt_physdev.ko
kernel/net/netfilter/xt_CT.ko
kernel/net/netfilter/xt_pkttype.ko
kernel/net/netfilter/xt_DSCP.ko
kernel/net/netfilter/xt_policy.ko
kernel/net/netfilter/xt_HL.ko
kernel/net/netfilter/xt_HMARK.ko
kernel/net/netfilter/xt_quota.ko
kernel/net/netfilter/xt_rateest.ko
kernel/net/netfilter/xt_u32.ko
kernel/net/ipv4
kernel/net/ipv4/gre.ko
kernel/net/ipv4/ip_gre.ko
kernel/net/ipv4/netfilter
kernel/net/ipv4/netfilter/arp_tables.ko
kernel/net/ipv4/netfilter/arpt_mangle.ko
kernel/net/ipv4/netfilter/arptable_filter.ko
kernel/net/ipv4/netfilter/ip_tables.ko
kernel/net/ipv4/netfilter/ipt_CLUSTERIP.ko
kernel/net/ipv4/netfilter/ipt_ECN.ko
kernel/net/ipv4/netfilter/ipt_MASQUERADE.ko
kernel/net/ipv4/netfilter/ipt_REJECT.ko
kernel/net/ipv4/netfilter/ipt_SYNPROXY.ko
kernel/net/ipv4/netfilter/ipt_ULOG.ko
kernel/net/ipv4/netfilter/ipt_ah.ko
kernel/net/ipv4/netfilter/ipt_rpfilter.ko
kernel/net/ipv4/netfilter/iptable_filter.ko
kernel/net/ipv4/netfilter/iptable_mangle.ko
kernel/net/ipv4/netfilter/iptable_nat.ko
kernel/net/ipv4/netfilter/iptable_raw.ko
kernel/net/ipv4/netfilter/iptable_security.ko
kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko
kernel/net/ipv4/netfilter/nf_defrag_ipv4.ko
kernel/net/ipv4/netfilter/nf_dup_ipv4.ko
kernel/net/ipv4/netfilter/nf_log_ipv4.ko
kernel/net/ipv4/netfilter/nf_nat_h323.ko
kernel/net/ipv4/netfilter/nf_nat_ipv4.ko
kernel/net/ipv4/netfilter/nf_nat_masquerade_ipv4.ko
kernel/net/ipv4/netfilter/nf_nat_pptp.ko
kernel/net/ipv4/netfilter/nf_nat_proto_gre.ko
kernel/net/ipv4/netfilter/nf_nat_snmp_basic.ko
kernel/net/ipv4/netfilter/nf_reject_ipv4.ko
kernel/net/ipv4/netfilter/nf_tables_arp.ko
kernel/net/ipv4/netfilter/nf_tables_ipv4.ko
kernel/net/ipv4/netfilter/nft_chain_nat_ipv4.ko
kernel/net/ipv4/netfilter/nft_chain_route_ipv4.ko
kernel/net/ipv4/netfilter/nft_dup_ipv4.ko
kernel/net/ipv4/netfilter/nft_masq_ipv4.ko
kernel/net/ipv4/netfilter/nft_redir_ipv4.ko
kernel/net/ipv4/netfilter/nft_reject_ipv4.ko
kernel/net/ipv4/ip_tunnel.ko
kernel/net/sched
kernel/net/sched/act_csum.ko
kernel/net/sched/act_gact.ko
kernel/net/sched/act_ipt.ko
kernel/net/sched/act_mirred.ko
kernel/net/sched/act_nat.ko
kernel/net/sched/act_pedit.ko
kernel/net/sched/act_police.ko
kernel/net/sched/act_simple.ko
kernel/net/sched/act_skbedit.ko
kernel/net/sched/cls_basic.ko
kernel/net/sched/cls_bpf.ko
kernel/net/sched/cls_flow.ko
kernel/net/sched/cls_fw.ko
kernel/net/sched/cls_route.ko
kernel/net/sched/cls_rsvp.ko
kernel/net/sched/cls_rsvp6.ko
kernel/net/sched/cls_tcindex.ko
kernel/net/sched/cls_u32.ko
kernel/net/sched/em_cmp.ko
kernel/net/sched/em_ipset.ko
kernel/net/sched/em_meta.ko
kernel/net/sched/em_nbyte.ko
kernel/net/sched/em_text.ko
kernel/net/sched/em_u32.ko
kernel/net/sched/sch_atm.ko
kernel/net/sched/sch_cbq.ko
kernel/net/sched/sch_choke.ko
kernel/net/sched/sch_codel.ko
kernel/net/sched/sch_drr.ko
kernel/net/sched/sch_dsmark.ko
kernel/net/sched/sch_fq.ko
kernel/net/sched/sch_fq_codel.ko
kernel/net/sched/sch_gred.ko
kernel/net/sched/sch_hfsc.ko
kernel/net/sched/sch_htb.ko
kernel/net/sched/sch_ingress.ko
kernel/net/sched/sch_mqprio.ko
kernel/net/sched/sch_multiq.ko
kernel/net/sched/sch_netem.ko
kernel/net/sched/sch_plug.ko
kernel/net/sched/sch_prio.ko
kernel/net/sched/sch_qfq.ko
kernel/net/sched/sch_red.ko
kernel/net/sched/sch_sfb.ko
kernel/net/sched/sch_sfq.ko
kernel/net/sched/sch_tbf.ko
kernel/net/sched/sch_teql.ko
kernel/net/8021q
kernel/net/8021q/8021q.ko
kernel/net/ipv6
kernel/net/ipv6/ip6_gre.ko
kernel/net/ipv6/netfilter
kernel/net/ipv6/netfilter/ip6_tables.ko
kernel/net/ipv6/netfilter/ip6t_MASQUERADE.ko
kernel/net/ipv6/netfilter/ip6t_REJECT.ko
kernel/net/ipv6/netfilter/ip6t_SYNPROXY.ko
kernel/net/ipv6/netfilter/ip6t_ah.ko
kernel/net/ipv6/netfilter/ip6t_eui64.ko
kernel/net/ipv6/netfilter/ip6t_frag.ko
kernel/net/ipv6/netfilter/ip6t_hbh.ko
kernel/net/ipv6/netfilter/ip6t_ipv6header.ko
kernel/net/ipv6/netfilter/ip6t_mh.ko
kernel/net/ipv6/netfilter/ip6t_rpfilter.ko
kernel/net/ipv6/netfilter/ip6t_rt.ko
kernel/net/ipv6/netfilter/ip6table_filter.ko
kernel/net/ipv6/netfilter/ip6table_mangle.ko
kernel/net/ipv6/netfilter/ip6table_nat.ko
kernel/net/ipv6/netfilter/ip6table_raw.ko
kernel/net/ipv6/netfilter/ip6table_security.ko
kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko
kernel/net/ipv6/netfilter/nf_defrag_ipv6.ko
kernel/net/ipv6/netfilter/nf_dup_ipv6.ko
kernel/net/ipv6/netfilter/nf_log_ipv6.ko
kernel/net/ipv6/netfilter/nf_nat_ipv6.ko
kernel/net/ipv6/netfilter/nf_nat_masquerade_ipv6.ko
kernel/net/ipv6/netfilter/nf_reject_ipv6.ko
kernel/net/ipv6/netfilter/nf_tables_ipv6.ko
kernel/net/ipv6/netfilter/nft_chain_nat_ipv6.ko
kernel/net/ipv6/netfilter/nft_chain_route_ipv6.ko
kernel/net/ipv6/netfilter/nft_dup_ipv6.ko
kernel/net/ipv6/netfilter/nft_masq_ipv6.ko
kernel/net/ipv6/netfilter/nft_redir_ipv6.ko
kernel/net/ipv6/netfilter/nft_reject_ipv6.ko
kernel/net/ipv6/ip6_tunnel.ko
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
      PrintOk "\"$cmd\"";
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
    next if (-l $dest);
    if (-d $dest) {
      push @child_dir, $file;
      next;
    }

    my ($output, $result) = ExecShellCmd2("diff \"$src\" \"$dest\"", 0);
    if ($result != 0) {
      PrintInfo("Need to update $dest.");
      if (-e $src){
        ExecShellCmd("cp \"$src\" \"$dest\"");
      }
    }
  }

  foreach my $dir(@child_dir) {
    UpdateFilesInDir("$path/$dir");
  }
}

sub Build() {
  ExecShellCmd2("cd $initrd_dir ; find . | cpio --quiet -H newc -o | gzip -9 -n > ../initramfs-busybox.img");
}

my $command = shift @ARGV || "";

if ($command eq "build") {
  Build();
} else {
  Update();
}
