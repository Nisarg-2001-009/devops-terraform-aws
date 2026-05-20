# Project 5 — Infrastructure as Code with Terraform + LocalStack

> **Project 5 of 5** in my DevOps & Software Engineering Portfolio  
> Production-grade AWS infrastructure defined entirely in Terraform, running locally via LocalStack. Zero cost, identical real AWS code.

![Terraform](https://img.shields.io/badge/Terraform-1.10.5-7B42BC?logo=terraform) ![LocalStack](https://img.shields.io/badge/LocalStack-3.4-FF6B6B) ![AWS](https://img.shields.io/badge/AWS-Simulated-FF9900?logo=amazonaws) ![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker)

---

## What This Project Demonstrates

- **Infrastructure as Code** — every AWS resource defined in Terraform HCL, nothing clicked in a console
- **Modular Terraform architecture** — five reusable modules: networking, security, compute, database, storage
- **Remote state management** — S3 backend with DynamoDB locking, exactly as used in production
- **Least-privilege IAM** — EC2 role with only the permissions it needs, nothing else
- **Three-tier security model** — ALB SG → EC2 SG → RDS SG, each only accepting traffic from the previous tier
- **LocalStack** — full AWS API simulation locally, identical Terraform code to real AWS
- **terraform plan before every apply** — no exceptions, always reviewed before infrastructure changes

---

## Tech Stack

| Tool | Version | Purpose |
|---|---|---|
| Terraform | 1.10.5 | Infrastructure as Code — provisions all AWS resources |
| LocalStack | 3.4 | Local AWS simulation — intercepts all API calls on localhost:4566 |
| tflocal | 0.26.0 | Terraform wrapper — auto-points AWS provider at LocalStack |
| AWS Provider | 6.45.0 | Terraform plugin for AWS API |
| Docker Compose | v5.1.3 | Runs the LocalStack container |

---

## Infrastructure Provisioned

### Networking Module
- VPC with CIDR `10.0.0.0/16` and DNS hostnames enabled
- 2 public subnets across us-east-1a and us-east-1b (for ALB)
- 2 private subnets across us-east-1a and us-east-1b (for EC2 and RDS)
- Internet Gateway attached to public subnets
- Public route table routing `0.0.0.0/0` to IGW
- Private route table for internal traffic

### Security Module — Three-Tier Least Privilege
- **ALB Security Group** — accepts HTTP (80) and HTTPS (443) from `0.0.0.0/0`
- **EC2 Security Group** — accepts port 8000 from ALB SG only
- **RDS Security Group** — accepts port 5432 from EC2 SG only

### Compute Module
- EC2 `t2.micro` in private subnet with user_data startup script
- IAM Role with assume-role policy for EC2 service
- IAM Policy — CloudWatch Logs write + S3 GetObject on frontend bucket only
- IAM Instance Profile attached to EC2
- ALB in public subnets with HTTP listener and target group (architecture defined)

### Database Module
- RDS PostgreSQL `db.t3.micro` in private subnet (architecture defined, commented in code)
- DB subnet group spanning both private subnets
- No public access, skip final snapshot for dev

### Storage Module
- S3 bucket for React frontend static files
- Static website hosting with index.html and error document
- Public read bucket policy for `s3:GetObject`
- Public access block disabled for static hosting

### Bootstrap
- S3 bucket for Terraform remote state (`nisarg-terraform-state`)
- S3 bucket versioning and AES256 encryption
- DynamoDB table for state locking (`nisarg-terraform-locks`)

---

## Project Structure
```
devops-terraform-aws/
├── modules/
│   ├── networking/     ← VPC, subnets, IGW, route tables
│   ├── security/       ← ALB, EC2, RDS security groups
│   ├── compute/        ← EC2, IAM role/policy/profile, ALB
│   ├── database/       ← RDS PostgreSQL, subnet group
│   └── storage/        ← S3 frontend bucket, website config
├── environments/
│   └── staging/
│       ├── main.tf         ← Calls all modules, provider config
│       ├── variables.tf    ← Input variables
│       ├── outputs.tf      ← All module outputs
│       ├── backend.tf      ← S3 remote state + DynamoDB lock
│       └── terraform.tfvars← Variable values
├── bootstrap/
│   ├── main.tf         ← Creates state bucket + lock table
│   └── outputs.tf
├── docker-compose.yml  ← Runs LocalStack
└── README.md
```

---

## Quick Start

### Prerequisites
- Terraform >= 1.10
- Docker Desktop
- Python 3 (for tflocal and localstack CLI)

### Setup

```bash
git clone https://github.com/Nisarg-2001-009/devops-terraform-aws.git
cd devops-terraform-aws

# Install tools
pip install localstack terraform-local

# Configure fake credentials for LocalStack
mkdir -p ~/.aws
echo "[default]
aws_access_key_id = test
aws_secret_access_key = test" > ~/.aws/credentials

# Start LocalStack
docker compose up -d

# Bootstrap remote state
cd bootstrap
tflocal init
tflocal apply -auto-approve
cd ..

# Deploy staging environment
cd environments/staging
tflocal init
tflocal plan    # Always review before applying
tflocal apply -auto-approve

# Verify resources
tflocal output

# Destroy when done
tflocal destroy -auto-approve
```

---

## Terraform Workflow
```
tflocal init     → Download AWS provider, connect to LocalStack S3 backend
tflocal plan     → Diff .tf files against current state — always reviewed first
tflocal apply    → Create/update resources in LocalStack, write state to S3
tflocal output   → Print all output values (IDs, endpoints, IPs)
tflocal destroy  → Tear down all resources in reverse dependency order
```

---

## Architecture Diagram
```
Internet
│
▼
Internet Gateway (Public)
│
▼
Application Load Balancer
(Public Subnet AZ-a + AZ-b)
ALB SG: 80/443 from 0.0.0.0/0
│ port 80
▼
EC2 t2.micro (Private Subnet AZ-a)
EC2 SG: 8000 from ALB SG only
Docker: FastAPI + finance tracker backend
│ port 5432
▼
RDS PostgreSQL (Private Subnet AZ-b)
RDS SG: 5432 from EC2 SG only
No public access

S3 Bucket → React frontend static files (public read)
S3 State Bucket + DynamoDB → Terraform remote state and locking
```

---

## Key Engineering Decisions

**Why LocalStack instead of real AWS?** Identical Terraform code, zero cost, instant feedback. LocalStack Community supports VPC, EC2, S3, IAM, and security groups — the core IaC skills. RDS and ELBv2 require LocalStack Pro; their full Terraform definitions are commented into the code for reference.

**Why modules?** Flat Terraform becomes unmaintainable past 200 lines. Modules enforce separation of concerns — networking knows nothing about compute. Each module can be tested, versioned, and reused independently across environments.

**Why remote state from the start?** Local tfstate gets lost, accidentally committed to git (exposing secrets), and cannot be shared across a team. S3 + DynamoDB remote state is the production standard from day one.

**Why plan before every apply?** The plan output is the last safety check before real infrastructure changes. In production, plans are reviewed in pull requests before apply runs in CI/CD.

---

## Portfolio Context

| Project | Focus | Repo |
|---|---|---|
| Project 1 | Linux & Bash automation | devops-bash-scripts |
| Project 2 | Docker & containerisation | devops-docker-projects |
| Project 3 | FastAPI REST API + PostgreSQL + JWT | devops-python-api |
| Project 4 | React full-stack + Docker Compose | devops-fullstack-app |
| **Project 5** | **Terraform IaC + LocalStack** | **devops-terraform-aws** |

---

**Built by Nisarg Patel**  
[GitHub](https://github.com/Nisarg-2001-009)
