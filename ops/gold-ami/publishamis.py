import os
import sys
import json
import boto3

filename = sys.argv[1]
ssm_dest = sys.argv[2]
cwd = os.getcwd()

jsonfile = os.path.join(cwd, filename)

try:
    with open(jsonfile, "r") as f:

        manifest = json.load(f)

    amis = manifest["builds"][0]["artifact_id"]

    amilist = amis.split(",")

    print(amilist)
except Exception as e:
    print("Could not get values from input file")
    print(jsonfile)
    print(manifest)

for item in amilist:
    # regions to distribute defined in packer.json => `ami_regions`
    region, ami = item.split(":")
    try:
        ssm = boto3.client("ssm", region_name=region)
        response = ssm.put_parameter(
            Name=ssm_dest, Value=ami, Overwrite=True, Type="String"
        )
    except Exception as e:
        print("Error putting SSM Parameter")
        print(e)
        print(amilist)
