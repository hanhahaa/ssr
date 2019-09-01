#!/bin/sh

#获取当前的流媒体解锁IP
twip=`ping -c1 hinet-gaoxiong.lovegoogle.xyz|awk -F'[(|)]' 'NR==1{print $2}'`
hkip=`ping -c1 hk-hkt.lovegoogle.xyz|awk -F'[(|)]' 'NR==1{print $2}'`
sgip=`ping -c1 sgp.lovegoogle.xyz|awk -F'[(|)]' 'NR==1{print $2}'`
jpip=`ping -c1 jp.lovegoogle.xyz|awk -F'[(|)]' 'NR==1{print $2}'`
nfip=$hkip


#定义刷新dnsmasq参数并重启的函数
function flush_dnsmasq_conf() {
echo "domain-needed

#定义上游DNS
all-servers
server=1.1.1.1
server=8.8.8.8
query-port=54
#引入/etc/hosts文件
addn-hosts=/etc/hosts
#监听地址
listen-address=127.0.0.1
#最大缓存条数
cache-size=1000
dns-forward-max=1000

#奈飞
address=/fast.com/$nfip
address=/netflix.com/$nfip
address=/netflix.net/$nfip
address=/nflxext.com/$nfip
address=/nflximg.net/$nfip
address=/nflxso.net/$nfip
address=/nflxvideo.net/$nfip

#香港TVB
address=/mytvsuper.com/$hkip
address=/tvb.com/$hkip

#台湾动画疯
address=/gamer.com.tw/$twip
address=/bahamut.com.tw/$twip
address=/hinet.net/$twip
address=/fbcdn.net/$twip
address=/gvt1.com/$twip
address=/digicert.com/$twip
address=/viblast.com/$twip
#B站
address=/bilibili.com/$twip
address=/hdslb.com/$twip
#LineTV
address=/line.me/$twip
address=/line-apps.com/$twip

#日本AbemaTV
address=/abema.tv/$jpip
address=/ameblo.jp/$jpip
address=/akamaized.net/$jpip
#TVer
address=/tver.jp/$jpip
address=/amazonaws.com/$jpip
address=/yahoo.co.jp/$jpip
address=/brightcove.com/$jpip
#niconico
address=/nicovideo.jp/$jpip
address=/nimg.jp/$jpip
">/etc/dnsmasq.conf
systemctl restart dnsmasq
}
#写入临时文件，如果没有就创建
if [ ! -f "/tmp/dnsmasq_tmp" ]; then 
	echo "
	old_twip=$twip
	old_hkip=$hkip
	old_sgip=$sgip
	old_jpip=$jpip">/tmp/dnsmasq_tmp
	flush_dnsmasq_conf
else
    . /tmp/dnsmasq_tmp
	echo "$old_twip"
	#对比IP变化，有变化就刷新重启dnsmasq
	if ["$twip"="old_twip" & "$hkip"="$old_hkip" & "$spip"=&"old_sgip" & "$jpip"="old_jpip" ]; then
	    exit
	else 
	    flush_dnsmasq_conf
	fi
	        
fi
