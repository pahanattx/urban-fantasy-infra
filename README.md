\# Urban Fantasy GitOps Infrastructure



Infrastructure-as-Code and cloud platform for the Urban Fantasy GitOps project.



The environment was provisioned using Terraform on AWS and integrates Amazon EKS, Jenkins, ArgoCD, NGINX Ingress, AWS Systems Manager, Prometheus, and Grafana.



\## Architecture



```text

Developer / GitHub

&#x20;       |

&#x20;       v

&#x20;  Jenkins CI

&#x20;       |

&#x20;       +----> Docker Hub

&#x20;       |

&#x20;       +----> Updates Kubernetes image tags in Git

&#x20;                        |

&#x20;                        v

&#x20;                     ArgoCD

&#x20;                        |

&#x20;                        v

&#x20;                   Amazon EKS





Internet

&#x20;  |

&#x20;  v

EC2 NGINX Gateway

&#x20;  |

&#x20;  | TCP 30080

&#x20;  v

EKS NodePort

&#x20;  |

&#x20;  v

NGINX Ingress Controller

&#x20;  |

&#x20;  +---- / ----------> Frontend Service ----> Frontend Pods

&#x20;  |

&#x20;  +---- /api/status -> Status API Service --> Status API Pod





Monitoring:

Node Exporter ---> Prometheus ---> Grafana

Terraform Infrastructure



Terraform provisions and manages:



Custom VPC

Two public subnets across Availability Zones

Internet Gateway

Route tables

Security Groups

IAM roles and instance profiles

Jenkins / NGINX EC2 instance

Monitoring EC2 instance

Amazon EKS cluster

EKS managed node group

NodePort security rule

CI/CD and GitOps



Jenkins handles Continuous Integration:



Checks out application code from GitHub.

Builds frontend and status API Docker images.

Pushes versioned images to Docker Hub.

Updates Kubernetes image tags in GitHub.



ArgoCD handles Continuous Delivery:



Watches the Kubernetes manifests stored in Git.

Detects changes made by Jenkins.

Synchronizes the desired state to Amazon EKS.

Kubernetes performs the deployment automatically.



This keeps CI and CD separated.



Application Traffic



Traffic follows this path:



Internet → EC2 NGINX Gateway → EKS NodePort 30080 → NGINX Ingress Controller → Kubernetes Service → Application Pods



NGINX Ingress routes:



/ to the frontend service

/api/status to the status API service



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

├── .gitignore

└── README.md

Cost Management



The infrastructure was designed as a portfolio and learning environment.



Resources can be stopped or destroyed when not required to prevent unnecessary AWS charges.

