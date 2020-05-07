#!/bin/bash

#### This bash script loops through a checklist to map the vuln id's. Then it loops through the checklist again to output the [severity] | [STIG ID] | title, vuln id in proper format to a text file.

#initialize vuln id array
vulnIDarray=()

#initialize comments output file
DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`
checklist_vars_doc_file="/home/smerme.ca/ansible/results/checklists/checklist_automation_$DATE_WITH_TIME.yml"
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
				#print a new line to begin with
                echo "# ${vulnIDarray[$counter]}_vuln_id_mapping: $counter"   >> $checklist_vars_doc_file
                #print ->	- name: "[severity] | [STIG ID] | title"
                  printf -- "- name: \" "   >> $checklist_vars_doc_file
				  #severity
                    xmllint --xpath "/CHECKLIST/STIGS/iSTIG/VULN[$counter+1]/STIG_DATA[2]/ATTRIBUTE_DATA/text()" $checklist_doc >> $checklist_vars_doc_file
				  printf " | "   >> $checklist_vars_doc_file
				  # STIG ID
                    xmllint --xpath "/CHECKLIST/STIGS/iSTIG/VULN[$counter+1]/STIG_DATA[5]/ATTRIBUTE_DATA/text()" $checklist_doc >> $checklist_vars_doc_file
				  printf " | "   >> $checklist_vars_doc_file
				  # title
                    xmllint --xpath "/CHECKLIST/STIGS/iSTIG/VULN[$counter+1]/STIG_DATA[6]/ATTRIBUTE_DATA/text()" $checklist_doc >> $checklist_vars_doc_file
                  printf "\" \n"   >> $checklist_vars_doc_file
				  #echo "${vulnIDarray[$counter]}_vuln_id_mapping: $counter"   >> $checklist_vars_doc_file
				# 	include_tasks: [Vul ID].yml (take off the V-)
                  echo "  include_tasks: ${vulnIDarray[$counter]}.yml"   >> $checklist_vars_doc_file
                #  when: stig_result_V_71967 is defined
  				  echo "  when: stig_result_${vulnIDarray[$counter]} is defined"    >> $checklist_vars_doc_file
				# tags
				  echo "  tags: "   >> $checklist_vars_doc_file
				  printf "    - "   >> $checklist_vars_doc_file
				  # STIG ID
                    xmllint --xpath "/CHECKLIST/STIGS/iSTIG/VULN[$counter+1]/STIG_DATA[5]/ATTRIBUTE_DATA/text()" $checklist_doc >> $checklist_vars_doc_file
				  printf "\n    - "   >> $checklist_vars_doc_file
				  # vuln id
                    xmllint --xpath "/CHECKLIST/STIGS/iSTIG/VULN[$counter+1]/STIG_DATA[1]/ATTRIBUTE_DATA/text()" $checklist_doc >> $checklist_vars_doc_file
				  printf "\n"   >> $checklist_vars_doc_file
                ((counter++))

done
# take off the V- for the yml file call
#sed -i 's/include_tasks: V-/include_tasks: /g' $checklist_vars_doc_file
# change the vuln tag to V_vuln_id
#sed -i 's/include_tasks: V-/include_tasks: /g' $checklist_vars_doc_file
echo "Array creation complete"
echo "Results can be found in the file named: $checklist_vars_doc_file"

#last known location of checklist template
# /home/smerme.ca/ansible/results/Template_Redhat_Linux_7_V2R6.ckl
