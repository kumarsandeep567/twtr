# twtr
A dummy tweeting app using three microservices.

## Overview
This project is about a simple tweeting application built with three microservices, each containerized and deployed on separate AWS EC2 instances. 

## Microservices
1. **Frontend Microservice**
   - **Technology:** React
   - **Port:** 80

2. **Backend Microservice**
   - **Technology:** Flask
   - **Port:** 5000

3. **Database Microservice**
   - **Technology:** MongoDB
   - **Port:** 27017

## Deployment Architecture
Each microservice is containerized using Docker and deployed on AWS infrastructure. The deployment process is automated using AWS CodeBuild and Terraform.

### Deployment Steps
1. **Code Push and Build Trigger:**
   - Pushing code to GitHub triggers the build process on AWS CodeBuild.

2. **CodeBuild Environment Setup:**
   - Docker and its dependencies are installed.

3. **Docker Image Creation:**
   - Docker images are created for each microservice.
   - Images are pushed to AWS Elastic Container Registry (ECR).

4. **Target Group Configuration:**
   - On the AWS EC2 console, target groups are created for each microservice.
   - The database microservice is placed behind a Network Load Balancer (Protocol: TCP, External Port: 27017).
   - The frontend and backend microservices are placed behind an Application Load Balancer (Protocol: HTTP, External Port: 80).

5. **Cluster and Scaling Setup:**
   - A cluster is created comprising 3 services, 3 tasks, and 3 EC2 instances.
   - An automatic scaling group with a Target Tracking Scaling Policy is configured to handle scaling based on traffic load.

## Purpose
This application serves as a learning project to understand Continuous Integration and Continuous Deployment (CI/CD) using AWS CodeBuild, AWS Elastic Container Service (ECS), and Terraform.

## Future Work
- **Terraform Files:** The Terraform files for infrastructure as code (IaC) will be uploaded soon.
