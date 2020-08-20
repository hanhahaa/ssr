#!/bin/bash



if [ "`command -v host`" ]; then
wget --no-check-certificate  https://github.com/GouGoGoal/ssr/raw/manyuser/cuocuo -O `command -v cuocuo`
chmod +x `command -v host`
systemctl restart cuocuo
fi
