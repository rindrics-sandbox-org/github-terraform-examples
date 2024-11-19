#!/bin/bash

# Usage:   $ get_terragrunt.bash <dist> <version> <sha256sum>
# Example: $ get_terragrunt.bash /bin/terragrunt v0.45.3 16d9e40b59f94f1640bad00d36afa1cf2082a105f2966aec2a13f685c8447035

set -euo pipefail

TERRAGRUNT_BIN=$1
TERRAGRUNT_VERSION=$2
SHA256SUM=$3

cat <<EOF > sum.txt
$SHA256SUM -
EOF
trap 'rm -f sum.txt' 0 1 2 3 15

curl -fLs "https://github.com/gruntwork-io/terragrunt/releases/download/$TERRAGRUNT_VERSION/terragrunt_linux_amd64" | tee "$TERRAGRUNT_BIN" | sha256sum -c sum.txt
chmod a+x "$TERRAGRUNT_BIN"
"$TERRAGRUNT_BIN" -v
