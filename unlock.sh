#! /bin/bash

#获取脚本相对路径
DIR=`dirname $0`
chmod +x  $DIR/smartdns
mv $DIR/smartdns /usr/bin
#加载服务
echo "[Unit]
Description=smartdns server
After=network.target
Before=ssr.service v2ray.service docker.service

[Service]
Type=simple
PIDFile=/run/smartdns.pid
ExecStart=/usr/bin/smartdns -f -c /etc/smartdns.conf
ExecStartPre=/bin/sleep 0.1
Restart=always

[Install]
WantedBy=multi-user.target" >/etc/systemd/system/smartdns.service
#服务开机自启
systemctl enable smartdns
#给脚本执行权限
chmod +x $DIR/smartdns.sh
#移动/etc下
mv $DIR/smartdns.sh /etc/smartdns.sh
mv $DIR/ban.conf /etc/ban.conf
#执行一次
bash /etc/smartdns.sh
#添加定时脚本
echo "* * * * * root /etc/smartdns.sh">>/etc/crontab
#脚本自删除
rm -f  $DIR/unlock.sh
