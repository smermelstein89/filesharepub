#!/bin/bash
IFS=$'\n' GLOBIGNORE='*' command eval  'group_array=($(cat /home/smerme.ca/ansible/group.txt))'
IFS=$'\n' GLOBIGNORE='*' command eval  'version_array=($(cat /home/smerme.ca/ansible/version.txt))'
count=0
for i in ${group_array[@]}
do
	echo "sed  '/${version_array[$count]/a $i' group_version_output.txt "
	let count=count+1
done

