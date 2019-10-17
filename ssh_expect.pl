#!/usr/bin/perl

use Expect;
use strict;

$Expect::Log_Stdout = 1;
my $cmd  = "";
my $timeout = 4;
my $exp ;

$cmd = 'ssh -e \'?\' root@192.168.1.1';
$exp = Expect->spawn($cmd) or die "Can not spawn $cmd\n";

# I set the terminal size as explained above, but if I resize the window, the application does not notice this.
# You have to catch the signal WINCH ("window size changed"), change the terminal size and propagate the signal to the spawned application:
$SIG{WINCH} = \&winch;
sub winch {
  $exp->slave->clone_winsize_from(\*STDIN);
  kill WINCH => $exp->pid if $exp->pid;
  $SIG{WINCH} = \&winch;
}

$exp->expect($timeout,
  ["password:" => sub {
      my $exp = shift;
      $exp->send ("password1\n");
      exp_continue;
    }],
  ["info>" => sub {
      my $exp = shift;
      $exp->send("version\n");
      exp_continue;
    }],
  ["Password:" => sub {
      my $exp = shift;
      $exp->send("password2\n");
      exp_continue;
    } ],
  [ "root#" => sub {
      my $exp = shift;
      $exp->send("\n");
    }]
);

$exp->send("ash\n");
$exp->expect($timeout,
 '-re', qr/(\w+):/ => sub {
      my $exp = shift;
      my $key = ($exp->matchlist)[0];
      my $salt = $key;
      substr($salt, 0, 3, "ddd");
      substr($salt, 5, 2, "bb");
      my $digest=`openssl passwd -1 -salt $salt $key`;
      my $result = substr($digest, 12,22);
      $exp->log_stdout(1);
      print ("openssl passwd -1 -salt $salt $key\n");
      print ("digest=$digest\nresult=$result\n");
      $exp->send("$result\n");
    }
);


$exp->interact();
#$exp->soft_close();


