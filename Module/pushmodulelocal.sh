#!/bin/bash

# --------- WARNING ---------
# This file is meant for Armchair Developers only. It deploys
# a local version of the Kyber module to a development release
# channel. This file is not useful for most contributors.
# --------- WARNING ---------

if ! test -f _work2/mc; then
    mkdir _work2

    wget -q https://dl.min.io/client/mc/release/linux-amd64/mc -O _work2/mc
    chmod +x _work2/mc
    ./_work2/mc alias set kyber https://s3.kyber.gg $AWS_KEY_ID $AWS_SECRET_ACCESS_KEY
fi

./_work2/mc cp kyber/artifacts/kyber-depends.zip _work2/kyber-depends.zip

rm -rf _work
mkdir _work

unzip -o _work2/kyber-depends.zip -d _work
sudo cp -f bazel-bin/Kyber.pdb _work/Kyber.pdb
sudo cp -f bazel-bin/Kyber.dll _work/Kyber.dll
zip -j -r _work2/kyber-module.zip _work

./_work2/mc cp _work2/kyber-module.zip "kyber/releases/dev/kyber-module.zip"
