#!/bin/bash
set -e

echo "🚀 Setting up Kamrup.AI development environment..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Navigate to docker directory
cd "$(dirname "$0")/../docker"

# Stop any existing containers
echo "🧹 Cleaning up existing containers..."
docker-compose down -v

# Build and start services
echo "🏗️  Building and starting services..."
docker-compose up -d

# Wait for services to be healthy
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check PostgreSQL
until docker-compose exec postgres pg_isready -U kamrup > /dev/null 2>&1; do
    echo "⏳ Waiting for PostgreSQL..."
    sleep 2
done
echo "✅ PostgreSQL is ready"

# Check Redis
until docker-compose exec redis redis-cli ping > /dev/null 2>&1; do
    echo "⏳ Waiting for Redis..."
    sleep 2
done
echo "✅ Redis is ready"

# Check MinIO
until curl -f http://localhost:9000/minio/health/live > /dev/null 2>&1; do
    echo "⏳ Waiting for MinIO..."
    sleep 2
done
echo "✅ MinIO is ready"

# Create MinIO buckets
echo "🪣 Creating MinIO buckets..."
docker run --rm --network kamrup-infrastructure_default \
    -e MC_HOST_local=http://minioadmin:minioadmin123@minio:9000 \
    minio/mc:latest sh -c "
    mc mb local/kamrup-assets --ignore-existing
    mc mb local/kamrup-uploads --ignore-existing
    mc mb local/kamrup-processed --ignore-existing
    mc policy set download local/kamrup-processed
"

echo "🎉 Development environment is ready!"
echo ""
echo "📋 Services available:"
echo "   PostgreSQL: localhost:5432 (kamrup/dev_password_123)"
echo "   Redis: localhost:6379"
echo "   MinIO: http://localhost:9000 (minioadmin/minioadmin123)"
echo "   MinIO Console: http://localhost:9001"
echo "   Adminer: http://localhost:8080"
echo ""
echo "🔗 Connection strings:"
echo "   DATABASE_URL=postgresql://kamrup:dev_password_123@localhost:5432/kamrup_dev"
echo "   REDIS_URL=redis://localhost:6379"
echo "   S3_ENDPOINT=http://localhost:9000"