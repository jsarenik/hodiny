#!/busybox/sh

a="/$0"; a=${a%/*}; a=${a:-.}; a=${a#/}/; HERE=$(cd $a; pwd)
export PATH=/busybox

echo "Content-Type: text/html; charset=UTF-8"
echo

eval $(echo ${QUERY_STRING} | grep -o '[a-zA-Z][a-zA-Z0-9]*=[a-zA-Z0-9/]\+')

# Shell router
case $REQUEST_URI in
  /analog/*) . $HERE/analog.sh;;
esac
