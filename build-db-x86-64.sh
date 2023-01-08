#!/usr/bin/env bash
#
# Script name: build-db.sh
# Description: Script for rebuilding the database for yaur.
# GitHub: https://github.com/Rider3268/yaur
# Contributors: Yura Shevchuk

# Set with the flags "-e", "-u","-o pipefail" cause the script to fail
# if certain things happen, which is a good thing.  Otherwise, we can
# get hidden bugs that are hard to discover.
set -euo pipefail

x86_pkgbuild=$(find ../yaur-pkgbuild/x86_64 -type f -name "*.pkg.tar.zst*")

for x in ${x86_pkgbuild}
do
    mv "${x}" os/x86_64/
    echo "Moving ${x}"
done

echo "###########################"
echo "Building the repo database."
echo "###########################"

## Arch: x86_64
cd os/x86_64
rm -f yaur*

echo "###################################"
echo "Building for architecture 'x86_64'."
echo "###################################"

## repo-add
## -s: signs the packages
## -n: only add new packages not already in database
## -R: remove old package files when updating their entry
# repo-add -s -n -R yaur.db.tar.gz *.pkg.tar.zst
repo-add -n -R yaur.db.tar.gz *.pkg.tar.zst
# Removing the symlinks because GitHub can't handle them.
rm yaur.db
# rm yaur.db.sig
rm yaur.files
# rm yaur.files.sig

# Renaming the tar.gz files without the extension.
mv yaur.db.tar.gz yaur.db
# mv yaur.db.tar.gz.sig yaur.sig
mv yaur.files.tar.gz yaur.files
# mv yaur.files.tar.gz.sig yaur.files.sig

echo "#######################################"
echo "Packages in the repo have been updated!"
echo "#######################################"
