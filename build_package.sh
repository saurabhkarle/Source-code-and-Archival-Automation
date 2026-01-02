#!/bin/bash
VERSION_FILE="VERSION"
LOG_FILE="build.log"
RELEASE_DIR="release"
FILE_EXTENSIONS=("*.sh" "*.js" "*.py")
EXCLUDE_DIRS=(".git" "node_modules" "target" "build")


# Log message with timestamp
log_message() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[${timestamp}] ${message}" | tee -a "${LOG_FILE}"
}

# Log error and exit
log_error() {
    local message="$1"
    log_message "ERROR: ${message}"
    exit 1
}

# Initialize build process
initialize_build() {
    log_message "=== Starting Build Process ==="
    log_message "Repository: $(basename "$(pwd)")"
    log_message "Timestamp: $(date)"
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

# Build the main archive and add it to the release folder
package_source_files() {
    local timestamp=$(date '+%Y%m%d_%H%M')
    local archive_name="app-${VERSION}-${timestamp}.tar.gz"
    local archive_path="${RELEASE_DIR}/${archive_name}"
    local temp_filelist=$(mktemp)
    trap "rm -f ${temp_filelist}" EXIT
    local file_count=0
    for ext in "${FILE_EXTENSIONS[@]}"; do
        while IFS= read -r -d '' file; do

            local skip=false
            for exclude_dir in "${EXCLUDE_DIRS[@]}"; do
                if [[ "${file}" == *"/${exclude_dir}/"* ]] || [[ "${file}" == "./${exclude_dir}/"* ]]; then
                    skip=true
                    break
                fi
            done
            
            if [[ "${skip}" == false ]]; then
                echo "${file}" >> "${temp_filelist}"
                ((file_count++))
            fi
        done < <(find . -name "${ext}" -type f -print0)
    done
    if [[ ${file_count} -eq 0 ]]; then
        log_error "No source files found to package"
    fi
    
    log_message "Found ${file_count} file(s) to package"
    
    if tar -czf "${archive_path}" -T "${temp_filelist}" 2>> "${LOG_FILE}"; then
        log_message "Successfully created archive: ${archive_path}"
    else
        log_error "Failed to create archive"
    fi
}

# Clear versions older than current version
clean_old_artifacts() {
    log_message "Cleaning old build artifacts..."
    
    local old_count=0
    if [[ -d "${RELEASE_DIR}" ]]; then
        old_count=$(find "${RELEASE_DIR}" -name "app-*.tar.gz" | wc -l)
        if [[ ${old_count} -gt 0 ]]; then
            find "${RELEASE_DIR}" -name "app-*.tar.gz" -delete
            log_message "Removed ${old_count} old archive(s)"
        else
            log_message "No old archives found to clean"
        fi
    fi
}

main() {
    initialize_build
    read_version
    create_release_directory
    clean_old_artifacts
    package_source_files
}

main "$@"