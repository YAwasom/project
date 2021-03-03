import boto3
import time
from datetime import tzinfo, timedelta, datetime, date
import argparse

parser = argparse.ArgumentParser(
    description="Deletes users by age or userid. Supports multi account."
)
parser.add_argument("--delete", action="store_true")
parser.add_argument("--no_filter", action="store_true")
parser.add_argument("--max_days", default=180, type=int)
parser.add_argument("--max_age", default=180, type=int)
parser.add_argument("--user_id")
args, leftovers = parser.parse_known_args()


def check_user_key_dates_and_delete(user, args):
    last_login = 0
    key_delta = None
    access_key_age = 0

    accesskeys = client.list_access_keys(UserName=user["User"]["UserName"])

    if len(accesskeys["AccessKeyMetadata"]) > 0:
        access_key_date_created = accesskeys["AccessKeyMetadata"][0][
            "CreateDate"
        ].date()

        current_date = date.today()

        access_key_age = (current_date - access_key_date_created).days
        print("User: " + user["User"]["UserName"])
        print(f"Access Key age {access_key_age}")

        for key in accesskeys["AccessKeyMetadata"]:
            key_last_used = client.get_access_key_last_used(
                AccessKeyId=key["AccessKeyId"]
            )

            if "LastUsedDate" in key_last_used["AccessKeyLastUsed"]:

                key_last_used = key_last_used["AccessKeyLastUsed"]["LastUsedDate"]
                tmp_key_delta = (now - key_last_used).days

                if key_delta is None or tmp_key_delta < key_delta:
                    key_delta = tmp_key_delta
            else:
                key_delta = 0
    else:
        key_delta = 0

    if "PasswordLastUsed" in user["User"]:
        last_login = (now - user["User"]["PasswordLastUsed"]).days
        print(f"User last login was {last_login} days ago")
    else:
        print(f"User has never signed in via the console")

    if (last_login >= args.max_days and key_delta >= args.max_days) or (
        args.max_age <= access_key_age
    ):
        print(f"Last Console Access: {last_login} days")
        print(f"Last Key Access: {key_delta} days")
        if args.delete:
            delete_existing_user(user["User"]["UserName"], session, client)
            print(f'Deleted: {user["User"]["UserName"]}')

    print("")


def delete_existing_user(user_id, session, client):
    print(f"Removing user {user_id} from all groups")

    groups = client.list_groups_for_user(UserName=user_id)["Groups"]

    for group in groups:
        client.remove_user_from_group(
            GroupName=group.get("GroupName"), UserName=user_id
        )

    try:
        mfa = client.list_mfa_devices(
            UserName=user_id,
        )
        for m in mfa["MFADevices"]:
            client.deactivate_mfa_device(
                UserName=user_id, SerialNumber=m["SerialNumber"]
            )
            client.delete_virtual_mfa_device(SerialNumber=m["SerialNumber"])
    except Exception as e:
        print(e)

    try:
        client.delete_login_profile(UserName=user_id)
    except Exception as e:
        print(e)

    access_key_info = session.client("iam").list_access_keys(UserName=user_id)

    print(f"Deleting user access keys {user_id}")

    for key_metadata in access_key_info["AccessKeyMetadata"]:
        client.delete_access_key(
            UserName=user_id, AccessKeyId=key_metadata["AccessKeyId"]
        )

    print(f"Deleting user {user_id}")
    time.sleep(2)
    client.delete_user(UserName=user_id)


profiles = boto3.session.Session().available_profiles
now = datetime.now().astimezone()

for profile in profiles:
    session = boto3.Session(profile_name=profile)
    client = session.client("iam")
    resource = session.resource("iam")

    if profile == "default":
        print(f"Skipping default account. Dont want to hit it twice.")
        continue

    print(f"Account: {profile}")

    if args.user_id:
        try:
            user = client.get_user(UserName=args.user_id)

            if user["User"]["UserName"].lower() == args.user_id.lower():
                check_user_key_dates_and_delete(user, args)

        except Exception as e:
            print(e)
    else:
        for user in resource.users.all():
            if user.user_name.find("@") != -1 or args.no_filter:
                print("no filter")
                print(user)
                check_user_key_dates_and_delete(user, args)
