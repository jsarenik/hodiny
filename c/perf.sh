#!/bin/sh

perf stat ./timeapi 2>&1 | grep "instru\|task"; perf stat ./timeapi-old 2>&1 | grep "instru\|task"; perf stat ./timeapi 2>&1 | grep "instru\|task";
