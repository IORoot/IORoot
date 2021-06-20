# /bin/bash

GHUSER=IOROOT;


# Add Header
/bin/cat ../partials/README_HEAD.md > ./output.md


# Get top activity.
printf "\n## Activity\n" >> ./output.md
printf "The current project I'm working on is: " >> ./output.md
/usr/bin/curl "https://api.github.com/users/$GHUSER/events?per_page=1" | /usr/bin/jq '.[0].repo.name' >> ./output.md
printf "\n" >> ./output.md


# Grab Repo list from Github API
/usr/bin/curl "https://api.github.com/users/$GHUSER/repos?per_page=100&sort=created&direction=desc" | /usr/bin/jq '.[] | {NAME: .name, URL: .html_url, DESC: .description, DATE: .created_at}' > ./repos.json
/usr/bin/curl "https://api.github.com/users/$GHUSER/repos?per_page=100&page=2&sort=created&direction=desc" | /usr/bin/jq '.[] | {NAME: .name, URL: .html_url, DESC: .description, DATE: .created_at}' >> ./repos.json


# Add to output.
/bin/cat ../partials/README_CONTENT.md >> ./output.md


# Parse it with /usr/bin/jq to make an HTML table 
printf "\n## My Repository List\n" >> ./output.md
printf "<table id=\"repos>\" >" >> ./output.md
/bin/cat ./repos.json | /usr/bin/jq --raw-output '"<tr><td><a href=\"\(.URL)\">\(.NAME)</a></td><td>\(.DESC)</br><small>(\(.DATE))</small></td></tr>"' >> ./output.md
printf "</table>" >> ./output.md


# Copy Results to README.md
mv output.md ../../../README.md