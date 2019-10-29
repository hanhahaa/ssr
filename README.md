### 重装Debian9
bash <(wget --no-check-certificate -qO- 'https://moeclub.org/attachment/LinuxShell/InstallNET.sh') -d 9 -v 64 -a <br>
 
### 一键后端安装
bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/gougogoal/ssr/manyuser/setup.sh') 44

### 开机自启
cat <<EOF >/etc/rc.local
#!/bin/sh -e
#rc.local
#This script is executed at the end of each multiuser runlevel.
#Make sure that the script will "exit 0" on success or any other
#value on error.
#In order to enable or disable this script just change the execution
#bits.
#By default this script does nothing.

bash /root/ssr/iptables.sh

exit 0
EOF

chmod +x /etc/rc.local
systemctl restart rc-local
systemctl status rc-local


## Debian安装步骤

### 安装环境

apt update<br>
apt install python-pip git libssl-dev python-dev libffi-dev software-properties-common vim -y<br>
add-apt-repository ppa:ondrej/php -y && apt update<br>
apt install libsodium-dev -y <br>

### 下载SSR后端脚本并修改配置

git clone -b manyuser https://github.com/GouGoGoal/ssr<br>
cd ssr<br>
pip install --upgrade setuptools 
pip install -r requirements.txt<br>
cp apiconfig.py userapiconfig.py<br>
cp config.json user-config.json<br>

### 配置systemd，开机自启SS后端

cp -r /root/ssr/ssr.service /etc/systemd/system/<br>
systemctl start ssr<br>
systemctl enable ssr<br>
echo "sshd: ALL" > /etc/hosts.allow<br>

#防止 auto block 了自己无法连接 ssh

## Debian时区更改

timedatectl set-timezone Asia/Shanghai</br>

Debian8  dpkg-reconfigure tzdata</br>

#### 上边不行用下边

echo "export TZ='Asia/Shanghai'"  >> /etc/profile<br>
cat /etc/profile |grep TZ<br>
source /etc/profile<br>
date -R<br>

