# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the Kamrup.AI infrastructure repository containing infrastructure-as-code and development environment setup for an AI-powered application. The project uses containerized local development with Docker Compose and AWS infrastructure provisioned through Terraform.

## Architecture

### Local Development Stack
- **PostgreSQL 15**: Primary database (port 5432)
- **Redis 7**: Caching and session storage (port 6379)
- **MinIO**: S3-compatible object storage for development (ports 9000/9001)
- **Adminer**: Database administration interface (port 8080)

### AWS Production Infrastructure
- **VPC**: Custom VPC with public/private subnet architecture across 2 AZs
- **RDS PostgreSQL 15**: Managed database in private subnets
- **ElastiCache Redis**: Managed Redis cluster
- **S3 Buckets**: Two buckets (assets and processed content) with encryption and versioning
- **Security**: Proper security groups, encrypted storage, backup retention

## Common Commands

### Development Environment
```bash
# Set up local development environment
./scripts/setup-dev.sh

# Check service health
./scripts/health-check.sh

# Start services manually
cd docker && docker-compose up -d

# Stop services
cd docker && docker-compose down -v
```

### Infrastructure Deployment
```bash
# Deploy to development
./scripts/deploy.sh dev

# Deploy to production
./scripts/deploy.sh prod

# Manual Terraform commands
cd terraform/aws
terraform init
terraform plan -var="environment=dev"
terraform apply -var="environment=dev"
terraform output
```

## Environment Configuration

The project uses environment-specific configuration:

### Required Environment Variables
- `DATABASE_URL`: PostgreSQL connection string
- `REDIS_URL`: Redis connection string  
- `S3_ENDPOINT`: S3/MinIO endpoint
- `S3_ACCESS_KEY/S3_SECRET_KEY`: S3 credentials
- `S3_BUCKET_ASSETS/S3_BUCKET_PROCESSED`: S3 bucket names
- `OPENAI_API_KEY`: OpenAI API key
- `ELEVENLABS_API_KEY`: ElevenLabs API key
- `JWT_SECRET`: JWT signing key
- `N8N_HOST/N8N_API_KEY`: n8n automation platform integration

### Terraform Variables
- `project_name`: Project identifier (default: kamrup-ai)
- `environment`: Environment name (dev/staging/prod)
- `aws_region`: AWS deployment region (default: us-east-1)
- `database_password`: RDS database password (required, sensitive)
- `instance_class`: RDS instance size (default: db.t3.micro)
- `backup_retention_days`: Database backup retention (default: 7)

## Service Dependencies

### Development Services Order
1. PostgreSQL must be ready before application starts
2. Redis should be available for caching
3. MinIO buckets (kamrup-assets, kamrup-uploads, kamrup-processed) are auto-created
4. Health checks ensure services are fully ready before proceeding

### AWS Infrastructure Dependencies
- RDS requires database subnet group and security groups
- S3 buckets use random suffixes to ensure uniqueness
- Production environment has deletion protection enabled
- All storage is encrypted at rest