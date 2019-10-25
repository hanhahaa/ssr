#!/bin/bash


if ['free -m | awk '/Mem/ {print $3}'' -gt 400]; then
       echo "重启SSR服务，释放内存"
       systemctl restart ssr
fi
       
