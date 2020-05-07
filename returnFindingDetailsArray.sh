#!/bin/bash

#### This bash script loops through a checklist to map the vuln id's. Then it loops through the checklist again to output the vuln id with the associated finding_details to a text file.

#initialize vuln id array
vulnIDarray=()

#initialize finding_details output file
DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`
checklist_finding_details_doc_file="/home/smerme.ca/ansible/results/checklist_finding_details_doc_$DATE_WITH_TIME.txt"
empty="XPath set is empty"
echo "This bash script loops through a checklist to map the vuln id's. Then it loops through the checklist again to output the vuln id with the associated finding_details to a text file."
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
# loop through checklist for FINDING_DETAILS
# output the mapping and contents to the  $checklist_finding_details_doc_file
while [ $counter -lt $vulnidcount ]
do
        # output all the finding_details to a file
		#echo "counter = " $counter >> $checklist_finding_details_doc_file
		printf "finding_details_of_${vulnIDarray[$counter]}: \n vuln_finding_details:\""  >> $checklist_finding_details_doc_file
		#echo "counter + 1 = " `expr $counter + 1` >> $checklist_finding_details_doc_file
		xmllint --xpath "/CHECKLIST/STIGS/iSTIG/VULN[$counter+1]/FINDING_DETAILS/text()" $checklist_doc >> $checklist_finding_details_doc_file
		echo "\"" >> $checklist_finding_details_doc_file
		((counter++))

done
	
echo "Array creation complete"

#last known location of checklist template
# /home/smerme.ca/ansible/results/Template_Redhat_Linux_7_V2R6.ckl