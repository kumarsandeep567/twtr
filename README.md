# twtr
A dummy tweeting app using three microservices.

## Build Status
![](https://codebuild.us-east-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiZC8wWTBjdHNxajYvVTQxd0lObnFQalVVdDRDWkZ0SXAvT2ZONnJnbE9nV0FSa3lqcklGK2FnV2tVRStyT1BOaXRVMmRCMHhBQzlnZE8yZnQydVppYnR3PSIsIml2UGFyYW1ldGVyU3BlYyI6Im5nd04xcXpORlo3NllyMTEiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=main)

## Overview
This project is about a simple tweeting application built with three microservices, each containerized and deployed on a cluster using AWS Elastic Container Service, incorporating Continuous Integration and Continuous Deployment (CI/CD) via AWS CodeBuild and Terraform.

## Microservices

1.  **Frontend Microservice**
-  Build using React, running on port 80
2.  **Backend Microservice**
-  Build using Flask, running on port 5000
3.  **Database Microservice**
-  Build using MongoDB, running on port 27017

## Deployment Architecture
Each microservice is containerized using Docker and deployed on AWS infrastructure. The deployment process is automated using AWS CodeBuild and Terraform.

### Deployment Steps
1.  **Code Push and Build Trigger:**
- Pushing code to GitHub triggers the build process on AWS CodeBuild.
2.  **CodeBuild Environment Setup:**
- Docker and its dependencies are installed.
3.  **Docker Image Creation:**
- Docker images are created for each microservice.
- Images are pushed to AWS Elastic Container Registry (ECR).
4.  **Target Group Configuration:**
- On the AWS EC2 console, target groups are created for each microservice.
- The database microservice is placed behind a Network Load Balancer (Protocol: TCP, External Port: 27017).
- The frontend and backend microservices are placed behind an Application Load Balancer (Protocol: HTTP, External Port: 80).
5.  **Cluster and Scaling Setup:**
- A cluster is created comprising 3 services running on AWS ECS instances.
- An automatic scaling group with a Target Tracking Scaling Policy is configured to handle scaling based on traffic load.
6.  **Infrastructure as Code (with Hashicorp Terraform):**
- Everything from creating the load balancers, target groups, virtual private cloud, log groups, task definitions, services, and clusters is automated using Terraform.

## Build instructions
Follow these instructions to build and deploy this project.
  
0.  **Clone the repository:**
- Get started by cloning the repository using `git`
`git clone https://github.com/kumarsandeep567/twtr.git`

1.  **Setup AWS CodeBuild**
*Prerequisites: Clone the repository, make changes as needed, and push to your Github account*
- Go to [AWS CodeBuild](https://aws.amazon.com/codebuild/) and sign in to your AWS account
- Create a new project with the following details:
	- **Project Configuration:**
-- Project name: twtr-build
-- Description: Build and deploy twtr docker images *(optional)*
-- Build badge: Enabled *(optional, enable if you wish to show a 'Build: Passing' or 'Build: Failing' badge on your project's `README.md` file)*
	- **Source Configuration:**
-- Source provider: GitHub
-- Repository: Repository in my GitHub account
-- GitHub repository: `<YOUR_GITHUB_REPO_URL.git>`
-- Connection status: Connected to GitHub using OAuth *(You will need to sign in to your GitHub account and provide necessary access to AWS CodeBuild)*
-- Git clone depth: 1 *(optional)*
-- Build Status: Enable Report build statuses to source provider when your builds start and finish *(optional, enable if you wish to show a 'check mark' on your repository to show build status)*
	- **Primary Source Webhook Events:**
-- Webhook: Enable Rebuild every time a code change is pushed to this repository *(optional)*
-- Build type: Single build
-- Webhook event filter groups:
-- Filter group 1:
-- Event type: PUSH *(optional)*
	- **Environment Configuration:**
	-- Provisioning model Info: On-demand
	-- Environment image: Managed image
	-- Compute: EC2
	-- Operating system: Ubuntu
	-- Runtime(s): Standard
	-- Image: `aws/codebuild/standard:7.0`
	-- Image version: Always use the latest image for this runtime version
	-- Timeout: 30 Minutes
	-- Queued timeout: 1 Hour
	-- Privileged: Enabled
	-- Certificate: Do not install any certificate
	-- VPC: *(Leave empty)*
	-- Compute: 3 GB memory, 2 vCPUs
	- **Environment Variables:**
	-- Name: `AWS_ACCOUNT_ID`
	-- - Value: `<PROVIDE_YOUR_AWS_ACCOUNT_ID_HERE>`
	-- - Type: Plaintext
	-- Name: `AWS_REGION`
	-- - Value: `<PROVIDE_YOUR_AWS_REGION_HERE>`
	-- - Type: Plaintext
	- **Buildspec:**
	-- Build specifications: Use a buildspec file
	-- Buildspec name: `buildspec.yml` *(optional, default)*
	- **Logs:**
	-- CloudWatch logs: Enabled
	-- Group name: `codebuild-twtr-build`

- Click Create Project and you're all done! 🎉
- *(Before starting/triggering the build, **setup AWS Elastic Container Registry**)*

2. **Setup AWS Elastic Container Registry (ECR)**
- *Why?* The `buildspec.yml` will install Docker to build docker images during the build process on CodeBuild. We need these docker images to create our services on AWS Elastic Container Service (ECS). For simplicity, we'll store these images on AWS ECR.
- Go to [Amazon Elastic Container Registry (AWS ECR)](https://aws.amazon.com/ecr/) and sign in to your AWS account
- Select Private registry under the Repositories section and use the following details:
	- **General settings:**
	-- Visibility settings: Private *(or public, if needed)*
	-- Repository name: `twtr-db`
- Repeat the steps to create two additional repositories named `twtr-be` and `twtr-fe` respectively.
- The image for database service will be stored in `twtr-db` and the images for backend and frontend will be stored in `twtr-be` and `twtr-fe`  respectively.

3. **Setup IAM roles for AWS CodeBuild**
- In order to store the images in AWS ECR, CodeBuild needs the permissions to do so. 
- After creating the project on CodeBuild, navigate to your project on the Build Projects page, and click on the Service Role link *(which looks something like this; `arn:aws:iam::xxxxxx:role/service-role/xxxxxxxx`)* _(You will be directed to the IAM Roles page)_
- Under Permissions policies, click on 'Add Permissions' and then 'Attach Policies'
- Search for the following roles and add them:
``AmazonCloudWatchEvidentlyFullAccess``
``AmazonEC2ContainerRegistryFullAccess``
``AmazonEC2ContainerRegistryReadOnly``
``CloudWatchEventsFullAccess``
``CloudWatchLogsFullAccess``
``EC2InstanceProfileForImageBuilderECRContainer``

4. **Start the Build process!**
- Push changes to your Github repository to trigger the build process
- Alternatively, you can manually start the build process by clicking on the Start Build on your CodeBuild project.
---
*Where is my badge URL?*
After creating the project on CodeBuild, within the same project, click on Project Details and you'll see the 'copy badge URL' button.

---
🎉🎉
A fully functional build pipeline that builds the Docker images every time there is a code change pushed to your GitHub repository is ready.


## Deploy instructions

To begin the deployment process, 
1. Provide your AWS access key and secret key in the `terraform.tfvars` file (which looks like this)
	```
	# ===================== AWS Credentials ===========================
	user_credentials = {
		access_key = "PROVIDE_YOUR_ACCESS_KEY_HERE"
		secret_key = "PROVIDE_YOUR_SECRET_KEY_HERE"
	}
	```
2. Provide the urls for the container images in the `terraform.tfvars` file (which looks like this)
	```
	# Database task definition
	database_task_definition    = {
	    container_name          = "database_container"
	    container_image         = "PROVIDE_YOUR_DATABASE_IMAGE_URL_HERE"
	}

	# Backend task definition
	backend_task_definition     = {
	    container_name          = "backend_container"
	    container_image         = "PROVIDE_YOUR_BACKEND_IMAGE_URL_HERE"
	}

	# Frontend task definition
	frontend_task_definition    = {
	    container_name          = "frontend_container"
	    container_image         = "PROVIDE_YOUR_FRONTEND_IMAGE_URL_HERE"
	}
	```

- To get the image urls, go to [AWS ECR](https://aws.amazon.com/ecr/), select the `twtr-db` repository, and under Image URI, click on Copy URI, and provide the URI in the `terraform.tfvars` file. Repeat the step for `twtr-be` and `twtr-fe` .
- To deploy, simply run `terraform apply`.
- After deployment is complete, use the `twtr-application-lb` load balancer's DNS name to view the frontend. 
- To interact with the MongoDB database via `mongosh`, use the `twtr-network-lb`  load balancer's DNS name.
- To retract (or destroy) the deployment, simply run `terraform destroy`.