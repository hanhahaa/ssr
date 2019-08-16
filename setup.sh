#!/bin/sh

apt update
#安装环境
apt install python-pip git libssl-dev python-dev libffi-dev software-properties-common vim -y
add-apt-repository ppa:ondrej/php -y 
apt install libsodium-dev -y
#下载代码
git clone -b manyuser https://github.com/GouGoGoal/ssr
cd ssr
pip install -r requirements.txt
cp apiconfig.py userapiconfig.py
cp config.json user-config.json
#传入nodeid参数
sed -i '2s/0/$1/' userapiconfig.py
#添加服务
cp -r /root/plane/ssr.service /etc/systemd/system/
systemctl enable ssr
systemctl restart ssr
echo "sshd: ALL">/etc/hosts.allow
#修改时区
timedatectl set-timezone Asia/Shanghai

#添加定时重启计划
echo "0 3 * * * root reboot">>/etc/crontab
