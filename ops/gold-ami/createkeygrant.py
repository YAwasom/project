import boto3
import sys
import argparse

parser = argparse.ArgumentParser(description="My Script")
parser.add_argument("--profile")
parser.add_argument("--allprofiles", action="store_true")
args, leftovers = parser.parse_known_args()
keys = [
    "us-west-2$arn:aws:kms:us-west-2:348180535083:key/a370c4f2-5a11-4a3e-a5fa-3a5bc7ce659c",
    "us-east-2$arn:aws:kms:us-east-2:348180535083:key/5c2d4c62-258e-4f13-9d0b-288b686f1388",
]


if args.profile:
    profiles = [args.profile]
if args.allprofiles:
    profiles = boto3.session.Session().available_profiles


def checkkey(keyid, accountid, session, region):
    try:
        grants = session.client("kms", region_name=region).list_grants(KeyId=keyid)
        exists = False
        for grant in grants["Grants"]:
            print("checking: " + grant["KeyId"])
            if (
                grant["GranteePrincipal"]
                == "arn:aws:iam::"
                + accountid
                + ":role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
            ):
                exists = True
                print("Grant Exists for " + grant["GranteePrincipal"])

        if exists:
            return False
        else:
            return True

    except Exception as e:
        if "Invalid arn" in str(e):
            return True
        else:
            print("failed to check key")
            print(e)


def setkey(keyid, accountid, name, session, region):
    GP = (
        "arn:aws:iam::"
        + accountid
        + ":role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
    )
    print(GP)
    session.client("kms", region_name=region).create_grant(
        Name=name,
        KeyId=keyid,
        GranteePrincipal=GP,
        Operations=[
            "CreateGrant",
            "Decrypt",
            "DescribeKey",
            "Encrypt",
            "GenerateDataKey",
            "GenerateDataKeyWithoutPlaintext",
            "ReEncryptFrom",
            "ReEncryptTo",
            "RetireGrant",
        ],
    )
    print("Created grant for key" + keyid)


for profile in profiles:
    print("Checking Grants for: " + profile)
    try:
        session = boto3.Session(profile_name=profile)
        accountid = session.client("sts").get_caller_identity().get("Account")
        print(accountid)
        try:
            for key in keys:
                region, keyid = key.split("$")

                if checkkey(keyid, accountid, session, region):
                    print("Creating Grant for: " + keyid)
                    setkey(
                        keyid,
                        accountid,
                        "ops-" + region + "-" + profile + "-kms-asg-grant",
                        session,
                        region,
                    )
                else:
                    print("grant exists for key" + keyid)
        except Exception as e:
            print("could not create grant for " + keyid)
            print(e)

    except Exception as e:
        print(profile)
        print(e)
        print("Invalid ARN indicates the grant may already exist")
