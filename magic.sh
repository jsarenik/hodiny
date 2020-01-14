#!/bin/sh

for dir in $(find . -mindepth 0 -maxdepth 1 -type d)
do
test "$dir"=".git" && continue
cd $dir
for i in *.html
do
  test "$i" = "index.html" && continue
  echo $i | grep -q "\?" && continue
  mkdir ${i%%.html}
  mv -v $i ${i%%.html}/index.html
done
cd - >/dev/null 2>&1
done
