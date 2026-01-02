#!/bin/bash

# Stop script on error
set -e

APP_NAME="word2pdf"
PORT=8080

echo "🚀 Starting deployment for $APP_NAME..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Stop and remove existing container
if [ "$(docker ps -q -f name=$APP_NAME)" ]; then
    echo "🛑 Stopping existing container..."
    docker stop $APP_NAME
fi

if [ "$(docker ps -aq -f name=$APP_NAME)" ]; then
    echo "🗑️ Removing existing container..."
    docker rm $APP_NAME
fi

# Build the Docker image
echo "🔨 Building Docker image..."
# Use host network for build if necessary, but standard build should work with our custom settings.xml
docker build -t $APP_NAME .

# Run the new container
echo "🏃 Starting new container..."
docker run -d \
  --name $APP_NAME \
  --restart unless-stopped \
  -p $PORT:8080 \
  -e TZ=Asia/Shanghai \
  $APP_NAME

echo "✅ Deployment successful!"
echo "📜 Logs:"
docker logs $APP_NAME --tail 10
