### 加速脚本选择
wget -N --no-check-certificate "https://raw.githubusercontent.com/gougogoal/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh<br>
### 重装Debian9
wget --no-check-certificate  https://moeclub.org/attachment/LinuxShell/InstallNET.sh <br>
### Linux测试脚本
wget -qO- --no-check-certificate https://raw.githubusercontent.com/oooldking/script/master/superbench.sh | bash<br>

### 阿里云一键净化<br>
wget https://raw.githubusercontent.com/MeowLove/AlibabaCloud-CentOS7-Pure-and-safe/master/download/kill/Snapshot_image.sh && chmod +x Snapshot_image.sh

### Iptable脚本
wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/iptables-pf.sh && chmod +x iptables-pf.sh 

### 一键后端安装
wget -N --no-check-certificate https://raw.githubusercontent.com/gougogoal/plane/manyuser/setup.sh 

## Debian安装步骤

### 安装环境

apt update<br>
apt install python-pip git libssl-dev python-dev libffi-dev software-properties-common vim -y<br>
add-apt-repository ppa:ondrej/php -y && apt update<br>
apt install libsodium-dev -y <br>

### 下载SSR后端脚本并修改配置

git clone -b manyuser https://github.com/GouGoGoal/ssr<br>
cd ssr<br>
pip install -r requirements.txt<br>
cp apiconfig.py userapiconfig.py<br>
cp config.json user-config.json<br>

### 配置systemd，开机自启SS后端

cp -r /root/shadowsocks/ssr.service /etc/systemd/system/<br>
systemctl start ssr<br>
systemctl enable ssr<br>
echo "sshd: ALL" > /etc/hosts.allow<br>

#防止 auto block 了自己无法连接 ssh


## Debian时区更改

timedatectl set-timezone Asia/Shanghai

#### 上边不行用下边

echo "export TZ='Asia/Shanghai'"  >> /etc/profile<br>
cat /etc/profile |grep TZ<br>
source /etc/profile<br>
date -R<br>
