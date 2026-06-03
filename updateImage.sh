#!/bin/bash

set -e

# Brief: update the Deployment image and set a bootstrap trigger annotation.
# The annotation is used by the container (via fieldRef) to decide whether
# to run a destructive bootstrap (import). The trigger is derived from the
# image tag to tie the bootstrap to the deployed image version.
yq >/dev/null 2>&1 || echo "yq must be installed"

if [ "$#" -ne 2 ]; then
  echo "usage $0 <service_name> <imageWithTag>"
  exit 1
fi

# Normalize image name to lowercase (consistency) and extract the tag
imageWithTag=$(echo $2 | tr '[:upper:]' '[:lower:]')
imageTag=${imageWithTag##*:}

# Update the deployment manifest: set the container image AND
# set metadata.annotations.wordpress-bootstrap-trigger to "bootstrap-<tag>"
yq eval -ie ".spec.template.spec.containers[0].image = \"$imageWithTag\" | .spec.template.metadata.annotations.\"wordpress-bootstrap-trigger\" = \"bootstrap-$imageTag\"" $1/deployment.yaml

echo "Update complete."
