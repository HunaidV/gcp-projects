
#!/usr/bin/env bash

# "---------------------------------------------------------"
# "-                                                       -"
# "-  Creates a GKE Cluster                                -"
# "-                                                       -"
# "---------------------------------------------------------"

set -o errexit
set -o nounset
set -o pipefail

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CLUSTER_NAME=""
ZONE=""
GKE_VERSION=$(gcloud container get-server-config \
  --format="value(defaultClusterVersion)")

# shellcheck source=./common.sh
source "$ROOT/common.sh"

# Ensure the required APIs are enabled
enable_project_api "${PROJECT}" "compute.googleapis.com"
enable_project_api "${PROJECT}" "container.googleapis.com"
enable_project_api "${PROJECT}" "containerregistry.googleapis.com"
enable_project_api "${PROJECT}" "containeranalysis.googleapis.com"
enable_project_api "${PROJECT}" "binaryauthorization.googleapis.com"

# Create a 2-node zonal GKE cluster
# Requires the Beta API to enable binary authorization support
echo "Creating cluster"
gcloud beta container clusters create "$CLUSTER_NAME" \
  --zone "$ZONE" \
  --cluster-version "$GKE_VERSION" \
  --machine-type "n1-standard-1" \
  --num-nodes=2 \
  --no-enable-basic-auth \
  --no-issue-client-certificate \
  --enable-ip-alias \
  --metadata disable-legacy-endpoints=true \
  --enable-binauthz

# Get the kubectl credentials for the GKE cluster.
gcloud container clusters get-credentials "$CLUSTER_NAME" --zone "$ZONE"

