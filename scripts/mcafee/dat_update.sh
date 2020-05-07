#!/bin/bash
echo "Is the datalocker mounted? 1 for yes. 2 for no."
read if [[ $mount_bool -ne 1]]
then
	exit 1;
fi
echo "Where is the datalocker mounted and the avvepo dat zip located? (do not include the trailing slash)" 
read mount_point
echo "What is the new dat version?"
read new_dat_version

#Extract the avvdat-<DAT version>.zip file from the avvepoXXXXdat.zip archive file to the temporary folder /tmp/dat/avvdat-<DAT version>.zip
unzip /tmp/dat $mount_point/avvdat-$new_dat_version.zip

#Create a directory with the name of the DAT version to which you want to update, and change the permission to the correct one. For example, if the DAT version you downloaded is 8372:
mkdir /opt/isec/ens/threatprevention/var/engine/dat/$new_dat_version
chmod 600 /opt/isec/ens/threatprevention/var/engine/dat/$new_dat_version

#Copy DAT files under the directory created in step 5, and change the permission to the correct one. For example:
cp /tmp/dat/*.dat /opt/isec/ens/threatprevention/var/engine/dat/$new_dat_version
chmod 600 /opt/isec/ens/threatprevention/var/engine/dat/$new_dat_version/*

#Edit the /opt/isec/ens/threatprevention/var/prefs.xml file and change the value of the <MajorDATVersion> tag to the DAT version to which you want to update. For example, if the DAT version you downloaded is 8372:
#<MajorDATVersion>8372</MajorDATVersion>
grep MajorDATVersion /opt/isec/ens/threatprevention/var/prefs.xml
echo "What is the old DAT version?"
read old_dat_version
sed -i 's/<MajorDATVersion>$old_dat_version</MajorDATVersion>/<MajorDATVersion>$new_dat_version</MajorDATVersion>/g'

#Restart the isectpd service to reflect the change:
/opt/isec/ens/threatprevention/bin/isectpdControl.sh restart

#Confirm the DAT version is reflected as expected and that the following command shows the correct version for the DAT Version item:
/opt/isec/ens/threatprevention/bin/isecav --version

echo "If $new_dat_version is listed above, then the DAT version is successfully updated."
