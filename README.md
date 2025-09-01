# Kamrup.AI Infrastructure

This repository contains the infrastructure code for Kamrup.AI. It includes a Docker-based local development environment and Terraform code for deploying the infrastructure to AWS.

## Overview

The infrastructure consists of the following components:
- A PostgreSQL database for data storage.
- A Redis instance for caching and messaging.
- An S3-compatible object storage for file uploads and processing.
- A secure and scalable network architecture on AWS.

## Local Development Setup

A script is provided to automate the setup of the local development environment using Docker.

### Prerequisites

- [Docker](https://www.docker.com/get-started) must be installed and running.

### Instructions

1.  Clone this repository to your local machine.
2.  Navigate to the `scripts` directory:
    ```bash
    cd scripts
    ```
3.  Run the setup script:
    ```bash
    ./setup-dev.sh
    ```
The script will start all the necessary services in Docker containers and create the required MinIO buckets.

## Services

The local development environment includes the following services:

| Service         | URL                                                | Credentials (user/password) |
| --------------- | -------------------------------------------------- | --------------------------- |
| PostgreSQL      | `localhost:5432`                                   | `kamrup`/`dev_password_123`   |
| Redis           | `localhost:6379`                                   | N/A                         |
| MinIO           | `http://localhost:9000`                            | `minioadmin`/`minioadmin123`  |
| MinIO Console   | `http://localhost:9001`                            | `minioadmin`/`minioadmin123`  |
| Adminer         | `http://localhost:8080`                            | -                           |

### Connection Strings

-   **Database URL**: `postgresql://kamrup:dev_password_123@localhost:5432/kamrup_dev`
-   **Redis URL**: `redis://localhost:6379`
-   **S3 Endpoint**: `http://localhost:9000`

## Deployment

The infrastructure is managed with Terraform and can be deployed to AWS using the provided script.

### Prerequisites

-   [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) must be installed.
-   AWS credentials must be configured in your environment.

### Instructions

1.  Navigate to the `scripts` directory:
    ```bash
    cd scripts
    ```
2.  Run the deployment script with the desired environment (e.g., `dev`):
    ```bash
    ./deploy.sh dev
    ```
The script will prompt for confirmation before applying the Terraform plan.

## Infrastructure

The Terraform code in the `terraform/aws` directory defines the following AWS resources:

-   **VPC**: A virtual private cloud with public and private subnets.
-   **RDS**: A PostgreSQL database instance.
-   **ElastiCache**: A Redis instance.
-   **S3**: Buckets for asset storage, uploads, and processed files.
-   **Security Groups**: Rules to control traffic to the resources.
