#!/bin/sh

uglifyjs css/index.js > css/index.min.js
uglifyjs css/index-later.js > css/index-later.min.js
