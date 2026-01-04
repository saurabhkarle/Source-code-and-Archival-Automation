# Source-code-and-Archival-Automation
Automated source code packaging system that archives all relevant files from this repository into a versioned tar.gz package using lightweight bash automation and Git-based versioning.

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

## Installation

1. Clone repository:

```
git clone https://github.com/saurabhkarle/Source-code-and-Archival-Automation.git
cd Source-code-and-Archival-Automation
```

2. Make the bash executable

```
chmod +x build_package.sh
```

3. Ensure the VERSION file exists and contains a valid version string (for example 1.0.1).

## Usage

Run from the repository root:

```
./build_package.sh
```

or

```
./build_package.sh target_directory #to specify the exact location where you require the tarball
```
On success, a new archive will be created in the release/output directory and will be then moved to target directory
A build log build.log will be generated with all the steps taken by the script

