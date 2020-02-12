#!/busybox/sh

a="/$0"; a=${a%/*}; a=${a:-.}; a=${a#/}/; HERE=$(cd $a; pwd)
export PATH=/busybox

echo "Content-Type: text/html; charset=UTF-8"
echo

eval $(echo "$QUERY_STRING" | grep -o '[a-zA-Z][[:alnum:]]*=[-[:alnum:]/_+%]\+')

# Shell router
case $REQUEST_URI in
  /more/digital/*) . $HERE/digital.sh;;
  /analog/*) . $HERE/analog.sh;;
  /tools/timestamptodate/*) . $HERE/timestamptodate.sh;;
esac
