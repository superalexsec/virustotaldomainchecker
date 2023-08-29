#!/bin/bash
# Requirements
# VirusTotal Command Line Interface (vt-cli)
# https://github.com/VirusTotal/vt-cli

# Special chars manipulation:
OIFS="$IFS"
IFS=$'\n'

# Target path
target_path='/home/superalexsec/malicious'
# Domains list
domains_list='domainslist.txt'
# log file
log_out='log_output.log'
# Insert Malicious OR Suspicious
threat_type='malicious'
# Create the log out file
touch $log_out

# Looping starts
for url in $(cat $target_path/$domains_list); do
    # Print the status
    echo "Scanning <$url>"
    # Create the log file, extracting only the AVs number of detection
    checking=$(vt url --include=last_analysis_stats.$threat_type $url | grep $threat_type | awk '{ print $2 }' | xargs -n 1)
    # Print the file malicious status
    echo "Returned as $threat_type: <$checking>"
    # Creating the log file
    if [[ $checking -ne 0 ]]; then
        echo "$threat_type $url"
        echo $url >> $target_path/$log_out
    # Evidences not found
    else
        echo "No return for $url"
    fi
    # VT has a 4 request per seccond limitation for free accounts, this is way my script sleeps 15 sec
    sleep 15
done

IFS="$OIFS"
