#!/bin/sh

baseDir=$(dirname $(readlink -f "$0"))
/usr/sbin/nginx -p $baseDir/../nginx -c nginx.conf
