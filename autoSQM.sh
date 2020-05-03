/etc/init.d/sqm stop
if [ ! -d /tmp/speedtestResult ]; then
mkdir /tmp/speedtestResult
fi
sh /root/betterspeedtest.sh -t 15 -n 15 -p www.google.com -H netperf-west.bufferbloat.net >> /tmp/speedtestResult/speedtestLog-"$(date +"%Y-%m-%d").log"
/etc/init.d/sqm start

#Get list of speedtest
cat "$(ls -rt /tmp/speedtestResult/*.log | tail -n1)" | grep -i download | tr -d "Download: " | tr -d Mbps | sort -n > /tmp/download.txt
cat "$(ls -rt /tmp/speedtestResult/*.log | tail -n1)" | grep -i upload | tr -d "Upload: " | tr -d Mbps | sort -n > /tmp/upload.txt

#get average speed for download & upload
download=`cat /tmp/download.txt  | awk -f median.awk | cut -f1 -d"."`
upload=`cat /tmp/upload.txt  | awk -f median.awk | cut -f1 -d"."`

#convert to Kbps & adjust to 80% speed
downloadKbps=$((download*1000*80/100))
uploadKbps=$((upload*1000*80/100))
echo $downloadKbps
echo $uploadKbps

#set value to SQM use uci
uci set sqm.eth1.upload=$uploadKbps
uci set sqm.eth1.download=$downloadKbps
uci commit
/etc/init.d/sqm reload

echo "auto sqm DONE!"
logger -t autoSQM -p info "Set download = $downloadKbps, upload = $uploadKbps"
