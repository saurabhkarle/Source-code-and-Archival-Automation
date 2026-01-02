#!/bin/bash
VERSION_FILE="VERSION"
LOG_FILE="build.log"
RELEASE_DIR="release"


log_message() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[${timestamp}] ${message}" | tee -a "${LOG_FILE}"
}


log_error() {
    local message="$1"
    log_message "ERROR: ${message}"
    exit 1
}


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


create_release_directory() {
    if [[ ! -d "${RELEASE_DIR}" ]]; then
        mkdir -p "${RELEASE_DIR}"
        log_message "Created release directory: ${RELEASE_DIR}/"
    else
        log_message "Release directory already exists: ${RELEASE_DIR}/"
    fi
}

read_version
create_release_directory