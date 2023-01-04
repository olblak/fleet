#!/bin/sh

set -eux

# Testing that we can run curl command from the GitHub Runner
curl --help > /dev/null

VERSION="$1"
if [ -z "$VERSION" ]
then
    echo "Empty version provided"
    exit 0
fi

if [[ "$VERSION" == "$(sed -n "s/^version: \([.0-9]*\)/\1/p" ./charts/fleet/charts/gitjob/Chart.yaml)" ]]
then
    echo "The Gitjob chart in Fleet is already up to date. Exiting..."
    exit 0
fi

curl -L -o "/tmp/gitjob-${VERSION}.tgz" "https://github.com/rancher/gitjob/releases/download/v${VERSION}/gitjob-${VERSION}.tgz"

tar -xf "/tmp/gitjob-${VERSION}.tgz" -C ./charts/fleet/charts/

# move gitjob crd to fleet-crd chart
mv ./charts/fleet/charts/gitjob/templates/crds.yaml ./charts/fleet-crd/templates/gitjobs-crds.yaml

rm "/tmp/gitjob-${VERSION}.tgz"