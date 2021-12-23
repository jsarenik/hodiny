#!/bin/sh

gcc -static -no-pie -O3 -s -o timeapi timeapi.c
gcc -static -no-pie -O3 -s -o timeapi2 timeapi2.c
