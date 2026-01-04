#!/bin/bash

# Exit on pipe failure
set -eo pipefail

MESSAGE="0"
DRAFT="false"
PRE="false"
BRANCH="master"
VERSION_FILE="VERSION"
# GITHUB_ACCESS_TOKEN is defined in the environment file to be used here

read_version() {
    if [[ ! -f "${VERSION_FILE}" ]]; then
        log_error "VERSION file not found. Please create a VERSION file in the repository root."
    fi
        
    VERSION=$(cat "${VERSION_FILE}" | tr -d '[:space:]')
        
    if [[ -z "${VERSION}" ]]; then
        log_error "VERSION file is empty. Please add a version number (e.g., 1.0.0)."
    fi
        
    log_message "Version read from ${VERSION_FILE}: ${VERSION}"
}

# get repon name and owner
REPO_REMOTE=$(git config --get remote.origin.url)

if [ -z $REPO_REMOTE ]; then
	echo "Not a git repository"
	exit 1
fi

REPO_NAME=$(basename -s .git $REPO_REMOTE)
REPO_OWNER=$(git config --get user.name)

# set default message
if [ "$MESSAGE" == "0" ]; then
	MESSAGE=$(printf "Release of version %s" $VERSION)
fi


API_JSON=$(printf '{"tag_name": "v%s","target_commitish": "%s","name": "v%s","body": "%s","draft": %s,"prerelease": %s}' "$VERSION" "$BRANCH" "$VERSION" "$MESSAGE" "$DRAFT" "$PRE" )
API_RESPONSE_STATUS=$(curl -s -i \
  -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -d "$API_JSON" \
  "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases")
echo "$API_RESPONSE_STATUS"