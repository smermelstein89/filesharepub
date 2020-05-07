#!/bin/bash

#### This bash script loops through a checklist to map the vuln id's. Then it loops through the checklist again to output the vuln id in the appropriate tasks/main.yml format.

#initialize vuln id array
vulnIDarray=()

#initialize comments output file
DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`
checklist_vars_doc_file="/home/smerme.ca/ansible/results/checklist_vars_doc_$DATE_WITH_TIME.txt"
empty="XPath set is empty"
echo "This bash script loops through a checklist to map the vuln id's. Then it loops through the checklist again to output the vuln id in the appropriate tasks/main.yml format."
#echo "What is the full path of the Checklist?"
#read checklist_doc
### comment this next line out and uncomment the 2 above to read in the checklist
checklist_doc="/home/smerme.ca/ansible/results/Template_Redhat_Linux_7_V2R6.ckl"
# checklist_doc="71973.xml"
# get the number of attribute_data in the doc
vulnidcount=(`grep "<ATTRIBUTE_DATA>V-" $checklist_doc | wc -l`)
# XPath set is empty
count=0
# loop through the checklist for the vuln ids
while [ $count -le $vulnidcount ]
do
        vulnIDarray+=( `xmllint --xpath "/CHECKLIST/STIGS/iSTIG/VULN[$count]/STIG_DATA[1]/ATTRIBUTE_DATA/text()" $checklist_doc` )
        ((count++))
done
#reset the counter
counter=0
# loop through checklist for comments
# output the mapping and contents to the  $checklist_vars_doc_file
while [ $counter -lt $vulnidcount ]
do
        # output 
        #name line
          echo "- name: Include task ${vulnIDarray[$counter]}"   >> $checklist_vars_doc_file
        #import tasks line
          echo "  import_tasks: roles/test-roles-1/tasks/${vulnIDarray[$counter]}.yml"   >> $checklist_vars_doc_file
        ((counter++))

done

echo "Array creation complete"
echo "Results can be found in the file named: $checklist_vars_doc_file"

#last known location of checklist template
# /home/smerme.ca/ansible/results/Template_Redhat_Linux_7_V2R6.ckl