#!/bin/bash

# PLEX PARTIAL SCAN script or PLEX UPDATE script
# When zurg detects changes, it can trigger this script IF your config.yml contains
# on_library_update: sh plex_update.sh "$@"
#
# Needs xmllint and python3. They are already in the zurg docker image; on a host
# install them with:
#   sudo apt install libxml2-utils python3
#   docker compose exec zurg apk add libxml2-utils   # if running in the container

plex_url="http://localhost:32400" # If you're using zurg inside a Docker container, by default it is 172.17.0.1:32400
token="yourplextoken" # open Plex in a browser, open dev console and copy-paste this: window.localStorage.getItem("myPlexAccessToken")
zurg_mount="/mnt/zurg" # replace with your zurg mount path, ensure this is what Plex sees

# Get the list of section IDs
section_ids=$(curl -sLX GET "$plex_url/library/sections" -H "X-Plex-Token: $token" | xmllint --xpath "//Directory/@key" - | grep -o 'key="[^"]*"' | awk -F'"' '{print $2}')

if [ -z "$section_ids" ]; then
    echo "Error: missing sections; the token or the Plex URL seems to be broken"
    exit 1
fi

echo "Plex section IDs: $section_ids"

for arg in "$@"
do
    parsed_arg="${arg//\\}"
    modified_arg="$zurg_mount/$parsed_arg"
    echo "Detected update on: $arg"
    echo "Absolute path: $modified_arg"

    encoded_arg=$(echo -n "$modified_arg" | python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))")

    if [ -z "$encoded_arg" ]; then
        echo "Error: encoded path is empty, check the input or encoding process"
        continue
    fi

    for section_id in $section_ids
    do
        # The token is a query parameter here, so the URL is deliberately not echoed.
        curl -s "${plex_url}/library/sections/${section_id}/refresh?path=${encoded_arg}&X-Plex-Token=${token}" > /dev/null
        echo "Triggered scan on section $section_id"
    done
done

echo "All updated sections refreshed"

# credits to godver3, wasabipls
