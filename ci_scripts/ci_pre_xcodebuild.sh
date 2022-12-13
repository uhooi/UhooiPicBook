#!/bin/bash
cd ${CI_WORKSPACE}
make build-cli-tools
make download-firebase-sdk
make generate-licenses
