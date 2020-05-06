#!/bin/sh

cd public
for i in $(ls | grep '^[a-z]$')
do
  for c in $(cd $i; find . -maxdepth 1 -mindepth 1 -type d)
  do
    ln -s $i/$c $c || echo $i/$c
  done
done
