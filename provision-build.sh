#!/usr/bin/bash
set -euxo pipefail

dnf install -y \
    mkosi \
    systemd-ukify
