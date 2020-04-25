## 测速脚本
```
wget -qO- bench.sh | bash        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;纯净
curl -fsL https://ilemonra.in/LemonBenchIntl | bash -s fast 
bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/oooldking/script/master/superbench.sh')
bash <(wget --no-check-certificate -qO- 'https://git.io/superspeed' )
```
## 重装Debian10
```
bash <(wget --no-check-certificate -qO- 'https://github.com/GouGoGoal/SSPanel-Uim/raw/master/InstallNET.sh') -d 10 -v 64 -a [-i ens4]
国内源      --mirror 'http://mirrors.ustc.edu.cn/debian/'
日本源      --mirror 'http://ftp.jp.debian.org/debian/'
台湾源      --mirror 'http://ftp.tw.debian.org/debian/'
```

## 一键后端安装
```
bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/gougogoal/ssr/manyuser/setup.sh') 70 alihk1 [ovz]
```
## web_transfer.py 第 365行端口偏移

## CentOS安装<br>
```
yum install openssl-devel  libffi libffi-dev python3
pip3 install --upgrade setuptools 
pip3 install cymysql requests pyOpenSSL ndg-httpsclient pyasn1 pycparser pycryptodome idna speedtest-cli
mv apiconfig.py userapiconfig.py
mv config.json user-config.json
mv  /root/ssr/ssr.service /etc/systemd/system/
systemctl enable ssr
systemctl restart ssr
#优先使用IPV6地址 
echo "precedence ::ffff:0:0/96  100" >>/etc/gai.conf
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
#可以分配所有物理内存
vm.overcommit_memory=1
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


mv /root/ssr/state.service /etc/systemd/system/
systemctl enable state
systemctl restart state
```

```
优先使用IPV6地址 
echo "precedence ::ffff:0:0/96  100" >>/etc/gai.conf
```
