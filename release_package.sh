#!/bin/bash

# Exit on error, undefined variables, and pipeline failure
set -euo pipefail

VERSION_FILE="VERSION"
# GITHUB_ACCESS_TOKEN is defined in the environment file to be used here
LOG_FILE="build.log"
RELEASE_DIR="./artifacts"

# Log message with timestamp
log_message() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M')
    echo "[${timestamp}] ${message}" | tee -a "${LOG_FILE}" >&2
}

# Log error and exit
log_error() {
    local message="$1"
    log_message "ERROR: ${message}"
    exit 1
}

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  log_error "GITHUB_TOKEN must be set."
fi

if [[ -z "${GITHUB_REPOSITORY:-}" ]]; then
  log_error "GITHUB_REPOSITORY must be set (e.g. owner/repo)."
fi

if [[ ! -f "${VERSION_FILE}" ]]; then
    log_error "VERSION file not found. Please create a VERSION file in the repository root."
fi
        
VERSION=$(cat "${VERSION_FILE}" | tr -d '[:space:]')
        
if [[ -z "${VERSION}" ]]; then
    log_error "VERSION file is empty. Please add a version number (e.g., 1.0.0)."
fi
        
log_message "Version read from ${VERSION_FILE}: ${VERSION}"

# Extract version from tag if this is a tag push
if [[ "${GITHUB_REF}" == refs/tags/* ]]; then
  TAG_VERSION="${GITHUB_REF#refs/tags/v}"
else
  TAG_VERSION=""
# Only compare versions if this was a tag push
if [[ -n "${TAG_VERSION}" && "${TAG_VERSION}" != "${VERSION}" ]]; then
  log_message "Warning: VERSION file (${VERSION}) does not match tag version (${TAG_VERSION})."
fi

TAG_NAME="${GITHUB_REF_NAME:-v${VERSION}}"


# Adding proper body and information for the release
RELEASE_NAME="Source Code Archival Automation v${VERSION}"

BUILD_DATE="${GITHUB_EVENT_TIMESTAMP:-$(date --iso-8601=seconds)}"

read -r -d '' RELEASE_BODY <<EOF || true
## Release v${VERSION}

Automated source code archive build from tag \`${TAG_NAME}\`.

### Changes
- Automated build via GitHub Actions
- Source code packaged into tar.gz archive
- All .sh, .js, and .py files included
- Build logs attached

### Artifacts
- Source archive (tar.gz)
- Build logs

**Build Information:**
- Commit: ${GITHUB_SHA:-unknown}
- Workflow: #${GITHUB_RUN_NUMBER:-0}
- Date: ${BUILD_DATE}
EOF

ASSETS=()

# Add the main tarball generated to assets
if compgen -G "${RELEASE_DIR}/app-*.tar.gz" > /dev/null; then
  while IFS= read -r -d '' f; do
    ASSETS+=("$f")
  done < <(find "${RELEASE_DIR}" -maxdepth 1 -name 'app-*.tar.gz' -print0)
else
  log_message "No archives found in ${RELEASE_DIR}/app-*.tar.gz"
fi

if [[ -f "${LOG_FILE}" ]]; then
  ASSETS+=("${LOG_FILE}")
else
  log_message "No build.log found to attach."
fi

if [[ "${#ASSETS[@]}" -eq 0 ]]; then
  log_error "No assets found to upload to the GitHub release."
fi

log_message "Assets to upload: ${ASSETS[*]}"

export GITHUB_TOKEN

log_message "Creating GitHub release '${VERSION}' for ${GITHUB_REPOSITORY}..."

gh release create "${VERSION}" \
  "${ASSETS[@]}" \
  --repo "${GITHUB_REPOSITORY}" \
  --title "${RELEASE_NAME}" \
  --notes "${RELEASE_BODY}" \
  --draft=false \
  --prerelease=false

log_message "GitHub release '${VERSION}' created successfully."