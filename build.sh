#!/usr/bin/bash
set -euxo pipefail

# show versions.
mkosi --version
ukify --version

# copy the source-code from the host vagrant share.
install -d /build/src
rsync \
    -rtv \
    --no-perms \
    --no-owner \
    --no-group \
    --exclude=output \
    --delete \
    /vagrant/src/ \
    /build/src/
pushd /build/src/

# build the efi.
rm -rf ../output
install -d ../output
mkosi \
    build \
    2>&1 | tee ../output/mkosi.build.log

# show information about the efi.
ukify \
    inspect \
    ../output/hello-world.efi
ls -laF ../output/hello-world.efi

# copy the output to the host.
popd
install -d /vagrant/output/
rsync \
    -rtv \
    --no-perms \
    --no-owner \
    --no-group \
    --delete \
    /build/output/ \
    /vagrant/output/
