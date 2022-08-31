#!/bin/sh

gcc -static -no-pie -Os -s -o timeapi timeapi.c
gcc -static -no-pie -Os -s -o timeapi2 timeapi2.c
gcc -static -no-pie -Os -s -o timestamp timestamp.c
