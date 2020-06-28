#! /bin/sh

# Usage: get-release.sh org/repo-name asset-name
# Example : get-release.sh yaip/infra-app 

set -e # Exit immediately if a command exits with a non-zero status.

GITHUB_RELEASE_LATEST_URL="$GITHUB_API_URL/repos/$REPOSITORY_NAME/releases/latest"

# Latest version
TAG_VERSION=$(curl -sk $GITHUB_RELEASE_LATEST_URL | grep tag_name | head -n 1 | cut -d '"' -f 4)
echo ${TAG_VERSION} > version
echo "Version: $TAG_VERSION"