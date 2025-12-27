# Notifuse Deployment Guide

## Overview
Notifuse is an open-source, self-hosted emailing platform for managing:
- Marketing campaigns and newsletters
- Transactional emails (invoices, welcome emails, notifications)
- Contact lists and segmentation

## Access
- **URL**: https://mail.clepto.io
- **Port**: 8080 (internal, routed via Traefik)

## Pre-Deployment Steps

### 1. Create DNS Record
Add an A record in your DNS provider pointing to your VPS:
```
mail.clepto.io -> 148.230.120.207
```

### 2. Create Notifuse Database
SSH to your VPS and run:
```bash
docker exec -it clepto-db psql -U clepto -d clepto_os -c "CREATE DATABASE notifuse;"
```

### 3. Generate Secret Key
Add this to your `.env` file:
```bash
# Generate a secure secret key
openssl rand -base64 64
```

Add the output to `/opt/clepto/infra/.env`:
```
NOTIFUSE_SECRET_KEY=your_generated_key_here
```

### 4. Update docker-compose.yml
Copy the updated `docker-compose.yml` to your VPS:
```bash
# On VPS
cd /opt/clepto/infra
nano docker-compose.yml
# Paste the updated content
```

### 5. Deploy
```bash
docker compose up -d
```

### 6. Verify
```bash
docker logs notifuse
```

Wait for "Server started on port 8080" message.

## First-Time Setup

1. Go to https://mail.clepto.io
2. Complete the Setup Wizard:
   - Set your admin email (mayank.khanvilkar@clepto.io)
   - Configure SMTP (already pre-configured via environment variables)
3. Create your first workspace

## Integration with Twenty CRM

Notifuse can be called from:
1. **n8n Workflows**: HTTP Request nodes to Notifuse API
2. **Direct API Calls**: From clepto-api backend

### Example: Send Transactional Email via n8n
```json
{
  "method": "POST",
  "url": "http://notifuse:8080/api/v1/transactional/send",
  "headers": {
    "Authorization": "Bearer YOUR_API_KEY"
  },
  "body": {
    "to": "client@example.com",
    "template": "invoice_sent",
    "data": {
      "invoiceNumber": "INV-001",
      "amount": "$1,500"
    }
  }
}
```

## White-Labeling

Notifuse supports custom branding:
1. Go to Settings > Branding
2. Upload Clepto logo
3. Set primary color to `#0bd7d4`
4. Set background to `#0e172f`

All emails sent will use Clepto branding.

## Troubleshooting

### "Connection refused" to database
Ensure the `notifuse` database exists:
```bash
docker exec -it clepto-db psql -U clepto -c "\l"
```

### "Cannot reach SMTP server"
Check your Resend API key is correct in `.env`:
```bash
RESEND_API_KEY=re_xxxxx
```

### Container keeps restarting
Check logs:
```bash
docker logs notifuse --tail 50
```
