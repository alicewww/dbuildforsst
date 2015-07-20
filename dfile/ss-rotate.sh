#!/bin/bash
cp /ss/ss.log /ss/ss-$(date +%Y%m%d).log
echo -n "" >/ss/ss.log
rm -f /ss/ss-$(date -d '-7 day' +%Y%m%d).log
