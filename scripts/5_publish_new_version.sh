#!/bin/bash
#content views array - add manually
contentviews=("Extras" "RHEL5" "RHEL6" "RHEL7")
#for loop through the content views array
for i in ${contentviews[@]}
        do
                hammer  content-view publish --organization LockheedMartin --name $i
        done


