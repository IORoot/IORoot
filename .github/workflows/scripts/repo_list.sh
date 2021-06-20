# /bin/bash

GHUSER=IOROOT;

# Grab Repo list for Github API
/usr/bin/curl "https://api.github.com/users/$GHUSER/repos?per_page=100&sort=created&direction=desc" | /usr/local/bin/jq '.[] | {NAME: .name, URL: .html_url, DESC: .description, DATE: .created_at}' > ./repos.json
/usr/bin/curl "https://api.github.com/users/$GHUSER/repos?per_page=100&page=2&sort=created&direction=desc" | /usr/local/bin/jq '.[] | {NAME: .name, URL: .html_url, DESC: .description, DATE: .created_at}' >> ./repos.json

# Add header readme onto the top.
/bin/cat ../partials/README_HEAD.md > ./output.md

# Parse it with /usr/local/bin/JQ to make an HTML table
printf "\n## My Repository List\n" >> ./output.md
# printf "<table id=\"repos>\">" >> ./output.md
/bin/cat ./repos.json | /usr/local/bin/jq --raw-output '"- [\(.NAME)](\(.URL)) \(.DESC)"' >> ./output.md
# printf "</table>" >> ./output.md

# Cleanup
rm repos.json
mv output.md ../../../README.md