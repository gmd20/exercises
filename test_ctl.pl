#!/usr/bin/perl -w

use Switch;
use FindBin qw($Bin);
use Term::ANSIColor;
use Term::ANSIColor qw(:constants);
use Cwd;
use strict;

my $CTL_SCRTIP_DIR      = $Bin;
my $CTL_ROOT_DIR            = cwd();
$CTL_ROOT_DIR = $ENV{$CTL_ROOT_DIR} if defined $ENV{$CTL_ROOT_DIR};

my $CFG_FILE_CUSTOM_CMD = { # define custom start/stop/status command lime
  "00_test" => {
    "compile" => "/usr/bin/test --json_config_file=${CFG_DIR}/test.json --test 2>&1",
    "start" => "start-stop-daemon --start".
                  " --background".
                  " --oknodo".
                  " --no-close".
                  " --make-pidfile".
                  " --pidfile /var/run/test.pid".
                  " --chdir ${CFG_DIR}".
                  " --chuid test_user)".
                  " --name test".
                  " --startas /usr/bin/test -- --json_config_file=${CFG_DIR}/test.json > ${ROOT_DIR}/stderr/test.txt 2>&1".
                  " && sleep 2 && start-stop-daemon --status --name test --pidfile /var/run/test.pid",
    "stop"  => "start-stop-daemon --stop --oknodo --name test --pidfile /var/run/test.pid",
    "status"  => "start-stop-daemon --status --name test --pidfile /var/run/test.pid",
    "getpid"  => "cat /var/run/test.pid",
  },
};


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
      PrintOk "\"$cmd\"" if ($print_result);
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

sub uniq {
  my %seen;
  return grep { !$seen{$_}++ } @_;
}



sub RunCustomCmd
{
  my $cmd  = shift;
  my $file = shift;

  if (defined $CFG_FILE_CUSTOM_CMD->{$file}) {
    if (defined $CFG_FILE_CUSTOM_CMD->{$file}->{$cmd}) {
      my $cmdline = $CFG_FILE_CUSTOM_CMD->{$file}->{$cmd};
      my $output; my $exit_code;
      if ($cmd eq 'status') {
        ($output, $exit_code) = ExecShellCmd2($cmdline, 0);
      } else {
        ($output, $exit_code) = ExecShellCmd2($cmdline, 1);
      }
      if ($exit_code == 0) {
        if ($cmd eq 'status') {
          my $pid = "unkonwn";
          my $getpid_exit_code = 0;
          if (defined $CFG_FILE_CUSTOM_CMD->{$file}->{getpid}) {
            ($pid, $getpid_exit_code) = ExecShellCmd2($CFG_FILE_CUSTOM_CMD->{$file}->{getpid}, 0);
            chomp($pid);
          }
          PrintOk  "$file\t is running. PID = " . $pid;
        } else {
          PrintOk  "Sucessfully $cmd $file.";
        }
        return 1
      } else {
        if ($cmd eq 'status') {
          PrintError  "$file\t is NOT running.";
          return 1
        } else {
          PrintError  "Failed to $cmd $file.";
          exit 1;
        }
      }
    }
  }
  return 0
}



switch($command) {
  case "compile"  { Compile($cfg_file); }
  case "status"   { Status($cfg_file);  }
  case "start"    { Start($cfg_file);   }
  case "stop"     { Stop($cfg_file);    }
  case "clean"    { Clean();            }
  case "restart"  { Stop($cfg_file); Start($cfg_file); }
  case "ls"       { print "@ALL_CFG_FILE"; }
  else { Usage(); }
}
