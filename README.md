# eks-devsecops-lab-infra

Infrastructure repository for the **EKS DevSecOps Lab**.

This repository contains the **Infrastructure as Code (IaC)** used to
provision a modern AWS-based Kubernetes platform for learning,
experimentation, and portfolio purposes.

------------------------------------------------------------------------

## Project Goals

The goal of this lab is to design and operate a **production-like AWS
EKS platform** while applying modern **DevSecOps** and **platform
engineering** practices.

Key goals:

- Build a **production-like AWS EKS platform**
- Apply **DevSecOps best practices**
- Ensure **full infrastructure reproducibility**
- Keep the infrastructure **cost-efficient**
- Use the project as a **public technical portfolio**
- Always use the **latest stable versions** of systems, tooling, and
  documentation

------------------------------------------------------------------------

## Repository Scope

This repository is responsible for provisioning and managing the **AWS
infrastructure layer**.

Managed resources include:

- VPC and networking
- Amazon EKS cluster
- Managed node groups
- Amazon ECR registry
- IAM roles and policies
- OIDC federation for GitHub Actions
- Terraform remote state (S3 + DynamoDB)

Application deployment is **not handled here**. Applications are
deployed using **GitOps** via the dedicated repository:

- `eks-devsecops-lab-gitops`

------------------------------------------------------------------------

## Current Architecture

The current infrastructure design focuses on **simplicity, reliability,
security, and cost control**.

### Components currently managed

- AWS VPC
- Public and private subnets across multiple Availability Zones
- One **NAT Gateway** for outbound internet access from private
  workloads
- One **S3 Gateway Endpoint** to reduce NAT traffic
- Amazon EKS cluster
- Managed node group
- Terraform remote state backend (S3 + DynamoDB)

### Later phases

Later phases will introduce:

- Amazon ECR
- GitHub Actions OIDC federation
- ArgoCD
- Kyverno
- RBAC
- NetworkPolicies
- External Secrets
- Supply chain security (SBOM, signing, scanning)

------------------------------------------------------------------------

## Cost Control Strategy

Since this project runs on **limited AWS credits**, cost optimization is
a key requirement.

Measures implemented:

- **Single NAT Gateway** instead of one NAT per AZ
- **S3 Gateway Endpoint** to reduce NAT usage
- Minimal node group sizing
- Resources destroyed when not used
- Mandatory tagging for all resources
- Infrastructure created only when needed

------------------------------------------------------------------------

## Security Principles

This project follows several **DevSecOps principles**:

- No long-lived AWS credentials stored in repositories
- Authentication from CI via **OIDC federation**
- Infrastructure managed only via **Terraform / Terragrunt**
- Least privilege IAM policies
- Encrypted Terraform state
- Terraform state locking with DynamoDB
- Public repositories with **no secrets**

------------------------------------------------------------------------

## Repository Structure

``` text
eks-devsecops-lab-infra/
├── modules/
│   ├── vpc/
│   ├── eks/
│   └── ecr/
└── live/
    └── dev/
        ├── root.hcl
        ├── vpc/
        │   └── terragrunt.hcl
        ├── eks/
        │   └── terragrunt.hcl
        └── ecr/
            └── terragrunt.hcl
```

------------------------------------------------------------------------

## Prerequisites

Required tools:

- AWS CLI
- Terraform or OpenTofu
- Terragrunt
- kubectl
- Git

------------------------------------------------------------------------

## How to Use

Initialize all stacks:

``` bash
terragrunt run --all init
```

Preview infrastructure changes:

``` bash
terragrunt run --all plan
```

Apply infrastructure:

``` bash
terragrunt run --all apply
```

Destroy infrastructure:

``` bash
terragrunt run --all destroy
```

------------------------------------------------------------------------

## Naming Convention

Resources use **short, AWS-safe names** when necessary to avoid IAM and
EKS naming limits.

Examples:

- `eks-devsecops-lab-dev-vpc`
- `eksdsl-dev`
- `eksdsl-dev-workers`

------------------------------------------------------------------------

## AWS Resource Tags

All resources are tagged using the following structure:

Project = eks-devsecops-lab Env = dev ManagedBy = terraform

------------------------------------------------------------------------

## Related Repositories

### Application repository

`eks-devsecops-lab-app`

Contains:

- demo application
- Dockerfile
- CI pipeline
- security scans
- SBOM generation
- image signing

### GitOps repository

`eks-devsecops-lab-gitops`

Contains:

- Kubernetes manifests
- Kustomize configuration
- ArgoCD applications
- Kyverno policies
- RBAC configuration
- Network policies

### Documentation repository

`eks-devsecops-lab-docs`

Contains:

- architecture diagrams
- ADRs
- security design documentation
- incident simulations

------------------------------------------------------------------------

## Roadmap

### Phase 1 --- Infrastructure Bootstrap

- Terraform state backend
- VPC
- EKS cluster
- Node groups
- ECR

### Phase 2 --- GitOps

- ArgoCD installation
- GitOps deployment model

### Phase 3 --- Supply Chain Security

- Trivy scanning
- SBOM generation
- Image signing with Cosign

### Phase 4 --- Kubernetes Security

- Kyverno policies
- RBAC
- NetworkPolicies
- Secret management

------------------------------------------------------------------------

## Disclaimer

This project is a **personal DevSecOps lab** used for experimentation,
learning, and portfolio purposes.

It is designed to simulate **real-world consulting scenarios** and
platform engineering practices.
