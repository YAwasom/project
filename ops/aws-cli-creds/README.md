# Credential Update and Rotation

These scripts update aws cli credentials to the correct format following the email address and rotate keys older than 90 days.

# Usage rotatekeys.py

python3 ./rotatekeys.py

# Parameters
--now - updates keys regardless of age
--dry - checking basic access for key rotation without new key generation

Will check and generate a new credentials files named newcredentials.txt.  Once complete you need to copy this file in place of your ~/.aws/credentials file.

# Usage updateusers.py
python3 ./updateusers.py --userid mymyself.i@wb.com

# Parameters
--userid - the userID you wish to change to.

Checks the format of your user accounts matches the ID you input as --userid, if it does not match then it generates a new userID and places the credentials in credentials.txt.  Copy this file in place of your ~/.aws/credentials file.

Script preserves existing credentials if they do not meet the conditions to change/update and places them in the new credentials file.

# Usage deleteoldusers.py
python3 ./deleteoldusers.py --userid mymyself.i@wb.com --max-days 90

python3 ./deleteoldusers.py --max-days 90

# Parameters
--user-id - the userID you wish to change to

--max-days - delete users that haven't used there keys in x days

--max-age - delete users that have key past a certain age

--no-filter - skip default filter by @ for user email addresses

--delete - issue the actual delete