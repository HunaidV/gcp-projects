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

clone the google repo 

```
git clone https://github.com/GoogleCloudPlatform/cloud-code-samples/
cd ~/cloud-code-samples

```

Run the below gcloud command to start GKE cluster
```
gcloud container clusters create container-dev-cluster --zone=us-east1-d
```

## Artifact Repository

Artifact repository needs a format to which container image we are storing

```
gcloud artifacts repositories create container-dev-repo --repository-format=docker \
--location=$REGION \
--description="Docker repository for Hunaid's Dev Workshop"
```


change the directory to java/java-hello-world and build the container image

`docker build -t us-east1-docker.pkg.dev/qwiklabs-gcp-04-87e9ae61346a/container-dev-repo/java-hello-world:tag1 .`

Push it to Artifact repo

`docker push us-east1-docker.pkg.dev/qwiklabs-gcp-04-87e9ae61346a/container-dev-repo/java-hello-world:tag1`

Dockerfile as follow 

```
# Use maven to compile the java application.
FROM maven:3-jdk-11-slim AS build-env #build-env is an alis to this imagename

# Set the working directory to /app
WORKDIR /app

# copy the pom.xml file to download dependencies
COPY pom.xml ./

# download dependencies as specified in pom.xml
# building dependency layer early will speed up compile time when pom is unchanged
RUN mvn verify --fail-never

# Copy the rest of the working directory contents into the container
COPY . ./

# Compile the application.
RUN mvn -Dmaven.test.skip=true package

# Build runtime image.
FROM openjdk:11.0.16-jre-slim

# Copy the compiled files over.
COPY --from=build-env /app/target/ /app/

# Starts java app with debugging server at port 5005.
CMD ["java", "-jar", "/app/hello-world-1.0.0.jar"]
```

Run the codespace from java-hello-world
`cloudshell codespace .`

Once its open run it in GKE cluster using  Cloud Code on the lower left corner
