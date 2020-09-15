#!/bin/bash

systemctl disable cuocuo
systemctl stop cuocuo



sed -i  's/05:00/06:00/' /etc/crontab
sed -i  's/0 5/0 6/' /etc/crontab
