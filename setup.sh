#!/bin/sh

if [ "$1" == '' ];then
echo "未赋值，退出脚本"
exit 0
fi

apt update
#安装环境
#apt install python3 python3-pip git libssl-dev libffi-dev software-properties-common vim python-m2crypto libsodium-dev -y
#add-apt-repository ppa:ondrej/php -y 
#apt install libsodium-dev -y
apt install -y python3 python3-pip git libsodium-dev vim libssl-dev swig 
#下载代码
cd /root
git clone -b manyuser https://github.com/GouGoGoal/ssr
cd ssr
pip3 install --upgrade setuptools 
pip3 install cymysql requests pyOpenSSL ndg-httpsclient pyasn1 pycparser pycryptodome idna speedtest-cli
#pip3 install M2Crypto
#pip3 install -r requirements.txt
mv apiconfig.py userapiconfig.py
mv config.json user-config.json
#传入nodeid参数
sed -i "2s/0/$1/" userapiconfig.py
#添加服务
mv  /root/ssr/ssr.service /etc/systemd/system/
systemctl enable ssr
systemctl restart ssr
echo "sshd: ALL">/etc/hosts.allow
#修改时区
timedatectl set-timezone Asia/Shanghai
#赋予脚本可执行权限
chmod  755 /root/ssr/*.sh
#添加定时重启、释放内存计划
echo "
#每晚三点重启
0 3 * * * root init 6
#每隔10分钟检查内存，高则自动释放
#*/10 * * * * root /root/ssr/freeram.sh
#每周一删除日志
25 2 * * 1 root rm -rf /var/log/*log.* ">>/etc/crontab
rm -rf setup.sh .git .gitignore README.md 
chmod 755 besttrace
mv besttrace /usr/bin

if [ "$2" == '' ];then
echo "未添加指针，退出脚本"
exit 0
fi
#添加探针服务
mv state.service /etc/systemd/system
sed -i "10s/node/$2/" state.py
systemctl enable state
systemctl restart state
echo "$2.lovegoogle.xyz已添加探针"

if [ "$3" == "ovz" ];then
echo "
#关闭IPV6
net.ipv6.conf.all.disable_ipv6 = 1
#开启内核转发
net.ipv4.ip_forward=1
">/etc/sysctl.conf
echo "已针对OVZ优化参数"
exit 0
fi

#优化最大文件打开
echo "
root soft nofile 512000
root hard nofile 512000
">>/etc/security/limits.conf
#BBR以及内核优化
echo "
#关闭IPV6
net.ipv6.conf.all.disable_ipv6 = 1
#开启BBR
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
#开启内核转发
net.ipv4.ip_forward=1
#优先使用ram
vm.swappiness=0
#TCP优化
fs.file-max = 512000
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.netdev_max_backlog = 250000
net.core.somaxconn = 4096
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_mem = 25600 51200 102400
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mtu_probing = 1
">/etc/sysctl.conf
sysctl -p
#更改开机启动时间1S
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=1/' /etc/default/grub
update-grub
echo "针对kvm优化参数，已开启BBR，已修改启动时间"

