# Source-code-and-Archival-Automation
Automated source code packaging system that archives all relevant files from this repository into a versioned tar.gz package using lightweight bash automation and Git-based versioning.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Troubleshooting](#troubleshooting)
- [License](#license)
- [Contact](#contact)

## Overview

This repository contains a shell-based build system that scans the project, collects designated source files, and packages them into timestamped archives under a dedicated release directory.

The core logic is implemented in build_package.sh, which reads the current version from VERSION file and produces deployment-ready artifacts.

## Features

This automation solution provides the following capabilities:

- **Automated Archive Generation**: Single-command execution generates compressed tar.gz archives containing all relevant source code files
- **Timestamp-Based Versioning**: Each build produces uniquely timestamped artifacts, preventing filename collisions and maintaining a complete build history
- **Comprehensive Logging**: Automated generation of detailed build logs (`build.log`) with timestamp entries for every operation, facilitating audit trails and debugging
- **Intelligent File Selection**: Configurable file extension filtering (*.sh, *.js, *.py) ensures only relevant source code is included in archives
- **Release Directory Management**: Dedicated output structure (`release/output/`) maintains organized artifact storage
- **Git Integration**: Seamless integration with Git workflows for version tagging and release automation
- **CI/CD Pipeline Support**: Native GitHub Actions workflow for automated builds triggered by version tags, pull requests, or manual dispatch
- **Quality Assurance**: Pull request template integration ensures consistent contribution standards
- **Flexible Deployment**: Support for custom target directories enables integration with various deployment workflows

---

## Prerequisites

Before running the build script, ensure you have the following installed:

### Required
- **Bash**: Version 4.0 or higher
  ```bash
  bash --version
  ```
- **tar utility**: For creating compressed archives
  ```bash
  tar --version
  ```
- **Git**: For version control (optional but recommended)
  ```bash
  git --version
  ```

## Installation

1. Clone repository:

```bash
git clone https://github.com/saurabhkarle/Source-code-and-Archival-Automation.git
cd Source-code-and-Archival-Automation
```

2. Ensure the VERSION file exists and contains a valid version string (for example 1.0.1).

## Usage

Run from the repository root:

```bash
./build_package.sh
```

or

```bash
./build_package.sh target_directory #to specify the exact location where you require the tarball
```
On success, a new archive will be created in the release/output directory and will be then moved to target directory
A build log build.log will be generated with all the steps taken by the script

### Release Job 

When you push a version tag:

```bash
git tag -a v1.1.0 -m "Release version 1.1.0"
git push origin v1.1.0
```
The github actions workflow will 
1. Download build artifacts
2. Create GitHub release with the tagged version
3. Will update the assets with the archived files
4. Will have a default body with version updated

#### Automated Workflow Steps

The GitHub Actions workflow executes the following sequence:

1. **Repository Checkout**: Retrieves the latest code from the tagged commit
2. **Build Execution**: Runs `build_package.sh` to generate archive
3. **Artifact Upload**: Stores build artifacts for download
4. **Release Creation**: Automatically creates a GitHub Release for the tagged version
5. **Asset Attachment**: Attaches the generated archive and build log to the release
6. **Release Notes**: Populates release description with version information

#### Workflow Triggers

The workflow activates under the following conditions:
- Push events to the `main` branch
- Pull request events targeting `main` branch
- Creation of version tags matching pattern `v**` (e.g., v1.0.0, v2.1.5)
- Manual workflow dispatch via GitHub UI

### Viewing Workflow Runs

Access workflow runs at:
- **GitHub UI**: Navigate to the Actions tab
- **URL**: `https://github.com/saurabhkarle/Source-code-and-Archival-Automation/actions` 

## Project Structure

```
Source-code-and-Archival-Automation/
├── .github/
│   ├── workflows/
│   │   └── github-actions.yml          # CI/CD workflow configuration
│   └── pull_request_template.md        # PR template for contributions
├── archival files/                      # Sample source files (demonstration)
│   ├── sample.js
│   ├── sample.py
│   └── sample.sh
├── .gitignore                           # Git exclusion patterns
├── build_package.sh                     # Main build automation script
├── LICENSE                              # MIT License
├── README.md                            # Documentation (this file)
└── VERSION                              # Semantic version identifier
```

### Directory Descriptions

- **`.github/workflows/`**: Contains CI/CD pipeline definitions
- **`archival files/`**: Sample files demonstrating the archival process
- **`build_package.sh`**: Core script implementing build logic and archive generation
- **`VERSION`**: Single source of truth for version management

---

## Troubleshooting

### Common Issues and Resolutions

#### Issue: Permission Denied

**Symptom**: Error message "Permission denied" when executing `build_package.sh`

**Resolution**:
```bash
chmod +x build_package.sh
./build_package.sh
```

#### Issue: VERSION File Not Found

**Symptom**: Script reports "VERSION file not found. Please create a VERSION file in the repository root."

**Resolution**:
```bash
echo "1.0.0" > VERSION
```

#### Issue: tar Command Not Available

**Symptom**: Error message "tar: command not found"

**Resolution**:

*Ubuntu/Debian:*
```bash
sudo apt-get update
sudo apt-get install tar
```

*macOS:*
```bash
brew install gnu-tar
```

#### Issue: Empty Archive Generated

**Symptom**: Archive file is created but contains no files

**Resolution**: Verify that files matching the configured extensions exist in the project directory. Review `build.log` for details.

#### Issue: GitHub Actions Workflow Fails

**Symptom**: Workflow execution shows permission errors

**Resolution**: Ensure the workflow has appropriate permissions in `.github/workflows/github-actions.yml`:

```yaml
permissions:
  contents: write
```

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## Contact

**Author**: Saurabh Karle  
**GitHub**: [@saurabhkarle](https://github.com/saurabhkarle)  

---