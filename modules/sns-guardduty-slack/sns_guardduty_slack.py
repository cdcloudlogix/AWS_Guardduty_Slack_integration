"""
Lambda function receiving SNS notifications from GuardDuty
Reformat and send notifications to Slack
"""
import json
import logging
import os
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

SLACK_CHANNEL = os.environ['SLACK_CHANNEL']
SLACK_HOOK_URL = os.environ['HOOK_URL']

LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)

def lambda_handler(event, _):
    """
    Main method lambda_handler(event)
    """
    LOGGER.info("Event: %s", event)
    json_message = event['Records'][0]['Sns']['Message']
    loaded_json = json.loads(json_message)
    severity = float(loaded_json['detail']['severity'])
    severity_message = ""
    if severity < 4:
        severity_message = ":large_blue_circle: LOW"
    elif 4 <= severity < 7:
        severity_message = ":warning: MEDIUM"
    elif severity >= 7:
        severity_message = ":fire: HIGH"
    message = ":amazon: *AWS Account:* {} *Time:* {} \n".format(
        loaded_json['account'],
        loaded_json['time']
    )
    message = "{}*Alert level:* {} \n".format(
        message,
        severity_message
    )
    message = "{}*Type:* {}\n".format(
        message,
        loaded_json['detail']['type']
    )
    message = "{}*Title:* {}\n".format(
        message,
        loaded_json['detail']['title']
    )
    message = "{}*Description:* {}\n".format(
        message,
        loaded_json['detail']['description']
    )
    message = "{}*Severity:* {}\n".format(
        message,
        loaded_json['detail']['severity']
    )
    message = "{}*Event First Seen:* {}\n".format(
        message,
        loaded_json['detail']['service']['eventFirstSeen']
    )
    message = "{}*Event Last Seen:* {}\n".format(
        message,
        loaded_json['detail']['service']['eventLastSeen']
    )
    message = "{}*Target Resource:* {}\n".format(
        message, json.dumps(loaded_json['detail']['resource'])
    )
    message = "{}*Action:* {}\n".format(
        message,
        json.dumps(loaded_json['detail']['service']['action'])
    )
    message = "{}*Additional information:* {}\n".format(
        message,
        json.dumps(loaded_json['detail']['service']['additionalInfo'])
    )
    slack_message = {
        'channel': SLACK_CHANNEL,
        'username': "AWS GuardDuty",
        'text': message,
        'icon_emoji' : ":guardsman:"
    }
    req = Request(SLACK_HOOK_URL, json.dumps(slack_message).encode('utf-8'))
    try:
        response = urlopen(req)
        response.read()
        LOGGER.info("Message posted to %s", slack_message['channel'])
    except HTTPError as err:
        LOGGER.error("Request failed: %d %s", err.code, err.reason)
    except URLError as err:
        LOGGER.error("Server connection failed: %s", err.reason)
