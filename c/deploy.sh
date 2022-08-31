#!/bin/sh

for i in timeapi2 timeapi
do
  cp -v $i ../public/cgi-bin/$i
done
