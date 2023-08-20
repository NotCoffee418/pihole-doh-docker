#!/bin/bash


# Check and restart for docker-compose.piholedoh.yml
if ! docker-compose -f docker-compose.piholedoh.yml ps | grep -q Up; then
    echo "Pi-hole must be running before you can set password."
    exit 1
fi

# Set password in container
docker exec -it $(docker ps | grep "pihole/pihole" | awk '{print $1}') pihole -a -p
