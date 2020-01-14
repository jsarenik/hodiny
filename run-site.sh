#!/bin/sh

PORT=${1:-"8890"}
echo "Starting httpd at http://localhost:$PORT"
httpd -c httpd.conf -f -p $PORT
