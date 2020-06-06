/etc/init.d/sqm stop
sh monitor.sh & APP_PID=$!                              
wget -O /dev/null http://speedtest.tele2.net/20MB.zip
echo $APP_PID        
kill -9 $APP_PID
download=`cat /root/download.txt  | awk -f median.awk`
downloadKbps=$(awk "BEGIN {download = $download; print download*90/100}")
echo $downloadKbps
if [ "$downloadKbps" -gt 1000 ]; then
echo "setting up SQM with new value"
uci set sqm.eth1.download=${downloadKbps%%.*}
uci commit
echo "auto sqm DONE!"
logger -t autoSQM -p info "Set download = $downloadKbps"
fi
/etc/init.d/sqm start
