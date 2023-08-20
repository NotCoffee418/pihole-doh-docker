#!/bin/bash

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "Error: This script must be run as root (use sudo). Exiting..."
    exit 1
fi

# Docker check
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Install it using the official instructions for your OS"
    echo "https://docs.docker.com/engine/install/"
    exit 1
fi

# .env checks
# Check if .env doesn't exist
if [ ! -f .env ]; then
    cp .env.example .env
    echo "Error: .env file was copied from .env.example. Please set up the .env file before proceeding."
    exit 1
fi

# Check if EMAIL value in .env is set to "neededfor@letsencrypt.org"
if grep -q '^EMAIL=neededfor@letsencrypt.org$' .env; then
    echo "Error: .env file is not configured. Please update the value for your setup."
    exit 1
fi

# Create data dir
if [ ! -d ./data ]; then
    mkdir ./data
fi

# Ensure acme has the right permissions
sudo touch /docker/traefik/acme.json
sudo chmod 600 /docker/traefik/acme.json

# Check if port 53 is claimed by another process
if sudo ss -tuln | grep -q ':53'; then
    # Check if piholedoh service is up using docker-compose
    if docker-compose -f docker-compose.piholedoh.yml ps | grep -q Up; then
        echo "Error: pihole is already running. Exiting..."
        exit 1
    # Otherwise another process claimed it
    else
        echo "Error: Port 53 is already claimed by another process. Please check the documentation. Exiting..."
        exit 1
    fi
fi

# Create traefik_proxy external network if it doesn't exist yet
docker network ls | grep traefik_proxy || docker network create traefik_proxy

# Check and restart for docker-compose.piholedoh.yml
if ! docker-compose -f docker-compose.piholedoh.yml ps | grep -q Up; then
    echo "Restarting services defined in docker-compose.piholedoh.yml..."
    docker-compose -f docker-compose.piholedoh.yml up -d
fi

# Check and restart for docker-compose.traefik.yml
if ! docker-compose -f docker-compose.traefik.yml ps | grep -q Up; then
    echo "Restarting services defined in docker-compose.traefik.yml..."
    docker-compose -f docker-compose.traefik.yml up -d
fi
