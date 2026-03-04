# eks-devsecops-lab-infra

Infrastructure repository for the **EKS DevSecOps Lab**.

This project aims to build a **production-like Kubernetes platform on AWS** while applying **DevSecOps best practices**,
with a strong focus on reproducibility, security, and cost control.

This repository contains the **Infrastructure as Code (IaC)** used to provision the cloud infrastructure required for
the lab.

---

# Project Goals

The goal of this lab is to design and operate a **secure Kubernetes platform** similar to what would be deployed in a
real company environment.

Key goals:

- Build a **production-like AWS EKS platform**
- Apply **DevSecOps best practices**
- Ensure **full infrastructure reproducibility**
- Implement **secure supply chain principles**
- Keep the infrastructure **cost-efficient**
- Use the project as a **public technical portfolio**

---

# Repository Scope

This repository is responsible for provisioning and managing the **AWS infrastructure layer**.

Managed resources include:

- VPC and networking
- Amazon EKS cluster
- Managed node groups
- Amazon ECR registry
- IAM roles and policies
- OIDC federation for GitHub Actions
- Terraform remote state (S3 + DynamoDB)

Application deployment is **not handled here**.

Applications are deployed using **GitOps** via the dedicated repository:

eks-devsecops-lab-gitops

---

# Architecture (Phase 1)

Initial infrastructure design focuses on simplicity, security, and cost optimization.

Components:

- AWS VPC
- Private subnets across multiple availability zones
- Amazon EKS cluster
- Managed node group
- Amazon ECR registry
- Terraform remote state backend

Later phases will introduce:

- ArgoCD (GitOps deployment)
- Kyverno policies
- RBAC design
- NetworkPolicies
- External Secrets
- Supply chain security (SBOM, image signing)

---

# Cost Control Strategy

Since this project runs on **limited AWS credits**, cost optimization is a key requirement.

Measures implemented:

- No NAT Gateway in the initial phase
- Minimal node group sizing
- Resources destroyed when not used
- Mandatory tagging for all resources
- Infrastructure is created only when needed

Estimated cost target:

< $2/day

---

# Security Principles

This project follows several **DevSecOps principles**:

- No long-lived AWS credentials are stored in repositories
- Authentication from CI via **OIDC federation**
- Infrastructure managed only via **Terraform / Terragrunt**
- Least privilege IAM policies
- Encrypted Terraform state
- Locked Terraform state using DynamoDB
- Public repositories with **no secrets**

---

# Repository Structure

eks-devsecops-lab-infra/

modules/  
Terraform modules

live/  
dev/  
terragrunt.hcl  
vpc/terragrunt.hcl  
eks/terragrunt.hcl  
ecr/terragrunt.hcl

The repository follows a **Terragrunt environment structure** to keep infrastructure modular and maintainable.

---

# Prerequisites

Required tools:

- AWS CLI
- Terraform or OpenTofu
- Terragrunt
- kubectl (later phases)
- Git

---

# How to Use

Initialize the project:

terragrunt run-all init

Preview infrastructure changes:

terragrunt run-all plan

Apply infrastructure:

terragrunt run-all apply

Destroy infrastructure:

terragrunt run-all destroy

---

# Naming Convention

All resources follow the same naming convention:

project-env-resource

Example:

eks-devsecops-lab-dev-vpc  
eks-devsecops-lab-dev-eks  
eks-devsecops-lab-dev-ecr

---

# AWS Resource Tags

All resources are tagged using the following structure:

Project = eks-devsecops-lab  
Env = dev  
Owner = sylvain  
ManagedBy = terraform

---

# Related Repositories

Infrastructure is only one part of the lab.

Application repository:

eks-devsecops-lab-app

Contains:

- Demo application (Go)
- Dockerfile
- CI pipeline
- Security scans
- SBOM generation
- Image signing

GitOps repository:

eks-devsecops-lab-gitops

Contains:

- Kubernetes manifests
- Kustomize configuration
- ArgoCD applications
- Kyverno policies
- RBAC configuration
- Network policies

Documentation repository:

eks-devsecops-lab-docs

Contains:

- Architecture diagrams
- Architecture Decision Records (ADR)
- Security design documentation
- Incident simulations

---

# Roadmap

Phase 1 — Infrastructure Bootstrap

- Terraform state backend
- VPC
- EKS cluster
- Node groups
- ECR

Phase 2 — GitOps

- ArgoCD installation
- GitOps deployment model

Phase 3 — Supply Chain Security

- Trivy scanning
- SBOM generation
- Image signing with Cosign

Phase 4 — Kubernetes Security

- Kyverno policies
- RBAC design
- NetworkPolicies
- Secret management

---

# Disclaimer

This project is a **personal DevSecOps lab** used for experimentation, learning, and portfolio purposes.

It is designed to simulate **real-world consulting scenarios** and platform engineering practices.
