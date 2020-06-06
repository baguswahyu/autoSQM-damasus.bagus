#!/bin/sh /etc/rc.common
rm -rf /root/download.txt
while true; do
   RX_1=`ifconfig eth1 | grep "RX bytes" | cut -f 2 -d : | cut -f 1 -d "("`
   TX_1=`ifconfig eth1 | grep "TX bytes" | cut -f 3 -d : | cut -f 1 -d "("`
   sleep 6
   RX_2=`ifconfig eth1 | grep "RX bytes" | cut -f 2 -d : | cut -f 1 -d "("`
   TX_2=`ifconfig eth1 | grep "TX bytes" | cut -f 3 -d : | cut -f 1 -d "("`

   RX_3=$(($RX_2 - $RX_1))
   RX_BYTES=$(($RX_3 * 10 / 60))
   RX_MBITS=$(($RX_BYTES / 125000))
   RX_KBITS=$(($RX_MBITS * 1000))

   TX_3=$(($TX_2 - $TX_1))
   TX_BYTES=$(($TX_3 * 10 / 60))
   TX_MBITS=$(($TX_BYTES / 125000))

   #echo "Averages bytes difference: download - $RX_BYTES bytes, upload - $TX_BYTES bytes"
   #echo "Average MBits/sec: download - $RX_MBITS, upload - $TX_MBITS"
   #echo "done"
   echo "$RX_KBITS" >> /root/download.txt
done
