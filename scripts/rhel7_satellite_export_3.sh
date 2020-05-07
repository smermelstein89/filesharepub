#!/bin/bash

echo "Is the external drive mounted? Enter 1 for yes, 2 for no."
read drive_mounted
if [[ drive_mounted -ne 1 ]]
        then exit 1;
fi
echo "Where do you want to output rhel-7-server-satellite-6.2-rpms to? (without trailing slash)"
read output_location

echo "Script will run: reposync --repoid=rhel-7-server-satellite-6.2-rpms --download_path=$output_location/ --downloadcomps --download-metadata"
#confirm with the user their entries were correct
echo "Is this correct? enter 1 for yes or 2 for no (quits the script)"
read user_test
if [ $user_test -ne 1 ]
then 
	echo "Quitting"
	exit 1;
fi
	echo "Script is running..."
	reposync --repoid=rhel-7-server-satellite-6.2-rpms --download_path=$output_location/ --downloadcomps --download-metadata
	echo "Reposync complete." 
	echo "Script will now run: "
	echo "createrepo --update -v $output_location/rhel-7-server-satellite-6.2-rpms/"
	echo "Is this correct? enter 1 for yes or 2 for no (quits the script)"
read user_test2
if [ $user_test2 -ne 1 ]
then
        echo "Quitting"
        exit 2;
fi
	echo "Script is running..."
	createrepo --update -v $output_location/rhel-7-server-satellite-6.2-rpms/
	echo "Script is complete."
