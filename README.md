# Reddit Clone Application

## Overview

[Reddit](https://www.reddit.com/) is a social news aggregation, web content rating, and discussion website. Users can submit content, such as text, links, and images, and participate in discussions through comments. This repository contains a clone of Reddit, designed to provide a similar experience with additional features and improvements.

The Reddit clone has been developed using **Next.js**, a popular React framework known for its server-side rendering and static site generation capabilities, which ensures high performance and SEO optimization.

## Project Description

This repository contains the infrastructure and CI/CD pipeline setup for deploying a **Reddit Clone Application** on an **Amazon EKS (Elastic Kubernetes Service) cluster** with Continuous Integration (CI) and Continuous Deployment (CD) pipelines managed through Jenkins and ArgoCD. The following outlines the infrastructure and processes involved:

### Architecture Overview

The architecture is designed to provide a seamless workflow for development, deployment, and scaling. Here’s a high-level representation of the project workflow:

![Architecture](snapshots/architecture.png)

### Infrastructure Setup

We are setting up the following infrastructure to support the CI/CD pipeline and monitoring tools:

- **4 EC2 instances**:

  - **Jenkins**: For CI/CD pipeline execution.
    - Install Trivy on Jenkins slave

```bash
rpm -ivh https://github.com/aquasecurity/trivy/releases/download/v0.41.0/trivy_0.41.0_Linux-64bit.rpm
```

- **SonarQube**: For static code analysis.
- **Prometheus & Grafana**: For monitoring Kubernetes cluster and application health.
- **ArgoCD**: For managing Kubernetes deployments and GitOps workflow.

- **Amazon EKS Cluster**: Hosting the application in a Kubernetes cluster.
- **IAM Roles and Permissions**:
  - Jenkins needs specific roles to interact with AWS services like EKS and S3.

## Jenkins CI/CD Pipeline

### 1. Jenkins Setup

**Prerequisites**:

- Install Jenkins with required plugins:
  - **Eclipse Temurin installer:** Provides an installer for the JDK tool that downloads the JDK from https://adoptium.net
  - **SonarQubeScanner:** This plugin allows an easy integration of SonarQube, the open source platform for Continuous Inspection of code quality.
  - **Sonar Quality Gates:** Fails the build whenever the Quality Gates criteria in the Sonar 5.6+ analysis aren't met (the project Quality Gates status is different than "Passed"
  - **Docker, Docker commons, Docker pipeline** for building and pushing container images
  - **Kubernetes** plugin for deploying on EKS

**Tools**:

- Jenkins is configured with all necessary tools like JDK, Docker, Kubernetes CLI, and more.

### 2. CI Pipeline Stages

The Jenkins pipeline for this project is divided into multiple stages to ensure a comprehensive CI process:

1. **Clean Workspace**: Ensures a fresh start for each pipeline run.
2. **Checkout Code**: Downloads the latest
3. **Lint Checks**: Performs linting to maintain code quality.
4. **File System Scanning (Trivy)**: Scans the workspace for security vulnerabilities and exports the report in JSON format.
5. **Code Quality Check (SonarQube)**: Executes SonarScanner to analyze the code quality.

   ![SonarQube Check](snapshots/sonar.png)

6. **Sonar Quality Gate**: Checks if the code meets the quality gate threshold.
7. **Build Docker Image**: Uses a pre-defined multi-stage `Dockerfile` to build the application.
8. **Docker Image Scanning (Trivy)**: Scans the Docker image for vulnerabilities and saves the report.
9. **Push Docker Image**: Pushes the built Docker image to DockerHub.

### 3. Snapshot of Overall Pipeline

Here’s a visual representation of the CI pipeline:

![Jenkins Pipeline](snapshots/jenkins.png)

### Post-Stages

Post-execution stages include:

- **Success/Failure Notifications**: Sends an email notification to the recipient with the pipeline result, along with Trivy security reports and build details.

### 3. CD Pipeline with ArgoCD

The CD (Continuous Deployment) process is handled by **ArgoCD**, which ensures automatic deployment to the Kubernetes cluster based on the latest Kubernetes manifests.

1. **Kubernetes Manifest Files**: The repository contains all the necessary Kubernetes manifest files required for deploying the Reddit clone application. These are stored in a separate Git repo for efficient management. For the Kubernetes manifest and ArgoCD configuration, refer to the [reddit-app-ArgoCD](https://github.com/Vikas-Prince/reddit-app-gitops.git) repository.
2. **ArgoCD Integration**: Automatically applies the Kubernetes manifests, keeping the application and infrastructure in sync with Git.

   ![ArgoCD](snapshots/argoCD.png)

### 4. Monitoring Setup (Prometheus & Grafana)

- **Prometheus**: Used for collecting metrics from the Kubernetes cluster and the application.
- **Grafana**: Visualizes the collected metrics in user-friendly dashboards to help monitor the application's health and the state of the Kubernetes cluster.

---

## Getting Started

To set up this application locally or on your own infrastructure, follow these steps:

1. Clone this repository.
2. Set up your EKS cluster.
3. Deploy Jenkins, SonarQube, and ArgoCD on the respective instances.
4. Configure Jenkins with the required plugins and tools.
5. Set up the CI/CD pipeline according to the defined stages.
6. Deploy your application using the provided Kubernetes manifest files through ArgoCD.

## Conclusion

This repository serves as a comprehensive guide to deploying a Reddit clone application with robust CI/CD practices. It showcases the integration of various tools to ensure a smooth development workflow, high code quality, and efficient deployment strategies.

For any questions or contributions, feel free to reach out or create a pull request!
