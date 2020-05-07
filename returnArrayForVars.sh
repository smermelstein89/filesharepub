#!/bin/bash

#### This bash script loops through a checklist to map the vuln id's. Then it loops through the checklist again to output the vuln id with the associated Comments to a text file.

#initialize vuln id array
vulnIDarray=()

#initialize comments output file
DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`
checklist_vars_doc_file="/home/smerme.ca/ansible/results/checklist_vars_doc_$DATE_WITH_TIME.txt"
empty="XPath set is empty"
echo "This script will create a 1 to 1 mapping of all the Vuln ID's in a given checklist to be used in conjunction with an ansible playbook to automatically input FINDING_DETAILS and COMMENTS."
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
        # output all the comments to a file
                #print Vuln ID part.
                # echo "  ${vulnIDarray[$counter]}_vuln_id_mapping: $counter"   >> $checklist_vars_doc_file
                #print Vuln ID Mapping part
                  echo "  ${vulnIDarray[$counter]}_vuln_id_mapping: $counter"   >> $checklist_vars_doc_file
                #print Vuln ID Configured part
                  echo "  ${vulnIDarray[$counter]}_configured:"   >> $checklist_vars_doc_file
                  #print Status part
                    printf "    status: \""   >> $checklist_vars_doc_file
                    xmllint --xpath "/CHECKLIST/STIGS/iSTIG/VULN[$counter+1]/STATUS/text()" $checklist_doc >> $checklist_vars_doc_file
                    echo "\"" >> $checklist_vars_doc_file
                  #print finding details part
                    printf "    finding_details: \""  >> $checklist_vars_doc_file
                    xmllint --xpath "/CHECKLIST/STIGS/iSTIG/VULN[$counter+1]/FINDING_DETAILS/text()" $checklist_doc >> $checklist_vars_doc_file
                    echo "\"" >> $checklist_vars_doc_file
                  #print comments part
                    printf "    comments: \""  >> $checklist_vars_doc_file
                    xmllint --xpath "/CHECKLIST/STIGS/iSTIG/VULN[$counter+1]/COMMENTS/text()" $checklist_doc >> $checklist_vars_doc_file
                    echo "\"" >> $checklist_vars_doc_file
                #print Vuln ID Configured part
                  echo "  ${vulnIDarray[$counter]}_unconfigured:"   >> $checklist_vars_doc_file
				  #print status part
				    printf "    status: \"\"\n"    >> $checklist_vars_doc_file
					printf "    finding_details: \"\"\n"   >> $checklist_vars_doc_file
					printf "    comments: \"\"\n"   >> $checklist_vars_doc_file
                ((counter++))

done

echo "Array creation complete"
echo "Results can be found in the file named: $checklist_vars_doc_file"

#last known location of checklist template
# /home/smerme.ca/ansible/results/Template_Redhat_Linux_7_V2R6.ckl
