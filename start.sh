#!/bin/bash

# KI Website Workshop - Startup Script

set -e

echo "🤖 Starting KI Website Workshop..."

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ .env file not found. Please copy .env.example to .env and configure it."
    exit 1
fi

# Load environment variables
source .env

# Check required environment variables
required_vars=("AZURE_OPENAI_API_KEY" "AZURE_OPENAI_ENDPOINT" "AZURE_OPENAI_DEPLOYMENT")
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "❌ Required environment variable $var is not set in .env"
        exit 1
    fi
done

echo "✅ Environment variables validated"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

echo "✅ Docker is running"

# Choose deployment mode
echo "Select deployment mode:"
echo "1) Development (default)"
echo "2) Production"
echo "3) Development with monitoring"

read -p "Enter choice [1-3]: " choice
choice=${choice:-1}

case $choice in
    1)
        echo "🔧 Starting development environment..."
        docker compose up --build
        ;;
    2)
        echo "🚀 Starting production environment..."
        if [ -z "$SECRET_KEY" ] || [ "$SECRET_KEY" = "supersecretdevelopmentkey" ]; then
            echo "❌ Please set a secure SECRET_KEY in .env for production"
            exit 1
        fi
        docker compose -f docker-compose.prod.yml up -d
        echo "✅ Production environment started"
        echo "📊 Access the application at: http://localhost"
        echo "🛠️ Admin dashboard: http://localhost/admin"
        ;;
    3)
        echo "📊 Starting development with monitoring..."
        docker compose --profile monitoring up --build
        echo "✅ Development environment with monitoring started"
        echo "📊 Grafana: http://localhost:3000"
        echo "🔍 Prometheus: http://localhost:9090"
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

# Show status
if [ "$choice" != "1" ]; then
    echo ""
    echo "📋 Container Status:"
    docker compose ps
    
    echo ""
    echo "📄 Logs (last 20 lines):"
    docker compose logs --tail=20
    
    echo ""
    echo "💡 Useful commands:"
    echo "  - View logs: docker compose logs -f"
    echo "  - Stop: docker compose down"
    echo "  - Restart: docker compose restart"
    echo "  - Database backup: docker compose exec postgres pg_dump -U workshop workshop > backup.sql"
fi

echo ""
echo "🎉 KI Website Workshop is ready!"
echo "📚 Documentation: README.md"
echo "🆘 Support: Create an issue on GitHub"