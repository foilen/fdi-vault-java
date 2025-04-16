#!/bin/bash
set -e

# Validate required environment variables
required_vars=("VAULT_HOSTNAME" "VAULT_NAMESPACE" "VAULT_VERSION" "VAULT_FILE")
missing_vars=()

for var in "${required_vars[@]}"; do
  if [ -z "${!var}" ]; then
    missing_vars+=("$var")
  fi
done

if [ ${#missing_vars[@]} -ne 0 ]; then
  echo "ERROR: The following required environment variables are not set:"
  for var in "${missing_vars[@]}"; do
    echo "  - $var"
  done
  echo "Please set these variables and try again."
  exit 1
fi

# Get the user and pass if provided
VAULT_USER_PASS=""
if [ -n "$VAULT_USER" ]; then
  echo User $VAULT_USER will be used
  VAULT_USER_PASS="$VAULT_USER:$VAULT_PASSWORD@"
fi

# Check if VAULT_VERSION is a tag
echo "Checking if $VAULT_VERSION is a tag"
TAG_URL="https://${VAULT_USER_PASS}${VAULT_HOSTNAME}/${VAULT_NAMESPACE}/tags/${VAULT_VERSION}"
HTTP_CODE=$(curl -s -o /tmp/response.txt -w "%{http_code}" "$TAG_URL")
if [ "$HTTP_CODE" == "404" ]; then
  echo "$VAULT_VERSION is not a tag, treating as a specific version"
  VAULT_RESOLVED_VERSION="$VAULT_VERSION"
else
  echo "$VAULT_VERSION is a tag"
  # Get the resolved version for the tag
  VAULT_RESOLVED_VERSION=$(cat /tmp/response.txt)
  echo "Resolved version for tag $VAULT_VERSION is $VAULT_RESOLVED_VERSION"
fi

# Check if we need to download the file
NEED_DOWNLOAD=true
if [ -f "/app/currentAppVersion.txt" ]; then
  CURRENT_VERSION=$(cat /app/currentAppVersion.txt)
  if [ "$CURRENT_VERSION" = "$VAULT_RESOLVED_VERSION" ]; then
    echo "Current version $CURRENT_VERSION matches resolved version $VAULT_RESOLVED_VERSION, no need to download"
    NEED_DOWNLOAD=false
  else
    echo "Current version $CURRENT_VERSION differs from resolved version $VAULT_RESOLVED_VERSION, will download"
  fi
fi

# Download the file if needed
if [ "$NEED_DOWNLOAD" = true ]; then
  echo "Downloading application from vault"
  DOWNLOAD_URL="https://${VAULT_USER_PASS}${VAULT_HOSTNAME}/${VAULT_NAMESPACE}/${VAULT_VERSION}/${VAULT_FILE}"
  echo "Download URL: $DOWNLOAD_URL"

  # Create app directory if it doesn't exist
  mkdir -p /app

  # Download the file
  if curl -s -f -o "/app/${VAULT_FILE}" "$DOWNLOAD_URL"; then
    echo "Download successful"
    # Update the version file
    echo "$VAULT_RESOLVED_VERSION" > /app/currentAppVersion.txt
    echo "Updated currentAppVersion.txt to $VAULT_RESOLVED_VERSION"
  else
    echo "ERROR: Failed to download the application"
    exit 1
  fi
fi

# Start the application using java
echo "Starting Java application: ${VAULT_FILE}"
cd /app
java -jar "${VAULT_FILE}"
