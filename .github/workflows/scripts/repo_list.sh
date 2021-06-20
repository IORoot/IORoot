# /bin/bash

GHUSER=IOROOT;

# Grab Repo list for Github API
/usr/bin/curl "https://api.github.com/users/$GHUSER/repos?per_page=100&sort=created&direction=desc" | /usr/bin/jq '.[] | {NAME: .name, URL: .html_url, DESC: .description, DATE: .created_at}' > ./repos.json
/usr/bin/curl "https://api.github.com/users/$GHUSER/repos?per_page=100&page=2&sort=created&direction=desc" | /usr/bin/jq '.[] | {NAME: .name, URL: .html_url, DESC: .description, DATE: .created_at}' >> ./repos.json

# Parse it with /usr/bin/jq to make an HTML table
printf "\n## My Repository List\n" > ./output.md
printf "<table id=\"repos>\">" >> ./output.md
/bin/cat ./repos.json | /usr/bin/jq --raw-output '"<tr><td><a href=\"\(.URL)\">\(.NAME)</a></td><td>\(.DESC)</td></tr>"' >> ./output.md
printf "</table>" >> ./output.md

# Cleanup
mv output.md ../../../README.md