#!/bin/bash
cd ${CI_WORKSPACE}
make download-firebase-sdk
make generate-licenses
