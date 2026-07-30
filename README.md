# Amazon EKS Disaster Recovery (DR) Setup using Terraform, Velero & AWS S3

## Overview

This project provisions a production-ready Amazon EKS Disaster Recovery (DR) environment using Terraform. It demonstrates how to automate Kubernetes backup and restore operations with Velero while storing backups in Amazon S3.

The solution follows Infrastructure as Code (IaC) principles, allowing complete recreation of Kubernetes infrastructure and workloads in the event of a disaster.

---

## Architecture

```
                +-----------------------------+
                |     Terraform IaC           |
                +-------------+---------------+
                              |
                              |
                  Creates AWS Infrastructure
                              |
        +---------------------+---------------------+
        |                                           |
+-------------------+                   +-------------------+
|      VPC          |                   |     IAM Roles     |
+-------------------+                   +-------------------+
                  |
                  |
          +---------------+
          | Amazon EKS    |
          | Cluster        |
          +-------+-------+
                  |
        ------------------------
        |                      |
        | Helm                |
        |                      |
+----------------+     +----------------------+
| Velero         |---->| Amazon S3 Bucket     |
| Backup Agent   |     | Stores Backups       |
+----------------+     +----------------------+
        |
        |
Backs up:
- Kubernetes Resources
- Persistent Volumes
- Namespaces
- Secrets
- ConfigMaps
- Deployments
```

---

# Features

- Infrastructure provisioning using Terraform
- Amazon EKS Cluster deployment
- Custom VPC creation
- Managed Node Groups
- IAM Roles for Service Accounts (IRSA)
- Velero installation using Helm
- Amazon S3 backup storage
- Automated Kubernetes backup
- Restore workloads during Disaster Recovery
- Production-ready modular Terraform code

---

# Repository Structure

```
.
├── addons.tf
├── bastion.tf
├── eks.tf
├── providers.tf
├── variables.tf
├── vpc.tf
├── outputs.tf
├── versions.tf
├── terraform.tfvars
└── README.md
```

---

# Technologies Used

- Terraform
- Amazon EKS
- Amazon VPC
- IAM
- Helm Provider
- Kubernetes Provider
- Velero
- Amazon S3

---

# Prerequisites

Install the following tools before deployment.

| Tool | Version |
|-------|----------|
| Terraform | >= 1.6 |
| AWS CLI | Latest |
| kubectl | Compatible with EKS |
| Helm | Latest |

---

# AWS Resources Created

- VPC
- Public Subnets
- Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups
- Amazon EKS Cluster
- Managed Node Group
- IAM Roles
- OIDC Provider
- S3 Bucket (Velero Backup)
- Velero Deployment

---

# Deployment Steps

## 1. Clone Repository

```bash
git clone <repository-url>

cd eks-cluster-DR-Setup-Backup-Restore-Patterns-terraform
```

---

## 2. Initialize Terraform

```bash
terraform init
```

---

## 3. Review Execution Plan

```bash
terraform plan
```

---

## 4. Deploy Infrastructure

```bash
terraform apply
```

---

## 5. Configure kubectl

```bash
aws eks update-kubeconfig \
--region <region> \
--name <cluster-name>
```

---

## Verify Cluster

```bash
kubectl get nodes
```

---

# Velero Installation

Velero is deployed automatically using the Terraform Helm provider.

The deployment includes:

- Velero namespace
- Service Account
- IAM Role (IRSA)
- AWS Plugin
- BackupStorageLocation
- VolumeSnapshotLocation

---

# Backup Workflow

Velero captures:

- Namespaces
- Deployments
- Services
- Secrets
- ConfigMaps
- PVCs
- StatefulSets
- DaemonSets
- CRDs

Backup data is stored in Amazon S3.

---

# Create Backup

```bash
velero backup create daily-backup
```

Check backup status:

```bash
velero backup get
```

Describe backup:

```bash
velero backup describe daily-backup
```

---

# Restore Backup

List available backups:

```bash
velero backup get
```

Restore:

```bash
velero restore create \
--from-backup daily-backup
```

Check restore status:

```bash
velero restore get
```

---

# Disaster Recovery Process

## Scenario

Primary EKS cluster becomes unavailable.

### Recovery Steps

1. Deploy new EKS Cluster using Terraform
2. Install Velero
3. Connect Velero to existing S3 bucket
4. Restore backup
5. Verify workloads
6. Redirect traffic (if applicable)

Result:

- Applications restored
- Kubernetes objects recreated
- Persistent volumes recovered (if configured)
- Reduced Recovery Time Objective (RTO)

---

# Validation Commands

Check Nodes

```bash
kubectl get nodes
```

Check Pods

```bash
kubectl get pods -A
```

Check Velero

```bash
kubectl get pods -n velero
```

Check Backup

```bash
velero backup get
```

Check Restore

```bash
velero restore get
```

---

# Cleanup

Destroy all resources:

```bash
terraform destroy
```

---

# Best Practices

- Enable versioning on the S3 backup bucket.
- Encrypt backups using AWS KMS.
- Schedule automated backups with Velero.
- Test restore procedures regularly to validate Disaster Recovery readiness.
- Use IAM Roles for Service Accounts (IRSA) instead of static AWS credentials.
- Store Terraform state securely in a remote backend (e.g., Amazon S3 with DynamoDB state locking).
- Protect backup buckets with lifecycle policies and cross-Region replication for improved resilience.

---

# Future Enhancements

- Cross-Region Disaster Recovery
- Cross-Account Backup
- Automated Backup Scheduling
- Argo CD GitOps Integration
- Monitoring with Prometheus & Grafana
- Backup Notifications using Amazon SNS
- Automated DR Testing Pipeline
- Multi-Region Active/Passive Architecture

---

# References

- AWS Backup supports backing up EKS cluster resources and persistent storage, and can restore them to existing or newly created clusters. :contentReference[oaicite:0]{index=0}
- The Terraform AWS EKS module is the recommended community module for provisioning production-grade EKS clusters. :contentReference[oaicite:1]{index=1}
- AWS recommends regular DR testing, automated backups, and cross-Region recovery strategies for resilient EKS deployments. :contentReference[oaicite:2]{index=2}

---

# License

This project is intended for learning and demonstration purposes. Review and adapt the configuration to meet your organization's production security, networking, and compliance requirements before deploying in a live environment.