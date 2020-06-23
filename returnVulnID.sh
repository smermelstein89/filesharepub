#!/bin/bash
count=1
vulnIDarray=()
empty="XPath set is empty"
checklist_doc="71973.xml"
# get the number of attribute_data in the doc
vulnidcount=(`grep "<ATTRIBUTE_DATA>V-" $checklist_doc | wc -l`)
# XPath set is empty

# loop through the doc 
while [ $count -le $vulnidcount ]
do

    vulnIDarray+=( `xmllint --xpath "/CHECKLIST/STIGS/iSTIG/VULN[$count]/STIG_DATA[1]/ATTRIBUTE_DATA/text()" $checklist_doc` )
	((count++))
	
done
echo "Array creation complete"
# loop through the vuln id array and print out all the vuln ids
let count=1
for i in ${vulnIDarray[@]}
do
   echo "$count = $i"
   ((count++))
done

# given a vuln id, return the VULN array id #.