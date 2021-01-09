#!/usr/bin/env bash
set -e
/fix_perm.sh
service cron start
trap "service cron stop; exit 0" SIGINT SIGTERM
# Fun fact: "sleep infinity" actually sleeps a finite amount of time on most platforms
while true; do sleep infinity & wait; done