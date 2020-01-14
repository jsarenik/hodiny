#!/bin/sh

for dir in $(find . -type d -mindepth 1 -maxdepth 1)
do
cd $dir
for i in *.html
do
  test "$i" = "index.html" && continue
  echo $i | grep -q "\?" && continue
  mkdir ${i%%.html}
  mv -v $i ${i%%.html}/index.html
done
cd -
done
