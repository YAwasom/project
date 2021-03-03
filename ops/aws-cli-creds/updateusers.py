import sys
import boto3
import argparse

parser = argparse.ArgumentParser(description="Update Users")
parser.add_argument("--userid")
args, leftovers = parser.parse_known_args()

new_user_id = args.userid

if new_user_id is None:
    new_user_id = input("Provide your login_id/Email Address: ")

profiles = boto3.session.Session().available_profiles


def delete_existing_user(user_id, session, client):
    print(f"Removing user {user_id} from all groups")

    groups = client.list_groups_for_user(UserName=user_id)["Groups"]

    for group in groups:
        client.remove_user_from_group(
            GroupName=group.get("GroupName"), UserName=user_id
        )

    access_key_info = session.client("iam").list_access_keys(UserName=user_id)

    print(f"Deleting user access keys {user_id}")
    for key_metadata in access_key_info["AccessKeyMetadata"]:
        client.delete_access_key(
            UserName=user_id, AccessKeyId=key_metadata["AccessKeyId"]
        )

    print(f"Deleting user {user_id}")
    client.delete_user(UserName=user_id)


with open("credentials.txt", "w+") as credfile:
    for profile in profiles:

        if profile == "default":
            print(f"Skipping default account. Dont want to hit it twice.")
            continue

        print(f"Profile: {profile}")
        current_user_session = boto3.Session(profile_name=profile)
        current_user_client = current_user_session.client("iam")

        current_user_id = ""
        try:
            current_user_id = (
                current_user_session.resource("iam").CurrentUser().arn.split("user/")[1]
            )
        except Exception as e:
            print(f"Unable to fetch current user: {e}")
            exit(1)

        creds = current_user_session.get_credentials()
        credfile.write(f"[{profile}]\n")

        if current_user_id.lower() != new_user_id.lower():
            print(f"User: {current_user_id} is not formatted correctly")
            if input("Create new user? (y/n)") == "y":

                try:
                    new_user_info = current_user_client.get_user(UserName=new_user_id)

                    if new_user_info["User"]["UserName"].lower() == new_user_id.lower():
                        print(f"User {new_user_id} already exists")

                        if (
                            input(
                                "Delete the already existing user and recreate it? (y/n)"
                            )
                            == "y"
                        ):
                            delete_existing_user(
                                new_user_id, current_user_session, current_user_client
                            )

                except Exception as e:
                    print(
                        f"Unable to fetch current user {new_user_id} in {profile} {e}"
                    )
                    if input("Skip to Next Profile?") == "y":
                        continue
                    else:
                        exit(1)

                groups = current_user_client.list_groups_for_user(
                    UserName=current_user_id
                )["Groups"]

                current_user_client.create_user(UserName=new_user_id)

                for group in groups:
                    current_user_client.add_user_to_group(
                        GroupName=group.get("GroupName"), UserName=new_user_id
                    )

                accesskey = current_user_client.create_access_key(UserName=new_user_id)

                AccessUser = accesskey["AccessKey"].get("AccessKeyId")
                AccessPass = accesskey["AccessKey"].get("SecretAccessKey")

                credfile.write(f"aws_access_key_id = {AccessUser}\n")
                credfile.write(f"aws_secret_access_key = {AccessPass}\n")
                print(
                    f"{new_user_id} has now been created and keys written to credentials.txt"
                )

        else:
            print(f"Not creating a new user. Saving existing keys to credentials.txt")
            AccessUser = creds.access_key
            AccessPass = creds.secret_key

            credfile.write(f"aws_access_key_id = {AccessUser}\n")
            credfile.write(f"aws_secret_access_key = {AccessPass}\n")
