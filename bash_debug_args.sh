#!/bin/bash -xv
# echo $PWD
# echo "$@"
archive_name=${1%_*}.csv.tar.gz
tar -czf "${archive_name}" "$@"
if [ $? -ne 0 ] then
    exit $?
fi
