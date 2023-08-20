# pihole-doh-docker
Setup for Pi-Hole with upstream DNS-over-HTTPS using Docker for Linux.

It uses Traefik as a reverse proxy to access the Pi-Hole dashboard and to handle TLS.
Pi-Hole as the primary DNS server on port 53 for your network devices to connect to.
Cloudflared for upstream DNS over HTTPS.

This setup is intended for local network usage. You can run it in the cloud but without a DoH proxy for DNS you're still making unencrypted DNS requests to your server and you're better off with a plain Pi-Hole setup.


## Prerequisites
- Static Local IP Address (ideally both IPv4 and IPv6)
- Domain name pointed to your server (this setup relies on it)
  This is needed for TLS to work. Traefik also relies on this to access the Pi-Hole dashboard.
- [Docker](https://docs.docker.com/engine/install/) installed

## Setup
1. `git clone https://github.com/NotCoffee418/pihole-doh-docker.git`
2. `cd pihole-doh-docker`
3. `cp .env.example .env`
4. `nano .env` and set the variables for your setup.
5. `sudo ./start.sh` to test config and run the containers
6. `sudo ./set-password.sh` to set the password for the Pi-Hole dashboard
7. Access pi-hole at the domain you configured in the .env file
8. Set router's or computer's DNS to point to your Pi-Hole's IP address

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

**systemd-resolved claimed**
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

### I can't access the Pi-Hole dashboard
Check if the containers are running:

```bash
sudo docker ps
```
There should be 3 containers running:
- pihole
- cloudflared
- traefik

If they are not running, run `sudo ./start.sh` to start them.
You may also need to double-check your .env file.

If you got your domain very recently, it may take a while for it to be accessible.

### What's the password for the Pi-Hole dashboard?
You can set the password by running `sudo ./set-password.sh` and following the instructions.
By default, it's a randomly generated password.

### I can't access the internet anymore!
Because you're using Pi-Hole as your DNS server, if it goes offline, so does any device that relies on it.
If you're having issues with Pi-Hole, you can temporarily disable it by changing your DNS server to something else.