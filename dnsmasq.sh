#!/bin/sh

#解析当前流媒体解锁IP
twip=`ping -c1 hinet.gaoxiong.lovegoogle.xyz|awk -F'[(|)]' 'NR==1{print $2}'`
hkip=`ping -c1 hkt.lovegoogle.xyz|awk -F'[(|)]' 'NR==1{print $2}'`
sgpip=`ping -c1 sgp.lovegoogle.xyz|awk -F'[(|)]' 'NR==1{print $2}'`
jpip=`ping -c1 japan.lovegoogle.xyz|awk -F'[(|)]' 'NR==1{print $2}'`
nfip=$hkip

echo "domain-needed
#不使用本地hosts
no-hosts
#指定上游DNS
all-servers
server=1.1.1.1
server=8.8.8.8

query-port=54
#加载本地hosts
#addn-hosts=/etc/hosts
# 监听的IP地址
listen-address=127.0.0.1

#最大缓存条数
cache-size=1000
dns-forward-max=1000

###本地地址###
address=/localhost/127.0.0.1
address=/localhost/::1

###奈飞地址###
address=/fast.com/$nfip
address=/netflix.com/$nfip
address=/netflix.net/$nfip
address=/nflxext.com/$nfip
address=/nflximg.net/$nfip
address=/nflxso.net/$nfip
address=/nflxvideo.net/$nfip
###香港TVB###
address=/mytvsuper.com/$nfip
address=/tvb.com/$nfip
address=/ads.tvb.com/127.0.0.1
###台湾动画疯###
address=/gamer.com.tw/$twip
address=/bahamut.com.tw/$twip
address=/hinet.net/$twip
address=/fbcdn.net/$twip
address=/gvt1.com/$twip
address=/digicert.com/$twip
address=/viblast.com/$twip
###台湾B站###
address=/bilibili.com/$twip
address=/hdslb.com/$twip
###台湾Line TV###
address=/line.me/$twip
address=/line-apps.com/$twip
###日本AbemaTV###
address=/abema.tv/$jpip
address=/ameblo.jp/$jpip
address=/akamaized.net/$jpip
####日本TVer####
address=/tver.jp/$jpip
address=/amazonaws.com/$jpip
address=/yahoo.co.jp/$jpip
address=/brightcove.com/$jpip
####日本niconico####
address=/nicovideo.jp/$jpip
address=/nimg.jp/$jpip
">/etc/dnsmasq.conf

systemctl restart dnsmasq
