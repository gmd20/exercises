#! /bin/sh

#modprobe pktgen


function pgset() {
    local result

    echo $1 > $PGDEV

    result=`cat $PGDEV | fgrep "Result: OK:"`
    if [ "$result" = "" ]; then
         cat $PGDEV | fgrep Result:
    fi
}

function pg() {
    echo inject > $PGDEV
    cat $PGDEV
}

# Config Start Here -----------------------------------------------------------


# thread config
# Each CPU has own thread. Two CPU exammple. We add eth1, eth2 respectivly.

PGDEV=/proc/net/pktgen/kpktgend_0
  echo "Removing all devices"
 pgset "rem_device_all" 
  echo "Adding eth1"
 pgset "add_device eth1" 
  echo "Setting max_before_softirq 10000"
 pgset "max_before_softirq 10000"


# device config
# ipg is inter packet gap. 0 means maximum speed.

# We need to do alloc for every skb since we cannot clone here.

CLONE_SKB="clone_skb 0"
# NIC adds 4 bytes CRC
PKT_SIZE="pkt_size 60"

# COUNT 0 means forever
#COUNT="count 0"
COUNT="count 10000000"

PGDEV=/proc/net/pktgen/eth1
 echo "Configuring $PGDEV"
 pgset "$COUNT"
 pgset "$CLONE_SKB"
 pgset "$PKT_SIZE"

 # Random address with in the min-max range
 pgset "flag IPDST_RND"
 pgset "dst_min 192.168.1.66"
 pgset "dst_max 192.168.1.66"
 pgset "dst_mac 00:11:32:05:28:af"
 pgset "dst_mac_count 1"

 pgset "flag IPSRC_RND"
 pgset "src_min 192.168.24.1"
 pgset "src_max 192.168.224.255"
 pgset "src_mac 00:06:53:09:bb:dd"
 pgset "src_mac_count 8192"

 pgset "vlan_id 90"
 pgset "delay 0"
 pgset "pkt_size 64"
 pgset "udp_src_min 4000"
 pgset "udp_src_max 4100"
 pgset "udp_dst_min 4200"
 pgset "udp_dst_max 4204"


# Time to run
PGDEV=/proc/net/pktgen/pgctrl

 echo "Running... ctrl^C to stop"
 pgset "start"
 echo "Done"

# Result can be vieved in /proc/net/pktgen/eth1
