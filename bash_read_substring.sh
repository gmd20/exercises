#!/bin/bash

while echo "input a key:"
do
  read key
  salt="dddd${key:1:1}d${key:6:2}"
  echo "salt=$salt"
  echo "key=$key"
  digest=`openssl passwd -1 -salt $salt $key`
  echo "$digest"
  echo "result=${digest:13:22}"
done
