#!/bin/bash

#run a "hammer content-view version list" dump
echo "# hammer content-view version list dump: " 
echo "(wait for the List command to complete)"

hammer content-view version list

contentviews=("Extras" "RHEL5" "RHEL6" "RHEL7")


echo "List command is now complete."
echo "Enter a content view(s) ID# to be cleaned up (separate by a space)" 

# user input "content views to be deleted"
IFS=$' '
read cvtbd
echo "You have entered:"
count=0
# loop through the content views to be deleted array to print out for user
for j in ${cvtbd[@]}
do
	# echo "Content View $count: ${cvtbd[$j]}"
	echo "id # $j"
	let count++
done

# confirm with the user their entries were correct
echo "Is this correct? enter 1 for yes or 2 for no (quits the script)"
read user_test
if [ $user_test -eq 1 ]
then 
	# loop through user entries and run hammer export on each content view entered by user.
	for k in ${cvtbd[@]}	
	do
		echo "hammer content-view version delete --id $k"
		hammer content-view version delete --id $k && echo "ID # $k is complete"
	done
else
	echo "Quitting"
	exit 1;
fi


