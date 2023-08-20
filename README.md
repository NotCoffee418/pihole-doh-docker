# pihole-doh-docker
Simple setup for Pi-Hole with DoH using Docker for Linux.

## Prerequisites
- Static Local IP Address
- Domain name pointed to your server (this setup relies on it)

## Setup
1. Set up a static local IP address for your server
2. Have a domain name or subdomain for pihole pointing to your server.
   This is needed for TLS to work. Traefik also relies on this to access the Pi-Hole dashboard.
3. Install (Docker)[https://docs.docker.com/engine/install/]
4. Clone this repository in the directory of your choice
5. Create the .env file `cp .env.example .env`
6. Edit the `.env` file and change the values to your liking
7. `sudo chmod +x start.sh && sudo ./start.sh`
8. Access pi-hole at `http://<your pihole domain name>`
9. Set router or computer's DNS to point to your Pi-Hole's IP address

## Usage
- `sudo ./start.sh` - Starts the containers
- `sudo ./stop.sh` - Stops the containers

## Troubleshooting
### Port 53 is already claimed
If you have another DNS server running on port 53, you will need to stop it before running this setup.

Check which process, if any is claiming port 53. If it's empty, you're good to go.
```bash
sudo lsof -i :53
```

#### systemd-resolved claimed
If systemd-resolved is claiming port 53, you will need to disable it.

```bash
sudo nano /etc/systemd/resolved.conf
```

Set this line (uncomment if needed):

```conf
DNSStubListener=no
```

```bash
# Restart systemd-resolved
sudo systemctl restart systemd-resolved

# Check if still claimed
sudo lsof -i :53
```
