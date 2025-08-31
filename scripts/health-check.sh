#!/bin/bash
set -e

echo "🏥 Running health checks..."

# Check PostgreSQL
if pg_isready -h localhost -p 5432 -U kamrup; then
    echo "✅ PostgreSQL is healthy"
else
    echo "❌ PostgreSQL is not responding"
    exit 1
fi

# Check Redis
if redis-cli ping > /dev/null; then
    echo "✅ Redis is healthy"
else
    echo "❌ Redis is not responding"
    exit 1
fi

# Check MinIO
if curl -f http://localhost:9000/minio/health/live > /dev/null 2>&1; then
    echo "✅ MinIO is healthy"
else
    echo "❌ MinIO is not responding"
    exit 1
fi

echo "🎉 All services are healthy!"