#! /bin/sh

# Usage: get-release.sh org/repo-name asset-name
# Example : get-release.sh yaip/infra-app 

set -e # Exit immediately if a command exits with a non-zero status.

APP_NAME=infra-app
TARGET=${DIR:-"/tmp"}/$APP_NAME

# Latest version
TAG_VERSION=$(cat version)
VERSION_NUMBER=${TAG_VERSION//[a-zA-Z]/}
ASSET_NAME="app-${VERSION_NUMBER}_Linux-x86_64"

GITHUB_DOWNLOAD_URL="$GITHUB_URL/$REPOSITORY/releases/download/$TAG_VERSION/$ASSET_NAME"

echo "Downloading ${GITHUB_DOWNLOAD_URL} "
curl -skL -o $TARGET $GITHUB_DOWNLOAD_URL
echo "Downloaded into ${TARGET} "