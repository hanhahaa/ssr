### 测速脚本
wget -qO- bench.sh | bash        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;纯净<br>
bash <(wget --no-check-certificate -qO- 'https://ilemonrain.com/download/shell/LemonBench.sh') --mode fast <br>
bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/oooldking/script/master/superbench.sh')<br>
### 重装Debian9
bash <(wget --no-check-certificate -qO- 'https://moeclub.org/attachment/LinuxShell/InstallNET.sh') -d 9 -v 64 -a <br>
密码  MoeClub.org
### 重装Debian10
bash <(wget --no-check-certificate -qO- 'https://www.cxthhhhh.com/tech-tools/Network-Reinstall-System-Modify/CoreShell/Core_Install.sh' ) -d 10 -v 64 -a<br>
 密码  cxthhhhh.com<br>
 国内源      --mirror 'http://mirrors.ustc.edu.cn/debian/'
### 一键后端安装
bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/gougogoal/ssr/manyuser/setup.sh') 44

### 开机自启<br>
cat <<EOF >/etc/rc.local<br>
#!/bin/sh -e<br>
#rc.local<br>
#This script is executed at the end of each multiuser runlevel.<br>
#Make sure that the script will "exit 0" on success or any other<br>
#value on error.<br>
#In order to enable or disable this script just change the execution<br>
#bits.<br>
#By default this script does nothing.<br>

bash /root/ssr/iptables.sh<br>

exit 0<br>
EOF<br>

chmod +x /etc/rc.local<br>
systemctl restart rc-local<br>
systemctl status rc-local<br>


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

