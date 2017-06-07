#!/bin/sh

export PATH=$PATH:$(pwd)/iPhone_syslog

NOW=$(date +"%F_%H-%M-%S")
LOGFILE="iPhone_syslog_$NOW.txt"
echo "===============================================================" | tee -a $LOGFILE
iphone_info | tee -a  $LOGFILE
echo "===============================================================" | tee -a $LOGFILE
sleep 1
iphone_logcat | tee -a  $LOGFILE

