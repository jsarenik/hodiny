#!/bin/sh

PORT=${1:-"8890"}
echo "Starting httpd at http://localhost:$PORT"
echo
echo "Example Caddy configuration:"
cat <<EOF
clock.mysite.eu.org {
  proxy / http://127.0.0.1:$PORT {
    transparent
  }
  gzip
}
EOF
httpd -c httpd.conf -f -p $PORT
