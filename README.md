@'
# Urban Fantasy GitOps Infrastructure

Infrastructure-as-Code and cloud platform for the Urban Fantasy GitOps project.

The environment was provisioned using Terraform on AWS and integrates Amazon EKS, Jenkins, ArgoCD, NGINX Ingress, AWS Systems Manager, Prometheus, and Grafana.

## Architecture

```text
Developer / GitHub
        |
        v
    Jenkins CI
        |
        +----> Docker Hub
        |
        +----> Updates Kubernetes image tags in Git
                         |
                         v
                      ArgoCD
                         |
                         v
                    Amazon EKS

Internet
   |
   v
EC2 NGINX Gateway
   |
   | TCP 30080
   v
EKS NodePort
   |
   v
NGINX Ingress Controller
   |
   +---- / ----------> Frontend Service ----> Frontend Pods
   |
   +---- /api/status -> Status API Service --> Status API Pod

Monitoring:
Node Exporter ---> Prometheus ---> Grafana

Terraform Infrastructure

Terraform provisions and manages:

Custom VPC
Two public subnets across Availability Zones
Internet Gateway and routing
Security Groups
IAM roles and instance profiles
Jenkins / NGINX EC2 instance
Monitoring EC2 instance
Amazon EKS cluster
EKS managed node group
Restricted NodePort security rule
CI/CD and GitOps

Jenkins handles Continuous Integration:

Checks out application code from GitHub.
Builds frontend and status API Docker images.
Pushes versioned images to Docker Hub.
Updates Kubernetes image tags in GitHub.

ArgoCD handles Continuous Delivery:

Watches Kubernetes manifests stored in Git.
Detects changes made by Jenkins.
Synchronizes the desired state to Amazon EKS.
Kubernetes performs the deployment automatically.

This keeps CI and CD separated.

Application Traffic

Traffic flow:

Internet → EC2 NGINX Gateway → EKS NodePort 30080 → NGINX Ingress Controller → Kubernetes Service → Application Pods

NGINX Ingress routes:

/ → Frontend service
/api/status → Status API service

The NodePort architecture was used because the AWS account used for the project had an account-level restriction preventing Elastic Load Balancer creation.

Security
EC2 administration uses AWS Systems Manager Session Manager.
SSH port 22 is not required.
Jenkins port 8080 is restricted to an administrator CIDR.
EKS NodePort 30080 accepts traffic only from the NGINX gateway security group.
Terraform state, variable files, credentials, environment files, and private keys are excluded from Git.
Monitoring

A dedicated monitoring EC2 instance runs:

Prometheus
Grafana

Node Exporter exposes infrastructure metrics to Prometheus, and Grafana provides dashboards for visualization.

Repository Structure

urban-fantasy-infra/
├── environments/
│   └── prod/
├── modules/
│   ├── vpc/
│   ├── security-groups/
│   ├── iam-roles/
│   ├── ec2-ingress/
│   ├── ec2-monitoring/
│   └── eks/
├── helm/
│   └── nginx-ingress-values.yaml
├── docs/
│   └── images/
├── .gitignore
└── README.md

Cost Management

The environment was created for portfolio and learning purposes. AWS infrastructure was destroyed after testing to avoid unnecessary cloud charges.

Project Evidence
Terraform Provisioning

EKS Multi-Service Deployment

Jenkins CI and GitOps Automation

ArgoCD Synchronization

NGINX Ingress and NodePort Routing

Status API

Monitoring

Keyless EC2 Administration