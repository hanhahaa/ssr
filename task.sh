#!/bin/bash



#if [ "`command -v cuocuo`" ]; then
#wget --no-check-certificate  https://github.com/GouGoGoal/ssr/raw/manyuser/cuocuo -O `command -v cuocuo`
#chmod +x `command -v cuocuo`
#systemctl restart cuocuo
#fi

#修复v2ray的BUG

sed -i 's|SHELL=/bin/sh|SHELL=/bin/bash|' /etc/crontab
echo 'if [ "`journalctl -u v2ray -n 20|grep TransientFailure`" != "" ];then for line in `systemctl|grep v2ray|grep -v system|awk '{print $1}'`;do systemctl restart $line;done;fi' >>/etc/crontab