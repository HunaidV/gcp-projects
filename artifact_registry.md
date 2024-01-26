#
Artifact Repository

## Tutorial

1. Create repositories for docker containers.
2. Manage images with it.
3. Use cloud code with artifact repository
4. Configure Maven to use for Java Dependencies

We are going to use Cloud Shell in GCP

Set PROJECT_ID, PROJECT_NUMBER, REGION in gcp configuration

Enable below services for google api


    gcloud services enable 
    cloudresourcemanager.googleapis.com 
    container.googleapis.com 
    artifactregistry.googleapis.com 
    containerregistry.googleapis.com 
    containerscanning.googleapis.com




1