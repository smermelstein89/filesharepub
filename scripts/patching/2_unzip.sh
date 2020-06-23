#!/bin/bash

echo "Is the latest RHEL7 tar file /patches in the /media directory? 1 for yes, 2 for no"
read proceed_bool
if [[ proceed_bool -ne 1 ]]
        then exit 1;
fi
mount_point=/patches

#initialize the index array and the content views array
index_id=()
content_view_array=( Extras RHEL7 )
count=0



#loop through the content view array to have the user assign the index to the appropriate content view
for c in ${content_view_array[@]}
do
        echo "what is the index ID for the $c content view?"
        read content_view_id
        let count=count+1
        index_id+=("$content_view_id")
done

#loop through the idex id array to confirm the indexs are set correctly.
let count=0
for d in ${index_id[@]}
do
        echo "${content_view_array[$count]} = $d"
        let count=count+1
done

echo "Is this mapping correct? 1 for yes, 2 for no"
read proceed_bool
if [[ proceed_bool -ne 1 ]]
        then exit 1;
fi

let count=0
for e in ${content_view_array[@]}
do
        #extract the files in the desired repos export to the mounted drive
          echo "tar -C $mount_point -xf $mount_point/export-$e-${index_id[$count]}.tar"
        #extract the files in the extracted directory to the katello-export directory
          echo "tar -C $mount_point -xf $mount_point/export-$e-${index_id[$count]}/export-$e-${index_id[$count]}-repos.tar"
        let count=count+1
done

echo "Do you want to proceed with these commands? 1 for yes, 2 for no"
read proceed_bool
if [[ proceed_bool -ne 1 ]]
        then exit 1;
fi

let count=0
for e in ${content_view_array[@]}
do
        #extract the files in the desired repos export to the mounted drive
          echo "tar -C $mount_point -xf $mount_point/export-$e-${index_id[$count]}.tar"
          tar -C $mount_point -xf $mount_point/export-$e-${index_id[$count]}.tar
        #extract the files in the extracted directory to the katello-export directory
          echo "tar -C $mount_point -xf $mount_point/export-$e-${index_id[$count]}/export-$e-${index_id[$count]}-repos.tar"
          tar -C $mount_point -xf $mount_point/export-$e-${index_id[$count]}/export-$e-${index_id[$count]}-repos.tar
        let count=count+1
done

