#!/bin/bash

# xxx@warnerbros.com,xx@wbconsultant.com,xxx@warnermedia.com
# requires awsp or export of $AWS_ACCOUNT_ID
user_emails="$1"
group=${2:-default_read_only_user}

for i in $(echo "$user_emails" | sed "s/,/ /g")
do
  echo "Creating user ${i}"
  aws iam create-user --user-name "${i}"

  echo "Adding ${i} to $group group"
  aws iam add-user-to-group --user-name "${i}" --group-name $group 

  echo "Creating access key: cred-${i}-$AWS_ACCOUNT_ID.json"
  aws iam create-access-key --user-name "${i}" > cred-"${i}"-"$AWS_ACCOUNT_ID".json
done