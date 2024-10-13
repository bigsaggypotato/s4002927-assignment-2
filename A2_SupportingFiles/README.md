# COSC2759 Assignment 2

## Student details

- Full Name: Victoria Hill
- Student ID: s4002927

## Solution Design
This project automates the deployment of the Foo app on AWS using Terraform for infrastructure provisioning and Ansible for configuration management. The architecture supports scalability and maintains security by controlling access through security groups. The Foo app is containerised using Docker and deployed on an EC2 instance.

## Infrastructure
- **AWS EC2**: The Foo app runs on an EC2 instance with the `t2.micro` instance type.
- **Docker**: The application is containerized using Docker to ensure consistency across environments.
- **Security Groups**: Configured to allow SSH (port 22) and HTTP (port 80) access.
- **Elastic IP**: Optionally, an Elastic IP can be assigned to the EC2 instance to maintain a static IP address for the app.

## Key Data Flows
1. **User Requests**: Users access the Foo app via the public IP address of the EC2 instance using HTTP requests.
2. **Application Response**: The application processes requests and serves responses back to users.
3. **Database Interaction**: The app communicates with a PostgreSQL database (if implemented) to store and retrieve data.

## Deployment Process
1. **Infrastructure Provisioning**: Terraform initialises the AWS environment, creates the necessary resources, and provisions an EC2 instance.
2. **Application Setup**: Ansible installs Docker on the instance, pulls the Foo app Docker image, and runs the container.
3. **Testing**: After deployment, validate that the app is accessible and functioning as expected.

## Prerequisites
- An **AWS account** with appropriate permissions.
- **AWS CLI** installed and configured with valid credentials (`aws configure`).
- **Terraform** installed on your local machine.
- **Ansible** installed on your local machine.
- **SSH Key Pair** for connecting to the EC2 instance.

## Description of the GitHub Actions Workflow
The GitHub Actions workflow automates the deployment process:
- **Trigger**: The workflow runs whenever changes are pushed to the `main` branch.
- **Steps**:
  1. Check out the repository code.
  2. Set up Terraform.
  3. Run `terraform apply` to provision the infrastructure.
  4. Retrieve the public IP address of the EC2 instance.
  5. Execute the Ansible playbook to configure the instance and deploy the Foo app.

## Backup Process: Deploying from a Shell Script
The backup process utilizes a shell script (`deploy.sh`) to automate:
- Terraform initialisation and apply commands to create infrastructure.
- Ansible playbook execution to set up the application.
This script can be executed anytime to re-deploy the app or create a new environment.

## Validating that the App is Working
To ensure that the Foo app is functioning correctly after deployment:
1. Access the application via the public IP address of the EC2 instance in a web browser: `http://3.81.169.60`.
2. Check that the application responds correctly to requests.
3. Review logs in the EC2 instance to diagnose any issues.

## Contents of this Repo
- `main.tf`: Terraform configuration file for AWS infrastructure.
- `deploy.yml`: Ansible playbook for application deployment.
- `deploy.sh`: Shell script to automate the deployment process.
- `README.md`: Documentation for the project.




