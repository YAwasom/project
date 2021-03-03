#!/bin/bash

severity=$1
product="Cloud Custodian"
#echo "Getting Security Report"
#aws securityhub get-findings --region us-west-2 --filters '{"SeverityLabel":[{"Value": "'${severity}'","Comparison":"EQUALS"}],"RecordState":[{"Value": "ACTIVE","Comparison":"EQUALS"}]}' > AWSFindings-$severity.json
#aws securityhub get-findings --filters '{"SeverityLabel":[{"Value": "{$1}","Comparison":"EQUALS"}],"RecordState":[{"Value": "ACTIVE","Comparison":"EQUALS"}]}' > AWSFindings-{$1}.json &
#aws securityhub get-findings --filters '{"SeverityLabel":[{"Value": "MEDIUM","Comparison":"EQUALS"}],"RecordState":[{"Value": "ACTIVE","Comparison":"EQUALS"}]}' > AWSFindings-Medium.json &

echo "Processing Report"
python3 report.py "$severity" "$product"
#python3 report.py AWSFindings-High.json $MailUser $MailPassword
#python3 report.py AWSFindings-Medium.json $MailUser $MailPassword
