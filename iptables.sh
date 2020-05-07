
#!/bin/bash

# https://soulout.club  的帅比站长制作
#需要修改内核参数支持转发；在 /etc/sysctl.conf 添加一行  net.ipv4.ip_forward=1 ，之后 sysctl -p
#并设置定时任务，每分钟执行一次，不会请谷歌
#与iptables转发链规则冲突，可添加规则到reset_iptables函数，如无必要，docker请使用host模式
if [ `whoami` = "root" ];then
	echo "请以root用户执行"
	exit 0
fi

#ip=ping -c1 欲转发域名|awk -F'[(|)]' 'NR==1{print $2}'`
#欲转发域名的端口
#本机转发使用的端口(和上方端口段保持一致即可)

#内网IP，可通过 ip a 查看
inip=10.111.102.100


ip1=`ping -c1 soulout.club|awk -F'[(|)]' 'NR==1{print $2}'`
ip1port=8080
port1=8080

#ip2=`ping -c1 soulout.club|awk -F'[(|)]' 'NR==1{print $2}'`
#ip2port=8080
#port2=8080

#ip3=`ping -c1 soulout.club|awk -F'[(|)]' 'NR==1{print $2}'`
#ip3port=8080
#port3=8080

#ip4格式可以转发端口段，start_end，保持这两个段的差值一致
#ip4=`ping -c1 soulout.club|awk -F'[(|)]' 'NR==1{print $2}'`
#ip4port_start=8080
#ip4port_end=8080
#port4_start=8080
#port4_end=8080


touch_iptables_tmp() {
echo "old_ip1=$ip1">/tmp/iptables_tmp
#echo "old_ip2=$ip2">>/tmp/iptables_tmp
#echo "old_ip3=$ip3">>/tmp/iptables_tmp
#echo "old_ip4=$ip4">>/tmp/iptables_tmp
}

reset_iptables() {
iptables -t nat -F POSTROUTING
iptables -t nat -F PREROUTING


iptables -t nat -A PREROUTING -p tcp -m tcp --dport $port1 -j DNAT --to-destination $ip1:$ip1port
iptables -t nat -A PREROUTING -p udp -m udp --dport $port1 -j DNAT --to-destination $ip1:$ip1port
iptables -t nat -A POSTROUTING -d $ip1 -p tcp -m tcp --dport $ip1port -j SNAT --to-source $inip
iptables -t nat -A POSTROUTING -d $ip1 -p udp -m udp --dport $ip1port -j SNAT --to-source $inip

#iptables -t nat -A PREROUTING -p tcp -m tcp --dport $port2 -j DNAT --to-destination $ip2:$ip2port
#iptables -t nat -A PREROUTING -p udp -m udp --dport $port2 -j DNAT --to-destination $ip2:$ip2port
#iptables -t nat -A POSTROUTING -d $ip2 -p tcp -m tcp --dport $ip2port -j SNAT --to-source $inip
#iptables -t nat -A POSTROUTING -d $ip2 -p udp -m udp --dport $ip2port -j SNAT --to-source $inip

#iptables -t nat -A PREROUTING -p tcp -m tcp --dport $port3 -j DNAT --to-destination $ip3:$ip3port
#iptables -t nat -A PREROUTING -p udp -m udp --dport $port3 -j DNAT --to-destination $ip3:$ip3port
#iptables -t nat -A POSTROUTING -d $ip3 -p tcp -m tcp --dport $ip3port -j SNAT --to-source $inip
#iptables -t nat -A POSTROUTING -d $ip3 -p udp -m udp --dport $ip3port -j SNAT --to-source $inip


#iptables -t nat -A PREROUTING -p tcp -m tcp --dport $port4_start:$port4_end -j DNAT --to-destination $ip4:$ip4port_start-$ip4port_end
#iptables -t nat -A PREROUTING -p udp -m udp --dport $port4_start:$port4_end -j DNAT --to-destination $ip4:$ip4port_start-$ip4port_end
#iptables -t nat -A POSTROUTING -d $ip4 -p tcp -m tcp --dport $port4_start:$port4_end -j SNAT --to-source $inip
#iptables -t nat -A POSTROUTING -d $ip4 -p udp -m udp --dport $port4_start:$port4_end -j SNAT --to-source $inip

#本地转发,手动更改端口
#iptables -t nat -A PREROUTING -p tcp -m tcp --dport 51034 -j DNAT --to-destination $inip:80
#iptables -t nat -A PREROUTING -p udp -m udp --dport 51034 -j DNAT --to-destination $inip:80
#iptables -t nat -A POSTROUTING -d $inip -p tcp -m tcp --dport 80 -j SNAT --to-source $inip
#iptables -t nat -A POSTROUTING -d $inip -p udp -m udp --dport 80 -j SNAT --to-source $inip
}


if [ ! -f "/tmp/iptables_tmp" ]; then 
	echo "无缓存，写入缓存并刷新配置"
        touch_iptables_tmp
        reset_iptables
else
	echo "存在缓存，检查是否有变化"
        .  /tmp/iptables_tmp
	#对比IP变化，有变化就刷新iptables
	#if [ $ip1 == "$old_ip1" -a $ip2 == "$old_ip2" ];then 如果转发的更多，请按照格式添加
	if [ $ip1 == "$old_ip1" ];then
	    echo "无变化，退出脚本"
	    exit
	else 
	    echo "IP有变动，刷新配置和缓存"
	    reset_iptables
            touch_iptables_tmp
	fi
	        
fi
