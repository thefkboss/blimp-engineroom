#!/bin/bash
#
# This script starts the blimp's docker containers based on the existing
# docker-compose.yml in /opt/cloudfleet/data/config/cache


echo "=============================="
echo "`date "+%F %T"` Starting containers ... "
echo "=============================="

(cd /opt/cloudfleet/data/config/cache && docker-compose -p blimp up -d)

echo "=============================="
echo "`date "+%F %T"`  Started containers. "
echo "=============================="
