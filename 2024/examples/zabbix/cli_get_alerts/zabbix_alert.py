#!/usr/bin/env python3
""" Get alerts from Zabbix API"""

import argparse
import datetime
import time
import sys
import urllib3

from pyzabbix import ZabbixAPI
from termcolor import cprint

# colors
VAR_COLOR_NOK = "cc0000"
VAR_COLOR_OK = "949494"
VAR_COLOR_WARNING = "fce94f"
VAR_COLOR_UNCHECK = "252936"

# manage arguments
parser = argparse.ArgumentParser(description="Get zabbix alert")
parser.add_argument("-v", "--verbose", action="store_true")
parser.add_argument("-i", "--info", action="store_true")
parser.add_argument("-d", "--debug", action="store_true")
parser.add_argument("-s", "--server", type=str, required="true")
parser.add_argument("-u", "--user", type=str)
parser.add_argument("-p", "--password", type=str)
parser.add_argument("-t", "--token", type=str)
parser.add_argument("-S", "--nossl", action="store_true")
parser.add_argument("-U", "--unsupported", action="store_true")
parser.add_argument("-o", "--osd", type=str, help="specify OSD (waybar)")

args = parser.parse_args()

# set API
zapi = ZabbixAPI(args.server)

# SSL by default (use --nossl for internal check)
if args.nossl:
    urllib3.disable_warnings()
    zapi.session.verify = False
else:
    zapi.session.verify = True

# timeout (in seconds)
zapi.timeout = 10

# connect to API
try:
    if args.token:
        zapi.login(api_token=args.token)
    else:
        zapi.login(args.user, args.password)

except ConnectionRefusedError:
    cprint("Error: unable to authenticate to Zabbix API")
    sys.exit(1)

# show for different OSD
if args.osd == "waybar":
    triggers_alert = zapi.trigger.get(
        active=1,
        countOutput=1,
        maintenance=0,
        min_severity=2,
        monitored=1,
        only_true=1,
        skipDependent=1,
        withUnacknowledgedEvents=1,
        withLastEventUnacknowledged=1,
        filter={"value": 1},
    )

    if int(triggers_alert) > 0:
        print(triggers_alert)

else:
    triggers_desc = zapi.trigger.get(
        active=1,
        expandDescription=1,
        maintenance=0,
        monitored=1,
        only_true=1,
        output=[
            "description",
            "lastchange",
            "priority",
        ],
        selectHosts=["host"],
        skipDependent=1,
        withUnacknowledgedEvents=1,
        withLastEventUnacknowledged=1,
        filter={"value": 1},
    )

    triggers_ack = zapi.trigger.get(
        countOutput=1,
        active=1,
        maintenance=0,
        monitored=1,
        only_true=1,
        skipDependent=1,
        withAcknowledgedEvents=1,
        filter={"value": 1},
    )

    triggers_unsupported = zapi.trigger.get(
        countOutput=1, active=1, withUnacknowledgedEvents=1, filter={"state": 1}
    )

    items_unsupported = zapi.item.get(
        countOutput=1,
        active=1,
        withUnacknowledgedEvents=1,
        filter={"state": 1, "status": 0},
    )

    # count info triggers
    TRIGGERS_INFO = 0
    for t in triggers_desc:
        if t["priority"] == "1":
            TRIGGERS_INFO += 1

    # count other triggers
    t_alert = len(triggers_desc) - TRIGGERS_INFO
    t_alert_ack = int(triggers_ack)
    t_alert_unsupported = int(triggers_unsupported) + int(items_unsupported)
    TOTAL_ALERT_INFO = TRIGGERS_INFO

    # print recap
    if t_alert > 0:
        TOTAL_ALERT_COLOR = "red"
    else:
        TOTAL_ALERT_COLOR = "green"

    cprint("[", end="")
    cprint("alert: " + format(t_alert), format(TOTAL_ALERT_COLOR), end="")
    cprint("]", end="")

    if TOTAL_ALERT_INFO > 0:
        TOTAL_ALERT_INFO_COLOR = "blue"
    else:
        TOTAL_ALERT_INFO_COLOR = "green"

    cprint("\t[", end="")
    cprint("info: " + format(TOTAL_ALERT_INFO), format(TOTAL_ALERT_INFO_COLOR), end="")
    cprint("]", end="")

    if t_alert_ack > 0:
        TOTAL_ALERT_ACK_COLOR = "cyan"
    else:
        TOTAL_ALERT_ACK_COLOR = "green"

    cprint("\t[", end="")
    cprint("ack: " + format(t_alert_ack), format(TOTAL_ALERT_ACK_COLOR), end="")
    cprint("]", end="")

    if t_alert_unsupported > 0:
        TOTAL_ALERT_UNKNOWN_COLOR = "yellow"
    else:
        TOTAL_ALERT_UNKNOWN_COLOR = "green"

    cprint("\t[", end="")
    cprint(
        "unsupported: " + format(t_alert_unsupported),
        format(TOTAL_ALERT_UNKNOWN_COLOR),
        end="",
    )
    cprint("]", end="\n")

if args.verbose:
    # get time
    current_time = time.time()
    for t in reversed(triggers_desc):
        TERM_COLOR = "white"
        TERM_COLOR_ATTR = "normal"
        # not classified
        if t["priority"] == "0":
            ALERT_TYPE = "no classified"
            TERM_COLOR = "white"
        # info (only if args info defined)
        elif t["priority"] == "1":
            if args.info:
                ALERT_TYPE = "info"
                TERM_COLOR = "blue"
            else:
                continue
        # warning
        elif t["priority"] == "2":
            ALERT_TYPE = "warn"
            TERM_COLOR = "yellow"
        # average
        elif t["priority"] == "3":
            ALERT_TYPE = "avrg"
            TERM_COLOR = "yellow"
            TERM_COLOR_ATTR = "bold"
        # high
        elif t["priority"] == "4":
            ALERT_TYPE = "high"
            TERM_COLOR = "red"
        # disaster
        elif t["priority"] == "5":
            ALERT_TYPE = "disaster"
            TERM_COLOR = "red"
            TERM_COLOR_ATTR = "bold"

        # show details if verbose
        # get alert age
        alert_time = t["lastchange"]
        alert_age_sec = int(current_time) - int(alert_time)
        alert_age_human = datetime.timedelta(seconds=alert_age_sec)

        # show alerts
        if TERM_COLOR_ATTR == "bold":
            cprint(
                "["
                + format(ALERT_TYPE)
                + "] "
                + format(t["hosts"][0]["host"])
                + " | "
                + format(t["description"])
                + " ("
                + format(alert_age_human)
                + ")\
                    ",
                format(TERM_COLOR),
                attrs=[TERM_COLOR_ATTR],
            )
        else:
            cprint(
                "["
                + format(ALERT_TYPE)
                + "] "
                + format(t["hosts"][0]["host"])
                + " | "
                + format(t["description"])
                + " ("
                + format(alert_age_human)
                + ")\
                    ",
                format(TERM_COLOR),
            )
