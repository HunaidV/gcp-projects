#!/usr/bin/env bash


# "---------------------------------------------------------"
# "-                                                       -"
# "-  Common functions                                     -"
# "-                                                       -"
# "---------------------------------------------------------"

# Enable required API's that are not already enabled
# Globals:
#   None
# Arguments:
#   PROJECT
#   API
# Returns:
#   None
function enable_project_api() {
  # Check if the API is already enabled for the sake of speed
  if [[ $(gcloud services list --project="${1}" \
                                --format="value(serviceConfig.name)" \
                                --filter="serviceConfig.name:${2}" 2>&1) != \
                                "${2}" ]]; then
    echo "Enabling the API ${2}"
    gcloud services enable "${2}" --project="${1}"
  else
    echo "The API ${2} is already enabled for project ${1}"
  fi
}

# "---------------------------------------------------------"
# "-                                                       -"
# "-  Common commands for all scripts                      -"
# "-                                                       -"
# "---------------------------------------------------------"

# gcloud and kubectl are required for this POC
command -v gcloud >/dev/null 2>&1 || { \
 echo >&2 "I require gcloud but it's not installed.  Aborting."; exit 1; }
command -v kubectl >/dev/null 2>&1 || { \
 echo >&2 "I require kubectl but it's not installed.  Aborting."; exit 1; }

usage() { echo "Usage: $0 [-c <cluster name>]" 1>&2; exit 1; }

# parse -c flag for the CLUSTER_NAME using getopts
while getopts ":c:" opt; do
  case ${opt} in
    c)
      CLUSTER_NAME=$OPTARG
      ;;
    \?)
      echo "Invalid flag on command line: $OPTARG" 1>&2
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND -1))

# If user did not pass in -c flag then fail
if [ -z "${CLUSTER_NAME}" ]; then
    usage
fi

# Get the default zone and use it or die
ZONE=$(gcloud config get-value compute/zone)
if [ -z "${ZONE}" ]; then
    echo "gcloud cli must be configured with a default zone." 1>&2
    echo "run 'gcloud config set compute/zone ZONE'." 1>&2
    echo "replace 'ZONE' with the zone name like us-west1-a." 1>&2
    exit 1;
fi

#Get the default region and use it or die
REGION=$(gcloud config get-value compute/region)
if [ -z "${REGION}" ]; then
    echo "gcloud cli must be configured with a default region." 1>&2
    echo "run 'gcloud config set compute/region REGION'." 1>&2
    echo "replace 'REGION' with the region name like us-west1." 1>&2
    exit 1;
fi

#Get the current project and use it or die
PROJECT=$(gcloud config get-value project)
if [ -z "${PROJECT}" ]; then
    echo "gcloud cli must be configured with an existing project." 1>&2
    echo "run 'gcloud config set project PROJECTNAME'." 1>&2
    echo "replace 'PROJECTNAME' with the project name like my-demo-project." 1>&2
    exit 1;
fi



