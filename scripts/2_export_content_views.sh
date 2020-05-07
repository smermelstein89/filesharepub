#!/bin/bash
echo "Is the external drive mounted? Enter 1 for yes, 2 for no."
read drive_mounted
if [[ drive_mounted -ne 1 ]]
        then exit 1;
fi
echo "Where do you want to output the content views to?"
read output_location

#content views array - add manually
contentviews=("Extras" "RHEL5" "RHEL6" "RHEL7")
count=0
#run a "hammer content-view version list" dump
echo "# hammer content-view version list dump: " 
echo "(wait for the List command to complete)"
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

count=0
for p in ${contentviews[@]}
do 
	echo "$p = ${content_view_id_array[$count]}"
	let count=count+1
done
echo "List command is now complete."
echo "Enter a content view(s) ID# to be exported (separate by a space)" 

#for loop through the content views array -- troubleshooting
#for i in ${contentviews[@]}
#do
#	echo "Enter $count for $i"
#	let count++
#done

#user input "content views to be exported"
IFS=$' '
read cvtbe
echo "You have entered:"
#echo "${cvtbp[@]}"

#loop through the content views to be published array to print out for user
for j in ${cvtbe[@]}
do
	#echo "Content View $count: ${cvtbe[$j]}"
	echo "id # $j"
	let count++
done

#confirm with the user their entries were correct
echo "Is this correct? enter 1 for yes or 2 for no (quits the script)"
read user_test
if [ $user_test -eq 1 ]
then 
	#loop through user entries and run hammer export on each content view entered by user.
	for k in ${cvtbe[@]}	
	do
		echo "hammer content-view version export --export-dir $output_location --id $k" 
		hammer content-view version export --export-dir $output_location --id $k && echo "ID # $k is complete." && echo "--------------------------------------" 
	done
else
	echo "Quitting"
	exit 1;
fi



#hammer  content-view publish --organization LockheedMartin --name Extras 
#hammer  content-view publish --organization LockheedMartin --name RHEL5 
#hammer  content-view publish --organization LockheedMartin --name RHEL6 
#hammer  content-view publish --organization LockheedMartin --name RHEL7

