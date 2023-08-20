#!/bin/bash

# Function to check if services from a specific docker-compose file are running
check_service_running() {
    local compose_file="$1"
    docker-compose -f "$compose_file" ps | grep -q 'Up'
}

# Function to stop services from a specific docker-compose file and report status
stop_services() {
    local compose_file="$1"
    if check_service_running "$compose_file"; then
        docker-compose -f "$compose_file" down
        echo "Services defined in $compose_file have been stopped."
    else
        echo "Services defined in $compose_file were not running."
    fi
}

# Stop services for both docker-compose files
stop_services "docker-compose.piholedoh.yml"
stop_services "docker-compose.traefik.yml"