#!/bin/bash
content_views=( "Extras" "RHEL5" "RHEL6" "RHEL7" )
for i in ${content_views[@]}; do
	echo content_views[$i] " = "
	sudo hammer content-view version list | grep $i | awk '{print $1}'
done
