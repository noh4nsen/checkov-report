#!/bin/bash 

set -euo pipefail

projects=$1
report="[]"

if [[ $projects == *null* ]]; then
    echo "--- No projects to run checkov on ---"
    echo "checkov_report=$(echo $report)" >> $GITHUB_OUTPUT
    exit 0
fi

while read -r project; do
    echo "--- Running checkov on $project ---"

    if [[ $project == "." ]]; then
        continue
    fi

    cd $GITHUB_WORKSPACE/$project
    report=$(jq --argjson obj "$(jq -n -c --arg "project" $project '$ARGS.named' --argjson "report" "$(checkov -d . -o json --compact --quiet)" '$ARGS.named')" '. + [$obj]' <<< "$report")

    echo -e "--- Finished Report on $project ---\n"
done < <(echo $projects | tr -d "'" | jq -r '.projects[]' )


echo "checkov_report=$(echo -n $report | base64)" >> $GITHUB_OUTPUT