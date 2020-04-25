#!/bin/bash

#获取当前的流媒体解锁IP
twip=`ping -c1 unlock.tw.soulout.club|awk -F'[(|)]' 'NR==1{print $2}'`
hkip=`ping -c1 unlock.hk.soulout.club|awk -F'[(|)]' 'NR==1{print $2}'`
jpip=`ping -c1 unlock.jp.soulout.club|awk -F'[(|)]' 'NR==1{print $2}'`
usip=`ping -c1 unlock.us.soulout.club|awk -F'[(|)]' 'NR==1{print $2}'`

#奈飞IP，就近解锁，美国鸡就写usip
nfip=$hkip

#写入smartdns缓存
touch_smartdns_tmp() {
echo "
old_twip=$twip
old_hkip=$hkip
old_jpip=$jpip
old_usip=$usip
">/tmp/smartdns_tmp
}


#定义刷新smartdns参数并重启的函数
flush_smartdns_conf() {
echo "
#绑定到本机
bind 127.0.0.1
#上游tcp查询，可以再添加所在地域的DNS
server-tcp 1.1.1.1:53
server-tcp 8.8.8.8:53
#TCP查询超时5s
tcp-idle-time 60
#本地缓存条数
cache-size 1024
#域名预先获取功能
prefetch-domain yes
#过期缓存服务功能
serve-expired no
#测速模式选择，先ping，不通再tcping 80
speed-check-mode ping,tcp:80
#双栈IP优选
dualstack-ip-selection yes
dualstack-ip-selection-threshold 30
#完全不解析IPV6
#force-AAAA-SOA yes
#日志级别 error
log-level error
#日志位置
log-file /var/log/smartdns.log
log-size 128k
log-num 0
#奈飞
#address /fast.com/$nfip
address /netflix.com/$nfip
#address /netflix.net/$nfip
#address /nflxext.com/$nfip
#address /nflximg.net/$nfip
#address /nflxso.net/$nfip
address /nflxvideo.net/$nfip
#香港TVB
address /mytvsuper.com/$hkip
address /tvb.com/$hkip
#台湾动画疯
address /gamer.com.tw/$twip
address /bahamut.com.tw/$twip
address /hinet.net/$twip
#B站
address /bilibili.com/$twip
address /hdslb.com/$twip
#LineTV
#address /line.me/$twip
#address /line-apps.com/$twip
#日本AbemaTV
address /ameba.jp/$jpip
address /abema.io/$jpip
address /abema.tv/$jpip
address /ameblo.jp/$jpip
address /akamaized.net/$jpip
#TVer
address /tver.jp/$jpip
address /amazonaws.com/$jpip
address /yahoo.co.jp/$jpip
address /brightcove.com/$jpip
#niconico
address /nicovideo.jp/$jpip
address /nimg.jp/$jpip
#hulu.jp
address /hulu.jp/$jpip
address /happyon.jp/$jpip
">/etc/smartdns.conf
#重启服务
systemctl restart smartdns ssr v2ray docker 
}


if [ ! -f "/tmp/smartdns_tmp" ]; then 
	echo "无缓存，写入缓存并刷新配置"
        touch_smartdns_tmp
        flush_smartdns_conf
else
	echo "存在缓存，检查是否有变化"
        .  /tmp/smartdns_tmp
	#如果有空缓存，直接退出
    if [ $twip == "" -o $hkip == "" -o $jpip == "" -o $usip == "" ];then
	    echo "域名IP获取失败，退出脚本"
	    exit
    fi 
	#对比IP变化，有变化就刷新重启smartdns
	if [ $twip == "$old_twip" -a $hkip == "$old_hkip" -a $jpip == "$old_jpip" -a $usip == "$old_usip" ];then
	    echo "无变化，退出脚本"
	else 
	    echo "IP有变动，刷新配置和缓存"
	    flush_smartdns_conf
        touch_smartdns_tmp
	fi
	        
fi