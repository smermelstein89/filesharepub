!#/bin/bash
#  create the local repo
reposync --repoid=rhel-7-server-satellite-6.2-rpms --download_path=/mnt/ --downloadcomps --download-metadata
#  
createrepo --update -v  [path/to/mounted/drive/rhel-7-server-satellite-6.5-source-rpms]