#!/bin/bash
output_location=/var/lib/pulp #/mnt

#content views array - add manually
contentviews=("Extras" "RHEL5" "RHEL6" "RHEL7")
#initialize the content_view_id_array
content_view_id_array=()
count=0
#loop through the content-view version list to add the values to the content_view_id_array
for k in ${contentviews[@]}
do 
	content_view_id_array[$count]=`hammer --csv --csv-separator ";" content-view version list | grep $k | head -n 1 | cut -d ";" -f 1`
	let count=count+1
done



#loop through user entries and run hammer export on each content view entered by user.
for k in ${content_view_id_array[@]}
	do
	hammer content-view version export --export-dir $output_location --id $k
done

