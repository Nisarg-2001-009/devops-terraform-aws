#!/bin/bash
set -e

# Update system packages
yum update -y

# Install Docker
yum install -y docker
systemctl start docker
systemctl enable docker

# Add ec2-user to docker group
usermod -aG docker ec2-user

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Create app directory
mkdir -p /app
cd /app

# Create docker-compose for the finance tracker backend
cat > /app/docker-compose.yml << 'COMPOSE'
version: "3.8"
services:
  backend:
    image: nisarg2001009/devops-python-api:latest
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://financeuser:financepass123@${db_endpoint}/financedb
      - SECRET_KEY=supersecretkey123changeme
      - ALGORITHM=HS256
      - ACCESS_TOKEN_EXPIRE_MINUTES=30
    restart: unless-stopped
COMPOSE

# Start the application
docker-compose up -d

echo "Finance Tracker backend started successfully"
