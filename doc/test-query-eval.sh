#!/bin/sh

QUERY_STRING="a=123&b=456&c=ok&d&e==ahoj&f=ahoj=q&/sbin/reboot&tz=Europe/Athens"
echo ${QUERY_STRING} | grep -o '[a-zA-Z][a-zA-Z0-9]*=[a-zA-Z0-9/]\+'
