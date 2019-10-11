#! /usr/bin/bash

cd ~/devel/void-packages/

# search for packages I maintain
# grep still follows links, so remove dupes
PKGS=($(grep -rl karl.robert.nilsson srcpkgs/* | cut -d '/' -f2 | uniq))
PKGS+=("keybase" "keybase-desktop")

for PKG in ${PKGS[*]};
# check for updates in parallel
do
    ./xbps-src update-check srcpkgs/$PKG &
done
wait

