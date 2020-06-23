#!/bin/bash
#content views array - add manually
contentviews=("Extras" "RHEL5" "RHEL6" "RHEL7")
echo "Enter a content view(s) to be published (separate by a space)" 
#counter
count=0
#for loop through the content views array
for i in ${contentviews[@]}
do
	echo "Enter $count for $i"
	let count++
done
#user input "content views to be published"
IFS=$' '
read cvtbp
echo "You have entered:"
let count=1
echo "${cvtbp[@]}"
#loop through the content views to be published array to print out for user
for j in ${cvtbp[@]}
do
	echo "Content View $count: ${contentviews[$j]}"
	let count++
done

#confirm with the user their entries were correct
echo "Is this correct? enter 1 for yes or 2 for no (quits the script)"
read user_test
if [ $user_test -eq 1 ]
then 
	#loop through user entries and run hammer publish on each content view entered by user.
	for k in ${cvtbp[@]}	
	do
		hammer  content-view publish --organization LockheedMartin --name ${contentviews[$k]}
	done
else
	echo "Quitting"
	# set up the exit code
	exit_code=1
	export exit_code
	exit 1;
fi



#hammer  content-view publish --organization LockheedMartin --name Extras 
#hammer  content-view publish --organization LockheedMartin --name RHEL5 
#hammer  content-view publish --organization LockheedMartin --name RHEL6 
#hammer  content-view publish --organization LockheedMartin --name RHEL7
