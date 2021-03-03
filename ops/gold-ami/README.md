## Packer Scripts to build GOLD AMIs
- Scripts build standard images using packer.  
- Built images can be sent to multiple regions and shared with any number of accounts.  
- All images use a KMS key which must be specified as part of the build.

## KMS Grants
createkeygrant.py

This script creates necessary grants it has two paramters:

--profile: allows you to specify an AWS account to run against. (eg.  --profile=ask)

--allprofiles: runs against all profiles on the executing machine

The KMS grants are required for autoscaling rules

## AMI IDs in SSM
publishamis.py

This script is used by jenkins to publish AMI ids to the SSM varaibles in each specified region based on output from the packer manifest file.