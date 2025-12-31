# START FROM START - Complete VPS Setup for Clepto CRM

**Last Updated:** 2025-12-31
**VPS IP:** 148.230.120.207
**Domain:** crm.clepto.io
**Application:** Twenty CRM (Self-Hosted)

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Initial VPS Setup](#2-initial-vps-setup)
3. [Install Docker](#3-install-docker)
4. [Setup Traefik (Reverse Proxy)](#4-setup-traefik-reverse-proxy)
5. [Clone Repository](#5-clone-repository)
6. [Configure Environment](#6-configure-environment)
7. [Deploy Clepto CRM](#7-deploy-clepto-crm)
8. [Verify Deployment](#8-verify-deployment)
9. [Security Hardening](#9-security-hardening)
10. [Setup Backups](#10-setup-backups)
11. [Troubleshooting](#11-troubleshooting)

---

## 1. Prerequisites

### What You Need:
- Ubuntu 22.04 VPS (minimum 4GB RAM, 2 vCPU)
- Root SSH access to the VPS
- Domain `crm.clepto.io` pointing to VPS IP `148.230.120.207`
- Resend API key for emails (get from https://resend.com)

### DNS Configuration (Do This First!)
In your DNS provider, add:
```
Type: A
Name: crm
Value: 148.230.120.207
TTL: 300
```

Verify DNS propagation:
```bash
nslookup crm.clepto.io
# Should return 148.230.120.207
```

---

## 2. Initial VPS Setup

### SSH into your VPS:
```bash
ssh root@148.230.120.207
```

### Update system packages:
```bash
apt update && apt upgrade -y
```

### Set timezone:
```bash
timedatectl set-timezone UTC
```

### Create clepto directory:
```bash
mkdir -p /opt/clepto
cd /opt/clepto
```

---

## 3. Install Docker

### Install Docker Engine:
```bash
# Install prerequisites
apt install -y ca-certificates curl gnupg lsb-release

# Add Docker GPG key
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Verify Docker installation
docker --version
docker compose version
```

### Enable Docker to start on boot:
```bash
systemctl enable docker
systemctl start docker
```

---

## 4. Setup Traefik (Reverse Proxy)

Traefik handles SSL certificates (Let's Encrypt) and routes traffic to your containers.

### Create Traefik directory:
```bash
mkdir -p /root/traefik
cd /root/traefik
```

### Create docker-compose.yml for Traefik:
```bash
cat > docker-compose.yml <<'EOF'
version: '3.8'

services:
  traefik:
    image: traefik:v2.10
    container_name: root-traefik-1
    restart: always
    command:
      - "--api.dashboard=false"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"
      - "--certificatesresolvers.mytlschallenge.acme.tlschallenge=true"
      - "--certificatesresolvers.mytlschallenge.acme.email=mayank.khanvilkar@clepto.io"
      - "--certificatesresolvers.mytlschallenge.acme.storage=/letsencrypt/acme.json"
      - "--entrypoints.web.http.redirections.entryPoint.to=websecure"
      - "--entrypoints.web.http.redirections.entryPoint.scheme=https"
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./letsencrypt:/letsencrypt
    networks:
      - default

networks:
  default:
    name: root_default
EOF
```

### Start Traefik:
```bash
docker compose up -d
docker logs root-traefik-1
```

### Verify Traefik is running:
```bash
docker ps | grep traefik
# Should show: root-traefik-1 ... Up
```

---

## 5. Clone Repository

### Install Git (if not installed):
```bash
apt install -y git
```

### Clone Clepto-OS repository:
```bash
cd /opt/clepto
git clone https://github.com/cleptoio/Clepto-OS-v1.git .
```

Or if already exists, pull latest:
```bash
cd /opt/clepto
git pull origin main
```

---

## 6. Configure Environment

### Generate secrets:
```bash
# Generate APP_SECRET (required for Twenty CRM)
echo "APP_SECRET=$(openssl rand -base64 32)" >> /opt/clepto/infra/.env

# Generate database password
echo "PG_PASSWORD=$(openssl rand -base64 24 | tr -dc 'a-zA-Z0-9')" >> /opt/clepto/infra/.env

# Generate Redis password
echo "REDIS_PASSWORD=$(openssl rand -base64 16 | tr -dc 'a-zA-Z0-9')" >> /opt/clepto/infra/.env
```

### Create the full .env file:
```bash
cat > /opt/clepto/infra/.env <<'EOF'
# ============================================
# Clepto CRM - Production Environment
# ============================================

# Database
PG_USER=clepto
PG_DATABASE=clepto_os
PG_PASSWORD=REPLACE_WITH_GENERATED_PASSWORD

# Redis
REDIS_PASSWORD=REPLACE_WITH_GENERATED_PASSWORD

# Twenty CRM
APP_SECRET=REPLACE_WITH_GENERATED_SECRET
SERVER_URL=https://crm.clepto.io

# Email (Resend)
RESEND_API_KEY=re_YOUR_RESEND_API_KEY_HERE
EMAIL_FROM_ADDRESS=notifications@clepto.io
EOF
```

### Edit the .env file with your actual values:
```bash
nano /opt/clepto/infra/.env
```

Replace the placeholder values with your generated secrets.

---

## 7. Deploy Clepto CRM

### Navigate to infra directory:
```bash
cd /opt/clepto/infra
```

### Create Twenty database:
First, start just the database:
```bash
docker compose up -d clepto-db
sleep 10  # Wait for DB to initialize
```

### Create the 'twenty' database:
```bash
docker exec -it clepto-db psql -U clepto -d clepto_os -c "CREATE DATABASE twenty;"
```

### Start all services:
```bash
docker compose up -d
```

### Watch the logs:
```bash
docker compose logs -f
```

Wait until you see:
- `clepto-db`: "database system is ready to accept connections"
- `clepto-redis`: "Ready to accept connections"
- `twenty-server`: "Server started on port 3000" or healthcheck passing

### Check container status:
```bash
docker compose ps
```

Expected output:
```
NAME              STATUS           PORTS
clepto-db         Up (healthy)
clepto-redis      Up (healthy)
twenty-server     Up (healthy)
twenty-worker     Up
```

---

## 8. Verify Deployment

### Test HTTPS access:
```bash
curl -I https://crm.clepto.io
# Should return: HTTP/2 200
```

### Open in browser:
Go to: https://crm.clepto.io

You should see the Twenty CRM login/setup page.

### First-time setup:
1. Create your admin account
2. Set up your workspace name (e.g., "Clepto")
3. Configure your profile

---

## 9. Security Hardening

### Run the security hardening script:
```bash
cd /opt/clepto
bash scripts/harden-vps.sh
```

This will:
- Install and configure UFW firewall
- Install Fail2Ban for SSH protection
- Enable automatic security updates
- Harden SSH configuration

### Or do it manually:

#### UFW Firewall:
```bash
apt install -y ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp   # SSH
ufw allow 80/tcp   # HTTP
ufw allow 443/tcp  # HTTPS
ufw --force enable
ufw status
```

#### Fail2Ban:
```bash
apt install -y fail2ban

cat > /etc/fail2ban/jail.local <<'EOF'
[sshd]
enabled = true
port = 22
maxretry = 3
bantime = 86400
EOF

systemctl enable fail2ban
systemctl restart fail2ban
```

---

## 10. Setup Backups

### Create backup directory:
```bash
mkdir -p /opt/clepto/backups
```

### Setup automated daily backup:
```bash
# Add cron job for daily backup at 2 AM
(crontab -l 2>/dev/null; echo "0 2 * * * cd /opt/clepto && bash scripts/backup-local.sh >> /var/log/clepto-backup.log 2>&1") | crontab -
```

### Manual backup:
```bash
cd /opt/clepto
bash scripts/backup-local.sh
```

### Verify backup:
```bash
ls -la /opt/clepto/backups/
```

---

## 11. Troubleshooting

### View all container logs:
```bash
cd /opt/clepto/infra
docker compose logs -f
```

### View specific service logs:
```bash
docker compose logs -f twenty-server
docker compose logs -f clepto-db
```

### Restart all services:
```bash
docker compose restart
```

### Restart a specific service:
```bash
docker compose restart twenty-server
```

### Check container health:
```bash
docker ps --format "table {{.Names}}\t{{.Status}}"
```

### Database access:
```bash
docker exec -it clepto-db psql -U clepto -d twenty
```

### Common Issues:

#### "Connection refused" on crm.clepto.io:
1. Check if containers are running: `docker ps`
2. Check Traefik logs: `docker logs root-traefik-1`
3. Verify DNS: `nslookup crm.clepto.io`

#### "Bad Gateway" error:
1. Twenty server not healthy yet - wait 2-3 minutes
2. Check twenty-server logs: `docker compose logs twenty-server`

#### Database connection errors:
1. Verify database is healthy: `docker compose ps`
2. Check if 'twenty' database exists:
   ```bash
   docker exec -it clepto-db psql -U clepto -c "\l"
   ```

#### SSL Certificate issues:
1. Check Traefik logs: `docker logs root-traefik-1 | grep -i cert`
2. Verify DNS is pointing correctly
3. Wait up to 5 minutes for Let's Encrypt to issue certificate

---

## Quick Reference Commands

```bash
# Start all services
cd /opt/clepto/infra && docker compose up -d

# Stop all services
cd /opt/clepto/infra && docker compose down

# View logs
cd /opt/clepto/infra && docker compose logs -f

# Restart services
cd /opt/clepto/infra && docker compose restart

# Check status
cd /opt/clepto/infra && docker compose ps

# Update to latest Twenty CRM
cd /opt/clepto/infra && docker compose pull && docker compose up -d

# Backup database
cd /opt/clepto && bash scripts/backup-local.sh

# Access database shell
docker exec -it clepto-db psql -U clepto -d twenty
```

---

## Architecture Overview

```
Internet
    │
    ▼
┌─────────────────────────────────────────┐
│            Traefik (Reverse Proxy)      │
│         Ports 80, 443 (SSL termination) │
└─────────────────────────────────────────┘
    │
    ├── crm.clepto.io ──────────┐
    │                           ▼
    │               ┌─────────────────────┐
    │               │   Twenty Server     │
    │               │   (Port 3000)       │
    │               └─────────────────────┘
    │                           │
    │                           ▼
    │               ┌─────────────────────┐
    │               │   Twenty Worker     │
    │               │   (Background Jobs) │
    │               └─────────────────────┘
    │                           │
    │                           ▼
    │   ┌─────────────────┬─────────────────┐
    │   │   PostgreSQL    │     Redis       │
    │   │   (clepto-db)   │ (clepto-redis)  │
    │   └─────────────────┴─────────────────┘
```

---

## Support

If you run into issues:
1. Check container logs first
2. Verify DNS and firewall settings
3. Review this guide step by step

**Remember:** The VPS IP is `148.230.120.207` and your domain is `crm.clepto.io`
