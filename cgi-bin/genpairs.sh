#!/bin/sh

cd ..

grep '^<li><a href=' gmt/*/index.html \
  | sed 's/<li><a href="\([^"]\+\)".*/\1/;s|/index.html||' \
  > cgi-bin/gmtpairs.txt

grep '^<li><a href=' [a-z]/*/index.html \
  | sed 's/<li><a href="\([^"]\+\)".*/\1/;s|/index.html||' \
  > cgi-bin/pairs.txt
