#!/bin/bash
# https://soulout.club  的帅比站长制作
#需要修改内核参数支持转发；在 /etc/sysctl.conf 添加一行  net.ipv4.ip_forward=1 ，之后 sysctl -p
#并设置定时任务，每分钟执行一次，不会请谷歌
#与iptables转发链规则冲突，可添加规则到reset_iptables函数最后一行，如无必要，docker请使用host模式


#single_rule="本机IP 本机端口  远程IP 远程端口",无纠错，请自行检查
#举例single_rule="192.168.1.1 1000  1.1.1.1 2000" 
#即本机的1000端口转发1.1.1.1:2000端口，其中本机IP可通过 ip a命令查看

#须以自然数方式递增,否则命令执行不完全
#single_rule1="192.168.1.88 1000 cn2.lovegoogle.xyz 1990"
#single_rule2="10.111.102.100 1001 soulout.club 8080"
#single_rule3="10.111.102.100 1002 soulout.club 8080"

#端口段转发，功能暂鸽
#multi_rule1

reset_iptables() {
iptables -t nat -F POSTROUTING
iptables -t nat -F PREROUTING
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
remote_port=`echo $rule | awk -F ' ' '{print $4}'` && if [ -z "remote_port" ]; then echo "single_rule$i 输入有误" && exit 0; fi
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
}



#主程序
x=1
temp=single_rule${x}
eval rule=$(echo \$$temp)
while [ -n "$rule" ]
do
remote_ip=`echo $rule| awk -F ' ' '{print $3}'`
remote_ip=`ping -c1 "$remote_ip"|awk -F'[(|)]' 'NR==1{print $2}'`

if [ -z "`iptables -nL -t nat|grep $remote_ip`" ];then
    echo "单端口转发IP有变动，已刷新iptables规则"
    reset_iptables > /dev/null
    exit 0
fi
let x++
temp=single_rule${x}
eval rule=$(echo \$$temp)
done
echo "单端口转发IP无变动"


