#! /bin/bash
#获取脚本相对路径
DIR=`dirname $0`
chmod +x  smartdns
mv $DIR/smartdns /usr/bin
#加载服务
mv $DIR/smartdns.service /etc/systemd/system
#服务开机自启
systemctl enable smartdns
#给脚本执行权限
chmod +x $DIR/smartdns.sh
#移动/etc下
mv $DIR/smartdns.sh /etc/smartdns.sh
#执行一次
bash /etc/smartdns.sh
#添加定时脚本
echo "* * * * * root /etc/smartdns.sh">>/etc/crontab
#劫持本机所有的UDP *:53 的流量到127.0.0.1:53，并将规则开机自启
iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination 127.0.0.1:53
sed -i '$i\iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination 127.0.0.1:53' /etc/rc.local

#更改DNS，并设置为只读
echo "nameserver 127.0.0.1">/etc/resolv.conf
chattr +i /etc/resolv.conf
rm -rf $DIR
