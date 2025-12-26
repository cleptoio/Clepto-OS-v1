# 🔐 Clepto OS - Security & Best Practices

This document outlines security measures, backup strategies, and best practices for running Clepto OS safely.

---

## 🎯 Security Overview

Clepto OS is designed with security in mind, but proper configuration and maintenance are essential.

### Security Layers

1. **Network Security**: Firewall, Traefik reverse proxy, SSL/TLS
2. **Application Security**: Authentication, authorization, input validation
3. **Data Security**: Database encryption, backup strategy
4. **Access Control**: SSH keys, role-based permissions

---

## 🔥 Firewall Configuration

### UFW (Uncomplicated Firewall)

UFW is enabled during setup. Here's what's allowed:

```bash
# Check current rules
sudo ufw status verbose

# Expected output:
# 22/tcp    ALLOW    Anywhere    (SSH)
# 80/tcp    ALLOW    Anywhere    (HTTP)
# 443/tcp   ALLOW    Anywhere    (HTTPS)
```

### Adding Custom Rules

If you need to open additional ports:

```bash
# Example: Allow custom SSH port
sudo ufw allow 2222/tcp

# Example: Allow from specific IP only
sudo ufw allow from 123.45.67.89 to any port 22
```

### Removing Rules

```bash
# List rules with numbers
sudo ufw status numbered

# Delete a rule (e.g., rule #3)
sudo ufw delete 3
```

---

## 🔑 SSH Security

### 1. Change Default SSH Port

**Why**: Reduces automated brute-force attacks

```bash
# Edit SSH config
sudo nano /etc/ssh/sshd_config

# Find this line:
# #Port 22

# Change to:
Port 2222

# Save (Ctrl+X, Y, Enter)

# Restart SSH
sudo systemctl restart sshd

# Update firewall
sudo ufw allow 2222/tcp
sudo ufw delete allow 22/tcp
```

**Next time, connect with**:
```bash
ssh -p 2222 root@your-vps-ip
```

### 2. Disable Password Authentication (More Secure)

Only allow SSH key authentication:

```bash
sudo nano /etc/ssh/sshd_config

# Find and change these lines:
PasswordAuthentication no
PubkeyAuthentication yes
PermitRootLogin prohibit-password

# Restart SSH
sudo systemctl restart sshd
```

> **⚠️ Warning**: Make sure you have SSH key access before disabling passwords, or you'll lock yourself out!

### 3. Install Fail2Ban

Fail2Ban automatically blocks IPs after failed login attempts:

```bash
# Install
sudo apt install fail2ban -y

# Create local config
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Edit config
sudo nano /etc/fail2ban/jail.local

# Find [sshd] section and set:
enabled = true
maxretry = 3
bantime = 3600

# Start and enable
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

# Check status
sudo fail2ban-client status sshd
```

---

## 🔒 SSL/TLS Certificates

Clepto OS uses **Let's Encrypt** for free SSL certificates via Traefik.

### Automatic Renewal

Traefik automatically renews certificates. To verify:

```bash
# Check certificate files
ls -la ~/Clepto-OS-v1/infra/traefik-certs/

# View Traefik logs
docker logs clepto-traefik 2>&1 | grep -i "certificate"
```

### Manual Certificate Renewal

If needed:

```bash
# Restart Traefik to force renewal
docker restart clepto-traefik
```

### Certificate Expiry Alerts

Set up a cron job to check certificate expiry:

```bash
# Create monitoring script
nano ~/check-ssl.sh
```

Paste:
```bash
#!/bin/bash
DOMAIN="crm.clepto.io"
EXPIRY=$(echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null | openssl x509 -noout -dates | grep notAfter | cut -d= -f2)
echo "SSL Certificate for $DOMAIN expires on: $EXPIRY"
```

Make executable:
```bash
chmod +x ~/check-ssl.sh

# Add to crontab (run weekly)
crontab -e

# Add this line:
0 0 * * 0 ~/check-ssl.sh >> /var/log/ssl-check.log 2>&1
```

---

## 🗄️ Database Security

### Strong Passwords

**Never use default passwords!** Generate strong passwords:

```bash
# Generate a random password
openssl rand -base64 32
```

Update in your `.env` file:
```bash
POSTGRES_PASSWORD=<your-strong-password>
DB_CRM_PASSWORD=<your-strong-password>
DB_MAIL_PASSWORD=<your-strong-password>
```

### Database Access Control

Databases are only accessible from within the Docker network (not exposed to the internet).

To verify:
```bash
# Check listening ports
sudo netstat -tulpn | grep postgres

# Should NOT show 0.0.0.0:5432 (public access)
# Should show 172.x.x.x:5432 (Docker internal only)
```

### Database Encryption at Rest (Optional)

For sensitive data, enable PostgreSQL encryption:

```bash
# This is advanced - consult PostgreSQL documentation
# https://www.postgresql.org/docs/current/encryption-options.html
```

---

## 💾 Backup Strategy

### Automated Daily Backups

Set up automatic backups using the provided script:

```bash
# Make backup script executable
chmod +x ~/Clepto-OS-v1/scripts/backup.sh

# Test the script
~/Clepto-OS-v1/scripts/backup.sh

# Schedule daily backups (2 AM)
crontab -e

# Add this line:
0 2 * * * ~/Clepto-OS-v1/scripts/backup.sh >> /var/log/clepto-backup.log 2>&1
```

### Backup Retention

Default: **7 days** (configurable in `backup.sh`)

Backups are stored in: `~/clepto-backups/`

### Off-Site Backups (Highly Recommended)

Store backups remotely for disaster recovery.

#### Option 1: Sync to Another Server

```bash
# Install rsync
sudo apt install rsync -y

# Create sync script
nano ~/sync-backups.sh
```

Paste:
```bash
#!/bin/bash
rsync -avz ~/clepto-backups/ user@backup-server:/path/to/backups/
```

#### Option 2: Upload to Cloud Storage (S3/Backblaze B2)

```bash
# Install AWS CLI
sudo apt install awscli -y

# Configure AWS credentials
aws configure

# Add to backup.sh (uncomment the S3 upload section)
```

### Manual Backup

```bash
# Run backup manually
~/Clepto-OS-v1/scripts/backup.sh
```

### Restore from Backup

```bash
# List available backups
ls -lh ~/clepto-backups/

# Restore CRM database
gunzip -c ~/clepto-backups/crm_20250126_020000.sql.gz | \
docker exec -i clepto-postgres-crm psql -U clepto clepto_crm

# Restore Mail database
gunzip -c ~/clepto-backups/mail_20250126_020000.sql.gz | \
docker exec -i clepto-postgres-mail psql -U clepto clepto_mail
```

---

## 🛡️ Application Security

### Environment Variables

**Never commit `.env` to Git!**

The `.gitignore` file already excludes it, but double-check:

```bash
# Verify .env is not tracked
cd ~/Clepto-OS-v1
git status

# If .env shows up, remove it:
git rm --cached .env
```

### Secret Rotation

Periodically change sensitive credentials:

1. **Database passwords**: Update in `.env`, restart containers
2. **JWT secrets**: Invalidates all user sessions
3. **API keys**: Update in `.env` and any integrated services

### User Permissions

Inside Clepto OS, follow the **principle of least privilege**:

- **Admin**: Only for you and trusted team members
- **Sales/Marketing/HR**: Specific modules only
- **Clients**: Read-only or limited scope

### Input Validation

Clepto OS (via Twenty.crm and Notifuse) includes built-in input validation. Always:

- Sanitize user inputs
- Validate file uploads
- Limit file sizes (set in `.env`)

---

## 📊 Monitoring & Logging

### Docker Logs

```bash
# View all logs
docker-compose -f ~/Clepto-OS-v1/infra/docker-compose.yml logs

# Follow live logs
docker-compose -f ~/Clepto-OS-v1/infra/docker-compose.yml logs -f

# Specific service
docker logs clepto-crm -f

# Last 100 lines
docker logs clepto-crm --tail 100
```

### System Monitoring

```bash
# Disk usage
df -h

# Memory usage
free -h

# CPU and process monitoring
htop

# Docker resource usage
docker stats
```

### Log Rotation

Prevent logs from filling up disk:

```bash
# Edit Docker daemon config
sudo nano /etc/docker/daemon.json
```

Add:
```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

Restart Docker:
```bash
sudo systemctl restart docker
```

### Uptime Monitoring (Optional)

Use external services to monitor uptime:

- [UptimeRobot](https://uptimerobot.com) (Free)
- [Pingdom](https://pingdom.com)
- [StatusCake](https://statuscake.com)

Set up checks for:
- `https://crm.clepto.io`
- `https://mail.clepto.io`

---

## 🚨 Incident Response

### If Your Site Goes Down

1. **Check service status**:
   ```bash
   docker ps
   ```

2. **Restart services**:
   ```bash
   cd ~/Clepto-OS-v1
   docker-compose -f infra/docker-compose.yml restart
   ```

3. **Check logs** for errors:
   ```bash
   docker-compose -f infra/docker-compose.yml logs --tail=100
   ```

4. **Check disk space**:
   ```bash
   df -h
   ```

5. **If all else fails, restore from backup**

### If You Suspect a Security Breach

1. **Immediately change all passwords** (database, admin accounts)
2. **Review access logs**:
   ```bash
   sudo tail -f /var/log/auth.log
   ```
3. **Check for unauthorized Docker containers**:
   ```bash
   docker ps -a
   ```
4. **Restore from a known-good backup**
5. **Contact security expert if needed**

---

## 🔄 Update Strategy

### Security Updates

Keep your system updated:

```bash
# Update Ubuntu packages weekly
sudo apt update && sudo apt upgrade -y

# Update Docker images monthly
cd ~/Clepto-OS-v1
docker-compose -f infra/docker-compose.yml pull
docker-compose -f infra/docker-compose.yml up -d
```

### Application Updates

When changes are pushed to GitHub:

```bash
# Run deployment script
~/Clepto-OS-v1/scripts/deploy.sh
```

This automatically:
- Creates a backup
- Pulls latest code
- Rebuilds containers
- Restarts services

---

## ✅ Security Checklist

Use this checklist to verify your security setup:

### Initial Setup
- [ ] Firewall enabled (UFW) with only necessary ports
- [ ] SSH key authentication configured
- [ ] Strong passwords in `.env` file
- [ ] Fail2Ban installed and configured
- [ ] SSL certificates working (via Traefik)

### Ongoing Maintenance
- [ ] Daily database backups running
- [ ] Off-site backup solution configured
- [ ] System updates applied monthly
- [ ] Logs reviewed weekly
- [ ] Disk space monitored
- [ ] Uptime monitoring enabled

### Access Control
- [ ] Root SSH login disabled (optional)
- [ ] SSH port changed from default 22 (optional)
- [ ] User roles properly configured in Clepto OS
- [ ] `.env` file not committed to Git

---

## 📞 Security Support

For security concerns:
- Email: security@clepto.io
- Refer to: [OWASP Security Guidelines](https://owasp.org)

---

**🔐 Stay secure, stay updated, stay backed up!**
