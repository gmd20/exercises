#!/bin/bash

while echo -n "input a key:"
do
  read key
  salt="dddd${key:0:1}d${key:6:2}"
  echo "salt=$salt"
  echo "key=$key"
  digest=`openssl passwd -1 -salt $salt $key`
  echo "$digest"
  echo "result=${digest:12:22}"
done
