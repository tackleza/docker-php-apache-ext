#!/bin/bash
set -euo pipefail

versions=(8.2 8.3 8.4 8.5 latest)

for version in "${versions[@]}"; do
    (cd "$version" && bash -e build.sh)
done

for version in "${versions[@]}"; do
    (cd "$version" && bash -e push.sh)
done
