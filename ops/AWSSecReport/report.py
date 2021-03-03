# input argument 1 input file to process
print("Python Started")

import json
import sys
import smtplib
import boto3
from itertools import groupby


def getparameter(name):
    try:
        ssm = boto3.client("ssm", region_name="us-west-2")
        parameter = ssm.get_parameter(Name=name, WithDecryption=True)
        return parameter["Parameter"]["Value"]
    except Exception as e:
        print("Failed to get Parameter" + name)
        print("e")


print("Imported Libraries")


test = False
product = ""
severity = sys.argv[1]
try:
    product = sys.argv[2]

except:
    awsfilter = {
        "SeverityLabel": [{"Value": severity, "Comparison": "EQUALS"}],
        "RecordState": [{"Value": "ACTIVE", "Comparison": "EQUALS"}],
    }
else:

    awsfilter = {
        "ProductName": [{"Value": product, "Comparison": "EQUALS"}],
        "SeverityLabel": [{"Value": severity, "Comparison": "EQUALS"}],
        "RecordState": [{"Value": "ACTIVE", "Comparison": "EQUALS"}],
    }
print(awsfilter)
username = "apikey"
password = getparameter("/com/warnerbros/contentnow/nest/stg/sendgrid/api_key")

print("Got arguments")

try:
    print("Getting Security Findings")
    sechub = boto3.client("securityhub", region_name="us-west-2")
    findings = []
    i = 0
    paginator = sechub.get_paginator("get_findings")
    response_iterator = paginator.paginate(
        Filters=awsfilter,
        PaginationConfig={
            "MaxItems": 100,
            "PageSize": 100,
        },
    )

    for page in response_iterator:
        findings.extend(page["Findings"])
        print("Processing Page:" + str(i + 1))
except:
    print("Failed to get Report")
    print(Exception)
    quit()


results = ""


class MyFinding(object):
    def __init__(
        self,
        title,
        accountid,
        resid,
        region,
        restype,
        findingid,
        firstdate,
        description,
    ):
        self.title = title
        self.accountid = accountid
        self.resid = resid
        self.region = region
        self.restype = restype
        self.findingid = findingid
        self.firstdate = firstdate
        self.description = description


MyFindings = []
print("Checking Findings")
if findings:
    for finding in findings:
        try:
            title = finding["Title"]
            findingcount = len(title)
            accountid = finding["AwsAccountId"]
            firstdate = finding.get("FirstObservedAt", "None")
            description = finding["Description"]
            findingid = finding["Id"]

            for resource in finding["Resources"]:
                resid = resource["Id"]
                region = resource["Region"]
                restype = resource["Type"]

        except Exception as e:
            print(e)
            pass

        MyFindings.append(
            MyFinding(
                title,
                accountid,
                resid,
                region,
                restype,
                findingid,
                firstdate,
                description,
            )
        )

    print("Building Report")
    groups = groupby(MyFindings, key=lambda x: (x.accountid))

    results = results + "Total Findings: " + str(findingcount) + " \n"
    for key, group in groups:

        results = results + "\nAccount: " + key
        for item in group:
            results = results + "\n     Title: " + item.title
            results = results + "\n     Description: " + item.description
            results = results + "\n     First Reported: " + item.firstdate
            results = results + "\n     Resource Type: " + item.restype
            results = results + "\n     Region: " + item.region
            results = results + "\n     Resource ID: " + item.resid
            results = results + "\n     Finding ID: " + item.findingid
            results = results + "\n\n     ---------------------------- \n"
        results = results + "\n "
        results = results + "\n "

    smtp_server = "smtp.sendgrid.net"
    sender = "noreply@wb.com"
    receiver = "cmd-ops@warnerbros.com"
    port = 2525

    print("Creating Email")
    message = f"""\
    FROM: {sender}
    Subject: AWS Security Findings - {product} {severity}

    Security Hub Findings for: {product} {severity}

    {results}
    """

    print("Try Sending Email")
    try:
        with smtplib.SMTP(smtp_server, port) as server:
            print("Sending Email")
            server.starttls()
            server.login(username, password)
            if not test:
                server.sendmail(sender, receiver, message)
            else:
                print(message)
            print("Sent email successfully")

    except Exception as e:
        print("Problem Sending Mail")
        print(e)

    sns = boto3.client("sns")
    if not test:
        response = sns.publish(
            TopicArn="arn:aws:sns:us-west-2:348180535083:cmd-ops-slack-chat-bot-SecReport",
            Message=message,
        )
else:
    print("No Findings")
