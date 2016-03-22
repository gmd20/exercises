#!/bin/bash -xv
# echo $PWD
# echo "$@"
archive_name=${1%_*}.csv.tar.gz
tar -czf "${archive_name}" "$@"
if [ $? -ne 0 ] then
    exit $?
fi

scp -o "StrictHostKeyChecking no" -o "UserKnownHostsFile /cfg/my_ssh_known_hosts" -i /cfg/my_ssh_id_rsa ${archive_name} user_name@192.168.1.123:/data || exit $?

