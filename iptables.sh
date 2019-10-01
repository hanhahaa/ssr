
#!/bin/sh

#ip=ping -c1 欲转发域名|awk -F'[(|)]' 'NR==1{print $2}'`
#欲转发域名的端口
#本机转发使用的端口

#内网IP，请在管理界面查看
inip=10.111.102.100

#ip1=$inip
ip1=`ping -c1 sgp.lovegoogle.xyz|awk -F'[(|)]' 'NR==1{print $2}'`
ip1port=8080
port1=8080

#ip2=`ping -c1 hinet-gaoxiong.lovegoogle.xyz|awk -F'[(|)]' 'NR==1{print $2}'`
#ip2port=8080
#port2=8080

#ip3=`ping -c1 hkt.lovegoogle.xyz|awk -F'[(|)]' 'NR==1{print $2}'`
#ip3port=8080
#port3=8080

#ip4=`ping -c1 jp.lovegoogle.xyz|awk -F'[(|)]' 'NR==1{print $2}'`
#ip4port=8080
#port4=8080

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


#iptables -t nat -A PREROUTING -p tcp -m tcp --dport $port4 -j DNAT --to-destination $ip4:$ip4port
#iptables -t nat -A PREROUTING -p udp -m udp --dport $port4 -j DNAT --to-destination $ip4:$ip4port
#iptables -t nat -A POSTROUTING -d $ip4 -p tcp -m tcp --dport $ip4port -j SNAT --to-source $inip
#iptables -t nat -A POSTROUTING -d $ip4 -p udp -m udp --dport $ip4port -j SNAT --to-source $inip

#本地转发,手动更改端口
#iptables -t nat -A PREROUTING -p tcp -m tcp --dport 51034 -j DNAT --to-destination $inip:80
#iptables -t nat -A PREROUTING -p udp -m udp --dport 51034 -j DNAT --to-destination $inip:80
#iptables -t nat -A POSTROUTING -d $inip -p tcp -m tcp --dport 80 -j SNAT --to-source $inip
#iptables -t nat -A POSTROUTING -d $inip -p udp -m udp --dport 80 -j SNAT --to-source $inip
