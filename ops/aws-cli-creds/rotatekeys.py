import boto3
from datetime import tzinfo, timedelta, datetime
import argparse

parser = argparse.ArgumentParser(description="Rotate Aws Keys")
parser.add_argument("--now", action="store_true")
parser.add_argument("--dry", action="store_true")
args, leftovers = parser.parse_known_args()

profiles = boto3.session.Session().available_profiles
now = datetime.now().astimezone()
with open("credentials.txt", "w+") as credfile:
    for profile in profiles:

        print(f"Using profile: {profile}")

        if profile == "default":
            print(f"Skipping default account. Dont want to hit it twice.")
            print()
            continue

        try:
            session = boto3.Session(profile_name=profile)
            awsid = session.resource("iam").CurrentUser().arn.split("user/")[1]
            print(f"Will attempt to rotate keys for : {awsid}")

            creds = session.get_credentials()
            accesskeys = session.client("iam").list_access_keys(UserName=awsid)
        except Exception as e:
            print(f"Unable to fetch current user: {e}")
            print(
                f"Possibly an auxiliary role in aws config not tied to your user: {e}"
            )
            print()
            continue

        if args.dry:
            print(
                f"Dry run, checking basic access for key rotation without new key generation"
            )
            print()
            continue

        if len(accesskeys["AccessKeyMetadata"]) < 2:
            for key in accesskeys["AccessKeyMetadata"]:
                if (
                    accesskeys["AccessKeyMetadata"][0]["AccessKeyId"]
                    == creds.access_key
                ):
                    accesskeydate = accesskeys["AccessKeyMetadata"][0]["CreateDate"]
                    daysold = now - accesskeydate
                    credfile.write(f"[{profile}]\n")
                    if daysold.days > 90 or args.now:
                        newkey = session.client("iam").create_access_key(UserName=awsid)

                        AccessUser = newkey["AccessKey"].get("AccessKeyId")
                        AccessPass = newkey["AccessKey"].get("SecretAccessKey")
                        print(f"New Key Generated for {profile}")
                        credfile.write(f"aws_access_key_id = {AccessUser}\n")
                        credfile.write(f"aws_secret_access_key = {AccessPass}\n")

                        session.client("iam").delete_access_key(
                            UserName=awsid, AccessKeyId=creds.access_key
                        )
                    else:
                        AccessUser = creds.access_key
                        AccessPass = creds.secret_key

                        credfile.write(f"aws_access_key_id = {AccessUser}\n")
                        credfile.write(f"aws_secret_access_key = {AccessPass}\n")
        else:
            print(
                f"You have too many keys in {profile}, please delete one to rotate keys"
            )
