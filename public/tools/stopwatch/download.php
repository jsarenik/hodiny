#!/busybox/sh

echo "Content-Type: text/plain"
echo

echo Clock.zone stopwatch result

cat \
  | /busybox/cut -d'&' -f1 | /busybox/cut -d= -f2 \
  | /busybox/printf "$(/busybox/sed 's/+/ /g;s/%\(..\)/\\x\1/g;')" \
  | /busybox/sed 's/ <br>/\n/g'
