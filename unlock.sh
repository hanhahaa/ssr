#! /bin/bash

#获取脚本相对路径
DIR=`dirname $0`
chmod +x  $DIR/smartdns
mv $DIR/smartdns /usr/sbin
#加载服务
echo "[Unit]
Description=SmartDNS server
After=network.target NetworkManager.service
Before=rc-local.service

[Service]
Type=simple
ExecStartPre=`which iptables|tail -1` -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination 127.0.0.1:53
ExecStart=/usr/sbin/smartdns -f -c /etc/smartdns.conf
ExecStopPost=`which iptables|tail -1` -t nat -D OUTPUT -p udp --dport 53 -j DNAT --to-destination 127.0.0.1:53
Restart=always

[Install]
WantedBy=multi-user.target" >/etc/systemd/system/smartdns.service
#服务开机自启
systemctl daemon-reload
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
#提示
echo "部署完毕，定时任务添加至/etc/crontab"
echo "后续可通过/etc/smartdns.sh更改解锁地址"
echo "若更改了解锁地址，请手动删除/etc/smartdns.conf然后待其重新生成配置"