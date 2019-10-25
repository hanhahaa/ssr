#!/bin/bash

#单位为M，如果以G为单位改成free -g，内存使用到limit后释放
used_ram=`free -m | awk '/Mem/ {print $3}'`
limit_ram=400
if [ $used_ram -gt $limit_ram ]; then
       #内存释放执行的命令,重启docker之类的
       echo "重启SSR服务，释放内存"
       systemctl restart ssr
       #systemctl restart docker
       #docker restart ssr
else
       echo "内存无需释放"
fi
