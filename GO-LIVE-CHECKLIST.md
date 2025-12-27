# 🚀 Clepto OS - Production Readiness Checklist

**Status:** 70% → 100% Production-Ready  
**VPS:** 148.230.120.207  
**Domains:** crm.clepto.io, mail.clepto.io

---

## ✅ PHASE 1: Notifuse Deployment (CRITICAL)

### 1.1 DNS Configuration
```bash
# Add A record for mail.clepto.io → 148.230.120.207
# Verify DNS propagation:
nslookup mail.clepto.io
```
- [ ] DNS A record created for `mail.clepto.io`
- [ ] DNS propagation verified (may take 5-60 minutes)

### 1.2 Create Notifuse Database
```bash
# SSH into VPS
ssh root@148.230.120.207

# Create notifuse database
docker exec -it clepto-db psql -U clepto -d clepto_os -c "CREATE DATABASE notifuse;"

# Verify database exists
docker exec -it clepto-db psql -U clepto -c "\l" | grep notifuse
```
- [ ] `notifuse` database created
- [ ] Database verified in PostgreSQL

### 1.3 Generate Notifuse Secret Key
```bash
# Generate secure secret key
openssl rand -base64 64

# Add to /opt/clepto/infra/.env:
# NOTIFUSE_SECRET_KEY=<generated_key_here>
nano /opt/clepto/infra/.env
```
- [ ] Secret key generated
- [ ] `NOTIFUSE_SECRET_KEY` added to `.env`

### 1.4 Deploy Notifuse
```bash
cd /opt/clepto/infra

# Pull latest docker-compose.yml from GitHub
git pull origin main

# Start Notifuse
docker compose up -d notifuse

# Check logs
docker compose logs -f notifuse
```
- [ ] Notifuse container started
- [ ] No errors in logs
- [ ] Health check passing: `docker ps | grep notifuse`

### 1.5 Test Notifuse Access
```bash
# Test HTTPS access
curl -I https://mail.clepto.io

# Should return: HTTP/2 200
```
- [ ] `https://mail.clepto.io` accessible
- [ ] SSL certificate valid (green padlock in browser)
- [ ] Notifuse login page loads

### 1.6 Configure Notifuse Admin
1. Go to: `https://mail.clepto.io`
2. Complete initial setup wizard
3. Create admin account (use your email)
4. Verify SMTP settings (Resend pre-configured)

- [ ] Admin account created
- [ ] SMTP configuration verified
- [ ] Test email sent successfully

---

## 🔒 PHASE 2: VPS Security Hardening (CRITICAL)

### 2.1 UFW Firewall Setup
```bash
# Install UFW (if not already installed)
apt update && apt install ufw -y

# Default policies
ufw default deny incoming
ufw default allow outgoing

# Allow SSH (CRITICAL - don't lock yourself out!)
ufw allow 22/tcp comment 'SSH'

# Allow HTTP/HTTPS (Traefik)
ufw allow 80/tcp comment 'HTTP'
ufw allow 443/tcp comment 'HTTPS'

# Enable firewall
ufw --force enable

# Verify status
ufw status verbose
```
- [ ] UFW installed
- [ ] Default policies set (deny incoming, allow outgoing)
- [ ] SSH (22), HTTP (80), HTTPS (443) allowed
- [ ] UFW enabled and active
- [ ] Can still SSH after enabling (TEST THIS!)

### 2.2 Fail2Ban Installation
```bash
# Install Fail2Ban
apt install fail2ban -y

# Create custom SSH jail
cat > /etc/fail2ban/jail.local <<'EOF'
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5
destemail = your-email@clepto.io
sendername = Fail2Ban

[sshd]
enabled = true
port = 22
logpath = /var/log/auth.log
maxretry = 3
bantime = 86400
EOF

# Start and enable Fail2Ban
systemctl enable fail2ban
systemctl start fail2ban

# Check status
fail2ban-client status
fail2ban-client status sshd
```
- [ ] Fail2Ban installed
- [ ] SSH jail configured (3 attempts = 24h ban)
- [ ] Fail2Ban service running
- [ ] Email notifications configured

### 2.3 Automatic Security Updates
```bash
# Install unattended-upgrades
apt install unattended-upgrades apt-listchanges -y

# Configure automatic updates
cat > /etc/apt/apt.conf.d/50unattended-upgrades <<'EOF'
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
    "${distro_id}ESMApps:${distro_codename}-apps-security";
    "${distro_id}ESM:${distro_codename}-infra-security";
};
Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::MinimalSteps "true";
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "false";
Unattended-Upgrade::Automatic-Reboot-Time "03:00";
EOF

# Enable automatic updates
cat > /etc/apt/apt.conf.d/20auto-upgrades <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOF

# Test configuration
unattended-upgrades --dry-run --debug
```
- [ ] `unattended-upgrades` installed
- [ ] Security updates enabled
- [ ] Auto-reboot disabled (manual control)
- [ ] Dry-run test successful

### 2.4 SSH Hardening
```bash
# Backup SSH config
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Harden SSH (disable password auth, enable key-only)
cat >> /etc/ssh/sshd_config <<'EOF'

# Clepto Security Hardening
PermitRootLogin prohibit-password
PasswordAuthentication no
PubkeyAuthentication yes
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding no
PrintMotd no
AcceptEnv LANG LC_*
ClientAliveInterval 300
ClientAliveCountMax 2
MaxAuthTries 3
EOF

# Test config
sshd -t

# Restart SSH (ONLY if test passes!)
systemctl restart sshd
```
- [ ] SSH config backed up
- [ ] Password authentication disabled
- [ ] Key-only authentication enforced
- [ ] SSH config tested (`sshd -t`)
- [ ] SSH service restarted
- [ ] Can still SSH with key (TEST THIS!)

---

## 🔐 PHASE 3: 2FA & RBAC Configuration (CRITICAL)

### 3.1 Enable 2FA in Twenty CRM
1. Go to: `https://crm.clepto.io`
2. Login as admin
3. Navigate to: **Settings → Security**
4. Enable **"Require 2FA for all users"**
5. Set up your own 2FA (Google Authenticator / Authy)

- [ ] 2FA enabled globally
- [ ] Admin 2FA configured and tested
- [ ] All existing users prompted for 2FA on next login

### 3.2 Configure RBAC Roles
**Recommended Roles:**
- **Admin** - Full access (you)
- **Manager** - View/edit all data, no system settings
- **User** - View/edit own data only
- **Read-Only** - View-only access

**Steps:**
1. Go to: `https://crm.clepto.io/settings/workspace/members`
2. Review existing users
3. Assign appropriate roles
4. Test permissions by logging in as different roles

- [ ] Roles defined (Admin, Manager, User, Read-Only)
- [ ] All users assigned appropriate roles
- [ ] Permissions tested for each role
- [ ] No users have excessive permissions

### 3.3 Audit Logs Configuration
```bash
# Twenty CRM has built-in audit logs
# Enable via Settings → Security → Audit Logs

# For system-level logs, configure log rotation:
cat > /etc/logrotate.d/docker-containers <<'EOF'
/var/lib/docker/containers/*/*.log {
    rotate 7
    daily
    compress
    missingok
    delaycompress
    copytruncate
}
EOF

# Test logrotate
logrotate -d /etc/logrotate.d/docker-containers
```
- [ ] Twenty CRM audit logs enabled
- [ ] Log retention set to 90 days minimum
- [ ] Docker container logs rotated daily
- [ ] Logrotate tested

---

## 💾 PHASE 4: Backup Automation (CRITICAL)

### 4.1 Schedule Daily Backups
```bash
# Create backup directory
mkdir -p /opt/clepto/backups

# Add cron job for daily backups at 2 AM
crontab -e

# Add this line:
0 2 * * * /opt/clepto/scripts/backup-local.sh >> /var/log/clepto-backup.log 2>&1
```
- [ ] Backup directory created
- [ ] Cron job added (daily at 2 AM)
- [ ] Backup log file created

### 4.2 Test Backup Script
```bash
# Run backup manually
cd /opt/clepto
bash scripts/backup-local.sh

# Verify backup created
ls -lh /opt/clepto/backups/

# Check backup size (should be > 10MB)
du -sh /opt/clepto/backups/
```
- [ ] Manual backup successful
- [ ] Backup file created in `/opt/clepto/backups/`
- [ ] Backup size reasonable (> 10MB)
- [ ] No errors in backup log

### 4.3 Test Database Restore
```bash
# Create test database
docker exec -it clepto-db psql -U clepto -c "CREATE DATABASE test_restore;"

# Find latest backup
LATEST_BACKUP=$(ls -t /opt/clepto/backups/*.sql.gz | head -1)

# Restore to test database
gunzip -c $LATEST_BACKUP | docker exec -i clepto-db psql -U clepto -d test_restore

# Verify restore
docker exec -it clepto-db psql -U clepto -d test_restore -c "\dt"

# Cleanup test database
docker exec -it clepto-db psql -U clepto -c "DROP DATABASE test_restore;"
```
- [ ] Test database created
- [ ] Backup restored successfully
- [ ] Tables verified in restored database
- [ ] Test database cleaned up

### 4.4 Configure S3 Backups (Optional but Recommended)
```bash
# Install AWS CLI
apt install awscli -y

# Configure AWS credentials
aws configure
# AWS Access Key ID: <your_key>
# AWS Secret Access Key: <your_secret>
# Default region: us-east-1
# Default output format: json

# Test S3 upload
cd /opt/clepto
bash scripts/backup-to-s3.sh

# Verify in S3 console
```
- [ ] AWS CLI installed
- [ ] AWS credentials configured
- [ ] S3 bucket created
- [ ] Test backup uploaded to S3
- [ ] S3 backup cron job added (optional)

---

## 🔍 PHASE 5: SSL & Certificate Verification

### 5.1 Verify SSL Certificates
```bash
# Check crm.clepto.io certificate
echo | openssl s_client -connect crm.clepto.io:443 -servername crm.clepto.io 2>/dev/null | openssl x509 -noout -dates

# Check mail.clepto.io certificate
echo | openssl s_client -connect mail.clepto.io:443 -servername mail.clepto.io 2>/dev/null | openssl x509 -noout -dates

# Should show valid dates (not expired)
```
- [ ] `crm.clepto.io` SSL valid
- [ ] `mail.clepto.io` SSL valid
- [ ] Certificates expire > 30 days from now
- [ ] Auto-renewal configured (Traefik handles this)

### 5.2 Test Auto-Renewal
```bash
# Check Traefik logs for certificate renewal
docker logs root-traefik-1 | grep -i "certificate"

# Traefik auto-renews 30 days before expiry
# No action needed if using Let's Encrypt
```
- [ ] Traefik certificate renewal logs visible
- [ ] No certificate errors in logs

---

## 📊 PHASE 6: Monitoring & Health Checks

### 6.1 Verify All Services Running
```bash
# Check all containers
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Expected containers:
# - clepto-db (healthy)
# - clepto-redis (healthy)
# - twenty-server (healthy)
# - twenty-worker (up)
# - notifuse (healthy)
# - clepto-api (up)
```
- [ ] All 6 containers running
- [ ] Health checks passing (where applicable)
- [ ] No restart loops

### 6.2 Test All Endpoints
```bash
# Test CRM
curl -I https://crm.clepto.io

# Test Notifuse
curl -I https://mail.clepto.io

# Test API
curl -I https://crm.clepto.io/api/health

# All should return HTTP/2 200
```
- [ ] `https://crm.clepto.io` returns 200
- [ ] `https://mail.clepto.io` returns 200
- [ ] `https://crm.clepto.io/api/health` returns 200

### 6.3 Configure Uptime Monitoring (Recommended)
**Use a free service like:**
- UptimeRobot (https://uptimerobot.com)
- Better Uptime (https://betteruptime.com)
- Pingdom (https://pingdom.com)

**Monitor:**
- `https://crm.clepto.io` (every 5 min)
- `https://mail.clepto.io` (every 5 min)

- [ ] Uptime monitoring service configured
- [ ] Email alerts enabled
- [ ] Test alert received

---

## 🎯 FINAL GO / NO-GO DECISION

### Critical Blockers (Must be ✅ to go live)
- [ ] **Notifuse deployed and accessible** at `https://mail.clepto.io`
- [ ] **UFW firewall enabled** and tested (can still SSH)
- [ ] **Fail2Ban running** and monitoring SSH
- [ ] **2FA enabled** for all users
- [ ] **Daily backups scheduled** and tested
- [ ] **Backup restore tested** successfully
- [ ] **All containers healthy** (docker ps shows no issues)
- [ ] **SSL certificates valid** for both domains

### Important (Should be ✅ before go-live)
- [ ] Automatic security updates enabled
- [ ] SSH hardened (key-only auth)
- [ ] RBAC roles configured
- [ ] Audit logs enabled
- [ ] Uptime monitoring configured

### Nice-to-Have (Can be done post-launch)
- [ ] S3 backups configured
- [ ] Custom Clepto branding in Twenty
- [ ] Advanced RBAC policies
- [ ] Log aggregation (ELK/Grafana)

---

## 🚀 GO-LIVE COMMAND

**Once all critical blockers are ✅, run:**

```bash
# Final health check
cd /opt/clepto/infra
docker compose ps
docker compose logs --tail=50

# If all green, you're production-ready! 🎉
echo "Clepto OS is PRODUCTION-READY!"
```

---

## 📞 Emergency Rollback

**If something breaks:**

```bash
# Stop all Clepto services
cd /opt/clepto/infra
docker compose down

# Restore from backup
LATEST_BACKUP=$(ls -t /opt/clepto/backups/*.sql.gz | head -1)
gunzip -c $LATEST_BACKUP | docker exec -i clepto-db psql -U clepto -d clepto_os

# Restart services
docker compose up -d

# Check logs
docker compose logs -f
```

---

## 📋 Post-Launch Checklist (Week 1)

- [ ] Day 1: Monitor logs for errors
- [ ] Day 2: Verify backups running automatically
- [ ] Day 3: Test 2FA with a new user
- [ ] Day 7: Review audit logs
- [ ] Day 7: Check disk space usage
- [ ] Day 7: Verify SSL certificates still valid

---

**Last Updated:** 2025-12-27  
**Version:** 1.0  
**Status:** Ready for Production 🚀
