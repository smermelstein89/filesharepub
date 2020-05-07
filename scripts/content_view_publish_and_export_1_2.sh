#!/bin/bash

#content_views=( "Extras" "RHEL5" "RHEL6" "RHEL7" )
#content_number=()
#count=0
#i=RHEL5
#for i  in ${content_views[@]}; do
#	echo $i " = " RHEL5
#	content_number[$count]
#	hammerlist="$( hammer content-view version list )"
#	echo "hammerlist = " $hammerlist
#	$hammerlist_grep=( $hammerlist | grep $1)
#	echo "hammerlist_grep = " $hammerlist_grep
#	hammerlist_grep_awk="$( awk '{print $1}' $hammerlist_grep )"
#	echo "hammerlist_grep_awk = " $hammerlist_grep_awk
#)
#    $count = $count + 1
#done
#echo ${content_number[@]}
scripts_dir="/home/smerme.ca/scripts"

#run the publish new version script
$scripts_dir/publish_new_version_1.sh

#store the exit code in the ext_code variable
exit_code=$?;
#echo "exit code is set to questions mark"
#echo "question mark sign equals $?"
#exit_code=$?
#echo "exit code = $exit_code"
#echo "question mark sign equals $?"
#echo $?
if [[ $exit_code -eq 1 ]];
	then 
#	echo "exit code = $exit_code"
	exit $exit_code;
fi
#run the second script
$scripts_dir/export_content_views_2.sh
