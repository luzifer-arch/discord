#!/bin/bash
set -euxo pipefail

# Read pkg name
PKG=$(awk -F '=' '/pkgname=/{ print $2 }' PKGBUILD)

# Get latest version
VER=$(
  curl -fsS \
    -o /dev/null \
    -w '%{redirect_url}' \
    'https://discord.com/api/download?platform=linux&format=tar.gz' |
    grep -o '[0-9]*\.[0-9]*\.[0-9]*' |
    head -n1
)

[[ -n $VER ]]

# Insert latest version into PKGBUILD
sed -i \
  -e "s/^pkgver=.*/pkgver=${VER}/" \
  PKGBUILD

# Check whether this changed anything
if (git diff --exit-code PKGBUILD); then
  echo "Package ${PKG} has most recent version ${VER}"
  exit 0
fi

# Reset pkgrel
sed -i \
  -e 's/pkgrel=.*/pkgrel=1/' \
  PKGBUILD

# Update source hashes
updpkgsums
# Remove checksums for HTML files (they change all the time)
sed -i -e "/sha512sums/,/)/ {n;n;s/ '.*'/ 'SKIP'/;n;s/ '.*'/ 'SKIP'/}" PKGBUILD

# Commit changes
git add PKGBUILD
git commit -m "${PKG} v${VER}"
