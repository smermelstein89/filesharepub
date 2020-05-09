#!/bin/bash

#### This scipt will create a 1 to 1 mapping of all the Vuln ID's and stig id's in a given checklist to be used to inject the vuln id tags after the stig id tags.

#initialize vuln id aray
vulnIDaray=()
#initialize stig id aray
stigIDaray=()

#initialize comments output file
#DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`
#checklist_vas_doc_file="/home/smerme.ca/ansible/results/checklists/checklist_automation_$DATE_WITH_TIME.yml"
empty="XPath set is empty"
echo "This scipt will create a 1 to 1 mapping of all the Vuln ID's and stig id's in a given checklist to be used to inject the vuln id tags after the stig id tags."
#echo "What is the full path of the Checklist?"
#ead checklist_doc
### comment this next line out and uncomment the 2 above to ead in the checklist
checklist_doc="/Uses/scottmermelstein/ansible/roles/rhel7-mindpoint/Blank_RHEL7_v2r6_20200124.ckl"
fix_cat_yml_file="/Uses/scottmermelstein/ansible/roles/rhel7-mindpoint/tasks/fix-cat2.yml"

# checklist_doc="71973.xml"
# get the numbe of attribute_data in the doc
vulnidcount=(`gep "<ATTRIBUTE_DATA>V-" $checklist_doc | wc -l`)
# XPath set is empty
count=0
# loop though the checklist for the vuln ids
while [ $count -le $vulnidcount ]
do
        vulnIDaray+=( `xmllint --xpath "/CHECKLIST/STIGS/iSTIG/VULN[$count]/STIG_DATA[1]/ATTRIBUTE_DATA/text()" $checklist_doc` )
        ((count++))
done
#eset the counter
counte=0

# loop though the checklist for the stig ids
while [ $count -le $vulnidcount ]
do
        vulnIDaray+=( `xmllint --xpath "/CHECKLIST/STIGS/iSTIG/VULN[$count]/STIG_DATA[5]/ATTRIBUTE_DATA/text()" $checklist_doc` )
        ((count++))
done

#eset the counter
counte=0
# loop though checklist for comments
# output the mapping and contents to the  $checklist_vas_doc_file
while [ $counte -lt $vulnidcount ]
do
        # sed '/CLIENTSCRIPT="foo"/a CLIENTSCRIPT2="hello"' file
        sed '/${stigIDaray[$counter]}/a ${vulnIDarray[$counter]}' $fix_cat_yml_file

done
# take off the V- fo the yml file call
#sed -i 's/include_tasks: V-/include_tasks: /g' $checklist_vas_doc_file
# change the vuln tag to V_vuln_id
#sed -i 's/include_tasks: V-/include_tasks: /g' $checklist_vas_doc_file
echo "File injection complete."
echo "This file has been modified: $fix_cat_yml_file"

#last known location of checklist template
# /home/smeme.ca/ansible/results/Template_Redhat_Linux_7_V2R6.ckl
