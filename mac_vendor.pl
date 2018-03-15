#!/usr/bin/perl

use strict;


# http://standards-oui.ieee.org/oui/oui.txt
my %mac_vendor =();
sub load_mac_vendor_data
{
  open(OUI_FILE, "oui.txt") || die "failed to open file";
  while (my $line=<OUI_FILE>) {
    if ($line =~/^(\w{6})\s+\(base 16\)\s+(\w+.*)$/) {
      $mac_vendor{lc($1)} = $2;
    }
  }
  close(OUI_FILE);
}
load_mac_vendor_data();

sub get_mac_vendor
{
  my $mac = shift;
  $mac = substr($mac, 0, 6);

  if (exists $mac_vendor{$mac}) {
    return $mac_vendor{$mac};
  } else {
    return "";
  }
}
