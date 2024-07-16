#!/bin/bash

set -e

yq >/dev/null 2>&1 || echo "yq must be installed"

if [ "$#" -ne 2 ]; then
  echo "usage $0 <service_name> <imageWithTag>"
  exit 1
fi

# Image names are lowercase.
imageWithTag=$(echo $2 | tr '[:upper:]' '[:lower:]')

yq eval -ie ".spec.template.spec.containers[0].image = \"$imageWithTag\"" $1/deployment.yaml
