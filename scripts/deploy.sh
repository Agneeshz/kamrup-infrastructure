#!/bin/bash
set -e

ENVIRONMENT=${1:-dev}
echo "🚀 Deploying to $ENVIRONMENT environment..."

# Navigate to terraform directory
cd "$(dirname "$0")/../terraform/aws"

# Initialize Terraform if needed
if [ ! -d ".terraform" ]; then
    echo "🔧 Initializing Terraform..."
    terraform init
fi

# Plan deployment
echo "📋 Planning infrastructure changes..."
terraform plan -var="environment=$ENVIRONMENT" -out=tfplan

# Confirm deployment
echo "Do you want to apply these changes? (y/n)"
read -r confirm
if [ "$confirm" != "y" ]; then
    echo "❌ Deployment cancelled"
    exit 0
fi

# Apply changes
echo "🏗️  Applying infrastructure changes..."
terraform apply tfplan

# Output connection strings
echo "📋 Getting connection information..."
terraform output

echo "✅ Deployment complete!"