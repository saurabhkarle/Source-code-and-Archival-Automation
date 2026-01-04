# Source-code-and-Archival-Automation
Automated source code packaging system that archives all relevant files from this repository into a versioned tar.gz package using lightweight bash automation and Git-based versioning.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)
- [Contact](#contact)

## Overview

This repository contains a shell-based build system that scans the project, collects designated source files, and packages them into timestamped archives under a dedicated release directory.

The core logic is implemented in build_package.sh, which reads the current version from VERSION file and produces deployment-ready artifacts.

## Features

- Automated packaging of repository contents into compressed tar.gz archives using a single build script.
- Timestamped archives created during each run to preserve build history and avoid collisions.
- Proper logging and error handling with a generation of build log for every run with date and time stamp.
- Release directory management that ensures built artifacts are collected under a dedicated output folder.
- Git integration via git-release.sh to help automate tagging and local release pushes.
- Option of git release in github actions as well as through local computer
- A Merge Request Template in place to ensure feature quality

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
The github actions wrokflow will 
1. Download build artifacts
2. Create GitHub release with the version read from VERSION file

This release can also be triggered locally using release_package.sh

```bash
echo "1.0.0" > VERSION
git commit -am "Bump version to 1.0.0"
git tag v1.0.0
git push origin v1.0.0
```

### Viewing Workflow Runs

Access workflow runs at:
- **GitHub UI**: Navigate to the Actions tab
- **URL**: `https://github.com/saurabhkarle/Source-Code-Archival-Automation-Demonstration/actions` 

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## Contact

**Author**: Saurabh Karle  
**GitHub**: [@saurabhkarle](https://github.com/saurabhkarle)  

---