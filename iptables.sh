#!/bin/bash
#初次运行请先执行下方命令允许内核转发
#echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf && sysctl -p
#并设置定时任务，每分钟执行一次，不会请谷歌
#与iptables转发链规则冲突，可添加规则到reset_iptables函数最后一行，如无必要，docker请使用host模式
#执行 iptables -t nat -F 可手动清除转发规则

#single_rule="本机IP 本机端口  远程IP 远程端口",其中第二个参数不可重复，以空格分隔，内网转发的话本地IP和远程IP为一个网段
#举例single_rule="192.168.1.1 1000  1.1.1.1 2000" 
#即本机的1000端口转发1.1.1.1:2000端口，其中本机IP可通过 ip a命令查看
#须以自然数方式递增,否则命令执行不完全
#single_rule1="192.168.1.1 1000 example1.com 10010"
#single_rule2="192.168.1.1 1001 example2.com 10086"

#端口段转发，方法与单端类似
#multi_rule1="192.168.1.1 1000:2000 example1.com 2000:3000"
#multi_rule2="192.168.1.1 2001:3000 example2.com 4001:5000"

reset_iptables() {
iptables -t nat -F POSTROUTING
iptables -t nat -F PREROUTING
#单端口转发####################################
i=1
temp=single_rule${i}
eval rule=$(echo \$$temp)
while [ -n "$rule" ]
do
#读取本地IP、读取本地端口、读取远程IP、读取远程端口
local_ip=`echo $rule | awk -F ' ' '{print $1}'` 
local_port=`echo $rule| awk -F ' ' '{print $2}'`
remote_ip=`echo $rule | awk -F ' ' '{print $3}'`
remote_ip=`ping -c1 "$remote_ip"|awk -F'[(|)]' 'NR==1{print $2}'`
remote_port=`echo $rule | awk -F ' ' '{print $4}'`
#中转TCP
iptables -t nat -A PREROUTING -p tcp -m tcp --dport $local_port -j DNAT --to-destination $remote_ip:$remote_port
iptables -t nat -A POSTROUTING -d $remote_ip -p tcp -m tcp --dport $remote_port -j SNAT --to-source $local_ip
#中转UDP
iptables -t nat -A PREROUTING -p udp -m udp --dport $local_port -j DNAT --to-destination $remote_ip:$remote_port
iptables -t nat -A POSTROUTING -d $remote_ip -p udp -m udp --dport $remote_port -j SNAT --to-source $local_ip
let i++
temp=single_rule${i}
eval rule=$(echo \$$temp)
done
#端口段转发####################################
i=1
temp=multi_rule${i}
eval rule=$(echo \$$temp)
while [ -n "$rule" ]
do
#读取本地IP、读取本地端口、读取远程IP、读取远程端口
local_ip=`echo $rule | awk -F ' ' '{print $1}'` 
local_port=`echo $rule| awk -F ' ' '{print $2}'`
local_start_port=`echo $local_port| awk -F ':' '{print $1}'`
local_end_port=`echo $local_port| awk -F ':' '{print $2}'`
remote_ip=`echo $rule | awk -F ' ' '{print $3}'`
remote_ip=`ping -c1 "$remote_ip"|awk -F'[(|)]' 'NR==1{print $2}'`
remote_port=`echo $rule | awk -F ' ' '{print $4}'`
remote_start_port=`echo $remote_port| awk -F ':' '{print $1}'`
remote_end_port=`echo $remote_port| awk -F ':' '{print $2}'`

#TCP转发
iptables -t nat -A PREROUTING -p tcp -m tcp --dport $local_port -j DNAT --to-destination $remote_ip:$remote_start_port-$remote_end_port
iptables -t nat -A POSTROUTING -d $remote_ip -p tcp -m tcp --dport $remote_port -j SNAT --to-source $local_ip
#UDP转发
iptables -t nat -A PREROUTING -p udp -m udp --dport $local_port -j DNAT --to-destination $remote_ip:$remote_start_port-$remote_end_port
iptables -t nat -A POSTROUTING -d $remote_ip -p udp -m udp --dport $remote_port -j SNAT --to-source $local_ip

let i++
temp=multi_rule${i}
eval rule=$(echo \$$temp)
done
#需要添加的其他规则以及Docker重启########
#systemctl restart docker
}



#单端口规则转发检测#################################
x=1
temp=single_rule${x}
eval rule=$(echo \$$temp)
while [ -n "$rule" ]
do
remote_ip=`echo $rule| awk -F ' ' '{print $3}'`
remote_ip=`ping -c1 "$remote_ip"|awk -F'[(|)]' 'NR==1{print $2}'`

if [ -z "`iptables -nL -t nat|grep $remote_ip`" ];then
    echo "单端口转发IP有变动，已刷新iptables规则"
    reset_iptables
    exit 0
fi

let x++
temp=single_rule${x}
eval rule=$(echo \$$temp)
done
#端口段规则转发检测#################################
x=1
temp=multi_rule${x}
eval rule=$(echo \$$temp)
while [ -n "$rule" ]
do
remote_ip=`echo $rule| awk -F ' ' '{print $3}'`
remote_ip=`ping -c1 "$remote_ip"|awk -F'[(|)]' 'NR==1{print $2}'`

if [ -z "`iptables -nL -t nat|grep $remote_ip`" ];then
    echo "端口段转发IP有变动，已刷新iptables规则"
    reset_iptables
    exit 0
fi
let x++
temp=multi_rule${x}
eval rule=$(echo \$$temp)
done

if   [ "$single_rule1" = "" -a  "$multi_rule1" ="" ];then
    echo "当前无转发规则"
    exit 0
fi
echo "IP无变动"
