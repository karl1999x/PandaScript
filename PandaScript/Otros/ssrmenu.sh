#!/bin/bash
echo ""
wget -q -O /tmp/ssr https://raw.githubusercontent.com/joaquin1444/MOD-V6/refs/heads/main/script-v6/Otros/msg
cat /tmp/ssr > /tmp/ssrrmu.sh
wget -q -O /tmp/ssr https://raw.githubusercontent.com/karl1999x/PandaScript/main/SCRIPTS/C-SSR.sh
cat /tmp/ssr >> /tmp/ssrrmu.sh
#curl  https://raw.githubusercontent.com/karl1999x/PandaScript/main/SCRIPTS/C-SSR.sh >> 
sed -i "s;VPS•MX;ChumoGH-ADM;g" /tmp/ssrrmu.sh
sed -i "s;@Kalix1;ChumoGH;g" /tmp/ssrrmu.sh
sed -i "s;VPS-MX;chumogh;g" /tmp/ssrrmu.sh
chmod +x /tmp/ssrrmu.sh && bash /tmp/ssrrmu.sh
#sed '/gnula.sh/ d' /tmp/ssrrmu.sh > /bin/ejecutar/crontab