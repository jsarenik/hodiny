#!/bin/sh

uglifyjs css/index.js > css/index.min.js
rsync -av . hd:clock.zone/
