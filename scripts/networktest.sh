#!/bin/bash

DATE=$(date +"%Y%m%d%H%M")
echo "What is the full path of the file with all the hosts names separated by line?"
read $HOSTS_FILE
#read each line of the file "$HOSTS_FILE" into a bash array called hostnames:
IFS=$'\n' read -d '' -r -a hostnames <$HOSTS_FILE 
#hostnames=(security_center)

for e in ${hostnames[@]}
do
while [ true ]
do
  ping -c1 $e
  if [ $? -eq 0 ]
  then 
    echo $e is ping-able >> hostnames_$DATE.txt
    exit 0
  fi
done
done
