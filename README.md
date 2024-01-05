# Docker Compose in Greengrass

This repository is an example layout for building multiple Docker images and Greengrass components, where each component can contain a `docker-compose` file for referencing public Docker images or privately-hosted Docker images.

## Project Structure

This project contains the following:

1. `components` directory - each subdirectory in this directory contains the source code for a Greengrass component. The subdirectory name matches the component name.
2. `docker` directory - each subdirectory in this directory contains the source code for a Docker image. The subdirectory name matches the image name.
3. `.env` file - contains ECR repository variable and any user-defined environment variables for use during the build.
4. `build_all.sh` file - script to build all Greengrass components and Docker images.
5. `publish_all.sh` file - script to publish all Greengrass components and Docker images.

## Using the Projet

### Requirements

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [GDK](https://docs.aws.amazon.com/greengrass/v2/developerguide/install-greengrass-development-kit-cli.html)
- jq - `apt install jq`
- [docker](https://docs.docker.com/get-docker/)
- [docker-compose](https://docs.docker.com/compose/install/)

### Setup

#### Greengrass Permission 

As per the [Greengrass Docker documentation](https://docs.aws.amazon.com/greengrass/v2/developerguide/run-docker-container.html), the Greengrass device role may need extra policies attached for correct function.

To pull images hosted in private ECR repositories, add the following policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ],
      "Resource": [
        "*"
      ],
      "Effect": "Allow"
    }
  ]
}
```

In addition, to pull components stored in S3 buckets (including the Docker Compose file in this project), add the following policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "*"
      ],
      "Effect": "Allow"
    }
  ]
}
```

#### Elastic Container Registry

By default, this project pushes an image tagged `python-hello-world:latest` and expects an ECR repository of the same name to exist.
In the AWS console, create a new ECR repository with default options named `python-hello-world`. View the push commands and copy the base URL for the ECR repository into the `.env` file, replacing the `ECR_REPO` variable. For example:

```
ECR_REPO=012345678901.dkr.ecr.us-west-2.amazonaws.com
```

Note that the `python-hello-world:latest` has been stripped off to get the base URL.

A new ECR repository will be required for each Docker image pushed.

### Build

To build all components and images at once, run `./build_all.sh`. To build an individual component/image, change to its directory and run `source ../../.env && ./build.sh`.

### Publish

To publish all components at once, run `./publish_all.sh`.

To publish an individual Docker image, change to that image's directory and run `source ../../.env && ./publish.sh`.
To publish an individual Greengrass component, change to that component's directory and run `gdk component publish`.

### Deploy

From the AWS Console, select a deployment for a healthy Greengrass core device and deploy the latest version of the `com.docker.PythonHelloWorld` component.
On the local device, the logs will show that the component successfully sent and received a number of messages. Alternatively, the Debug Console can be used to view the messages being published and received live. However, the component starts up, publishes its messages, then stops; if no messages are appearing, ensure to run the component again.
