#!/bin/bash


#给SSR进行tls加密
if [ "`grep -w 'stream {' /etc/nginx/nginx.conf`" == "" ];then 
	echo -e "stream {
\tserver {
\t\tlisten 8081 reuseport ssl;
\t\tlisten 8081 udp reuseport;
\t\tproxy_pass 127.0.0.1:8080;

\t\tssl_certificate    /etc/nginx/tls/full_chain.pem;	
\t\tssl_certificate_key    /etc/nginx/tls/private.key;
\t\tssl_protocols       TLSv1.2 TLSv1.3;
\t\tssl_ciphers  ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
\t\ttcp_nodelay on;
\t}
}">>/etc/nginx/nginx.conf
fi

#不将SSR端口暴露至公网
echo '{
    "server": "0.0.0.0",
    "#server_ipv6": "::",
    "server_port": 8388,
    "local_address": "127.0.0.1",
    "local_port": 1080,

    "password": "m",
    "timeout": 120,
    "udp_timeout": 60,
    "method": "aes-256-cfb",
    "protocol": "auth_aes128_md5",
    "protocol_param": "",
    "obfs": "tls1.2_ticket_auth_compatible",
    "obfs_param": "",
    "speed_limit_per_con": 0,

    "out_bind": "",
    "dns_ipv6": false,
    "connect_verbose_info": 0,
    "connect_hex_data": 0,
    "redirect": "",
    "fast_open": true,
    "friendly_detect": 1
}'>/root/ssr/user-config.json

