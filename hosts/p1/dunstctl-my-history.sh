#!/usr/bin/env bash

# 1. Get the system boot time in seconds since the Unix epoch
boot_time=$(date +%s -d"$(uptime -s)")

# 2. Pass it into jq to calculate the real time and convert with todate
dunstctl history | jq --arg boot "$boot_time" '.data[0] | reverse | map({
  appname: .appname.data,
  body: .body.data,
  message: .message.data,
  timeout: (.timeout.data / 1000 / 1000),
  urgency: .urgency.data,
  timestamp: (($boot | tonumber) + (.timestamp.data / 1000 / 1000) | todate)
})'
