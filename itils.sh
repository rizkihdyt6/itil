#!/bin/bash

cd
apt update;apt upgrade -y
mkdir -p /root/udp
touch /root/.udp-account

# change to time GMT+7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
apt install cron -y
# install nenen
echo downloading nenen
wget -q --show-progress --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=12safUbdfI6kUEfb1MBRxlDfmV8NAaJmb' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=12safUbdfI6kUEfb1MBRxlDfmV8NAaJmb" -O /root/udp/nenen && rm -rf /tmp/cookies.txt
chmod +x /root/udp/nenen

cat > /root/udp/config.json << END
{
  "stream_buffer": 33554432,
  "receive_buffer": 83886080,
  "user": "epro",
  "auth": {
    "mode": "passwords",
    "pass": [
//ewe
"dev",
"team"
   ]
  }
}
END
chmod 644 /root/udp/config.json


if [ -z "$1" ]; then
cat <<EOF > /etc/systemd/system/nenen.service
[Unit]
Description=nenen by ePro Dev. Team

[Service]
User=root
Type=simple
ExecStart=/root/udp/nenen server
WorkingDirectory=/root/udp/
Restart=always
RestartSec=2s

[Install]
WantedBy=default.target
EOF
else
cat <<EOF > /etc/systemd/system/nenen.service
[Unit]
Description=nenen by ePro Dev. Team

[Service]
User=root
Type=simple
ExecStart=/root/udp/nenen server -exclude $1
WorkingDirectory=/root/udp/
Restart=always
RestartSec=2s

[Install]
WantedBy=default.target
EOF
fi

echo start service nenen
systemctl start nenen &>/dev/null

echo enable service nenen
systemctl enable nenen &>/dev/null

cat > /etc/cron.d/xp_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
2 0 * * * root /usr/bin/xp
END

service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1
reboot
