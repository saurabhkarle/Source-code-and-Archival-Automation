#!/bin/bash
VERSION_FILE="VERSION"


if [[ ! -f "${VERSION_FILE}" ]]; then
    echo "VERSION file not found. Please create a VERSION file in the repository root."
fi
    
VERSION=$(cat "${VERSION_FILE}" | tr -d '[:space:]')
    
if [[ -z "${VERSION}" ]]; then
    echo "VERSION file is empty. Please add a version number (e.g., 1.0.0)."
fi
    
echo "Version read from ${VERSION_FILE}: ${VERSION}"
