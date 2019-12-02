#!/bin/sh

echo "
root soft nofile 512000
root hard nofile 512000
">>/etc/security/limits.conf
sysctl -p
apt update
#安装环境
apt install python-pip git libssl-dev python-dev libffi-dev software-properties-common vim -y
add-apt-repository ppa:ondrej/php -y 
apt install libsodium-dev -y
#下载代码
cd /root
git clone -b manyuser https://github.com/GouGoGoal/ssr
cd ssr
pip install --upgrade setuptools 
pip install -r requirements.txt
cp apiconfig.py userapiconfig.py
cp config.json user-config.json
#传入nodeid参数
sed -i "2s/0/$1/" userapiconfig.py
#添加服务
cp -r /root/ssr/ssr.service /etc/systemd/system/
systemctl enable ssr
systemctl restart ssr
echo "sshd: ALL">/etc/hosts.allow
#修改时区
timedatectl set-timezone Asia/Shanghai
#添加定时重启、释放内存计划
chmod 755 /root/ssr/freeram.sh
echo "0 3 * * * root init 6
*/10 * * * * root /root/ssr/freeram.sh">>/etc/crontab
#更改开机启动时间0S
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=1/' /etc/default/grub
update-grub
#添加探针服务
cp state.service /etc/systemd/system

read -s -n1 -p "安装完毕，非游戏机请按任意键优化tcp连接"
##BBR以及内核优化
echo "
#开启内核转发
net.ipv4.ip_forward=1
#优先使用ram
vm.swappiness=0
#开启BBR
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
#关闭IPV6
net.ipv6.conf.all.disable_ipv6 = 1
#对于一个新建连接，内核要发送多少个 SYN 连接请求才决定放弃。
net.ipv4.tcp_syn_retries = 1
#对于远端的连接请求SYN，内核会发送SYN ＋ ACK数据报，以确认收到上一个 SYN连接请求包
net.ipv4.tcp_synack_retries = 1
#TCP发送keepalive探测消息的间隔时间（秒），用于确认TCP连接是否有效。
net.ipv4.tcp_keepalive_time = 600
#TCP发送keepalive探测消息的间隔时间（秒），用于确认TCP连接是否有效。
net.ipv4.tcp_keepalive_probes = 3
#探测消息未获得响应时，重发该消息的间隔时间（秒）。
net.ipv4.tcp_keepalive_intvl =15
#在丢弃激活(已建立通讯状况)的TCP连接之前﹐需要进行多少次重试
net.ipv4.tcp_retries2 = 5
#对于本端断开的socket连接，TCP保持在FIN-WAIT-2状态的时间
net.ipv4.tcp_fin_timeout = 2
#系统在同时所处理的最大 timewait sockets 数目
net.ipv4.tcp_max_tw_buckets = 36000
#打开快速 TIME-WAIT sockets 回收
net.ipv4.tcp_tw_recycle = 1
#对于那些依然还未获得客户端确认的连接请求﹐需要保存在队列中最大数目。
net.ipv4.tcp_max_syn_backlog = 16384
#发送缓存设置
net.ipv4.tcp_wmem = 8192 131072 16777216
#接收缓存设置
net.ipv4.tcp_rmem = 32768 131072 16777216
#
net.ipv4.tcp_mem = 786432 1048576 1572864

fs.file-max = 51200
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.netdev_max_backlog = 250000
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_mtu_probing = 1
">>/etc/sysctl.conf
sysctl -p
###########

