#!/bin/bash

#### This bash script loops through a checklist to map the vuln id's. Then it loops through the checklist again to output the vuln id in the appropriate tasks/main.yml format.

#initialize vuln id array
vulnIDarray=()

#initialize comments output file
DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`
#checklist_vars_doc_file="/home/smerme.ca/ansible/results/tasks/_$DATE_WITH_TIME.txt"
checklist_vars_doc_file="/home/smerme.ca/ansible/results/tasks"
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
        #xml success
		echo " # set the xml"   > $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
		echo " # if the system is configured"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
		echo "- name: Set the checklist sections if success {{ ${vulnIDarray[$counter]}_vuln_id_mapping }}"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
		  echo "  xml:"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
          #xml modules
            echo "    path: {{ rhel7_checklist_full_path }}"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
            echo "    xpath: /CHECKLIST/STIGS/iSTIG/VULN[{{ ${vulnIDarray[$counter]}_vuln_id_mapping }}]/{{ item.xpath }}"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
            echo "    value: \"{{ item.value }}\""   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
		  #LOOP
		    echo "  with_items:"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
		    echo "    - { xpath: 'STATUS', value: '{{ ${vulnIDarray[$counter]}_configured.status  }}'}"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
		    echo "    - { xpath: 'FINDING_DETAILS', value: '{{ ${vulnIDarray[$counter]}_configured.finding_details  }}'}"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
		    echo "    - { xpath: 'COMMENTS', value: '{{ ${vulnIDarray[$counter]}_configured.comments  }}'}"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
		    echo "  when: stig_result_${vulnIDarray[$counter]}.failed == false"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
        #xml FAIL
		echo " # if the system is UNconfigured"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
          echo "- name: Set the checklist sections if Failure {{ ${vulnIDarray[$counter]}_vuln_id_mapping }}"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
		  echo "  xml:"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
          #xml modules
            echo "    path: {{ rhel7_checklist_full_path }}"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
            echo "    xpath: /CHECKLIST/STIGS/iSTIG/VULN[{{ ${vulnIDarray[$counter]}_vuln_id_mapping }}]/{{ item.xpath }}"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
            echo "    value: \"{{ item.value }}\""   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
		  #LOOP
		    echo "  with_items:"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
		    echo "    - { xpath: 'STATUS', value: '{{ ${vulnIDarray[$counter]}_unconfigured.status  }}'}"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
		    echo "    - { xpath: 'FINDING_DETAILS', value: '{{ ${vulnIDarray[$counter]}_unconfigured.finding_details  }}'}"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
		    echo "    - { xpath: 'COMMENTS', value: '{{ ${vulnIDarray[$counter]}_unconfigured.comments  }}'}"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
		    echo "  when: stig_result_${vulnIDarray[$counter]}.failed == false"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
		  #Check the XML
			echo " # check the xml"    >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
			echo "   # check the status"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
			echo "     # xmllint --xpath \"/CHECKLIST/STIGS/iSTIG/VULN[$counter]/STATUS/text()\" /home/u_smerme.ca/ansible/results/Ansible_RHEL7_v2r6_20200124.ckl"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
			echo "   # check the FINDING_DETAILS"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
			echo "     # xmllint --xpath \"/CHECKLIST/STIGS/iSTIG/VULN[$counter]/FINDING_DETAILS/text()\" /home/u_smerme.ca/ansible/results/Ansible_RHEL7_v2r6_20200124.ckl"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
			echo "   # check the COMMENTS"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
			echo "     # xmllint --xpath \"/CHECKLIST/STIGS/iSTIG/VULN[$counter]/COMMENTS/text()\" /home/u_smerme.ca/ansible/results/Ansible_RHEL7_v2r6_20200124.ckl"   >> $checklist_vars_doc_file/${vulnIDarray[$counter]}.yml
			((counter++))


done

echo "Array creation complete"
echo "Results can be found in the file named: $checklist_vars_doc_file"

#last known location of checklist template
# /home/smerme.ca/ansible/results/Template_Redhat_Linux_7_V2R6.ckl