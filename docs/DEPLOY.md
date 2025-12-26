# Manual Deployment Guide

**First-time production deployment on a bare VPS.**

## Prerequisites
- Ubuntu 24.04 VPS
- Domain (`crm.clepto.io`) pointing to VPS IP
- Secrets generated (See `SETUP-SECRETS.md`)

## Step 1: Clone Repository

SSH into your VPS:
```bash
ssh root@YOUR_VPS_IP
mkdir -p /opt/clepto
cd /opt/clepto

# Clone (Use HTTPS + PAT or SSH)
git clone https://github.com/cleptoio/Clepto-OS-v1.git .
```

## Step 2: Configure Environment

```bash
cp infra/env/.env.example .env
nano .env
```
- Paste your `APP_SECRET`, `PG_PASSWORD`, etc.
- Set `DOMAIN=crm.clepto.io`

## Step 3: Validate Config

```bash
bash scripts/validate-env.sh
# Check for "✅ Environment validation passed"
```

## Step 4: Start Services

```bash
docker compose up -d

# Wait 30s
sleep 30
docker ps
```

## Step 5: Verify

1. Check logs: `docker logs -f clepto-crm`
2. Open browser: `https://crm.clepto.io`
3. Check backup: `bash scripts/backup-to-s3.sh`

## Troubleshooting

- **Connection Refused**: Check Traefik logs `docker logs traefik`. Wait for SSL.
- **DB Error**: Verify `PG_PASSWORD` matches in `.env`.
