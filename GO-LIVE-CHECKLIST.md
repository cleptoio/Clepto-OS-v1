# Clepto CRM - Production Readiness Checklist

**VPS:** 148.230.120.207
**Domain:** crm.clepto.io
**Application:** Twenty CRM (Self-Hosted)

---

## Phase 1: Initial VPS Setup

### 1.1 DNS Configuration
```bash
# Add A record for crm.clepto.io → 148.230.120.207
# Verify DNS propagation:
nslookup crm.clepto.io
```
- [ ] DNS A record created for `crm.clepto.io`
- [ ] DNS propagation verified

### 1.2 Docker Installation
```bash
ssh root@148.230.120.207
apt update && apt upgrade -y
# Install Docker (see START-FROM-START.md for full commands)
docker --version
docker compose version
```
- [ ] Docker Engine installed
- [ ] Docker Compose plugin installed

### 1.3 Traefik Setup
```bash
cd /root/traefik
docker compose up -d
docker logs root-traefik-1
```
- [ ] Traefik container running
- [ ] SSL certificate auto-renewal configured

---

## Phase 2: VPS Security Hardening (CRITICAL)

### 2.1 UFW Firewall Setup
```bash
apt install -y ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp   # SSH
ufw allow 80/tcp   # HTTP
ufw allow 443/tcp  # HTTPS
ufw --force enable
ufw status verbose
```
- [ ] UFW installed
- [ ] Default policies set (deny incoming, allow outgoing)
- [ ] SSH (22), HTTP (80), HTTPS (443) allowed
- [ ] UFW enabled and active
- [ ] Can still SSH after enabling

### 2.2 Fail2Ban Installation
```bash
apt install -y fail2ban

cat > /etc/fail2ban/jail.local <<'EOF'
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
port = 22
logpath = /var/log/auth.log
maxretry = 3
bantime = 86400
EOF

systemctl enable fail2ban
systemctl restart fail2ban
fail2ban-client status sshd
```
- [ ] Fail2Ban installed
- [ ] SSH jail configured (3 attempts = 24h ban)
- [ ] Fail2Ban service running

### 2.3 Automatic Security Updates
```bash
apt install -y unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades
```
- [ ] `unattended-upgrades` installed and enabled

---

## Phase 3: Twenty CRM Deployment

### 3.1 Clone Repository
```bash
mkdir -p /opt/clepto
cd /opt/clepto
git clone https://github.com/cleptoio/Clepto-OS-v1.git .
```
- [ ] Repository cloned to `/opt/clepto`

### 3.2 Configure Environment
```bash
cd /opt/clepto/infra
nano .env  # Add your secrets
```
Required variables:
- [ ] `PG_PASSWORD` - Strong database password
- [ ] `REDIS_PASSWORD` - Redis password
- [ ] `APP_SECRET` - Twenty CRM secret (openssl rand -base64 32)
- [ ] `RESEND_API_KEY` - For email functionality

### 3.3 Create Database
```bash
docker compose up -d clepto-db
sleep 10
docker exec -it clepto-db psql -U clepto -d clepto_os -c "CREATE DATABASE twenty;"
```
- [ ] PostgreSQL container running
- [ ] `twenty` database created

### 3.4 Deploy CRM
```bash
cd /opt/clepto/infra
docker compose up -d
docker compose ps
```
- [ ] All containers running (healthy)
- [ ] No restart loops

### 3.5 Test Access
```bash
curl -I https://crm.clepto.io
# Should return: HTTP/2 200
```
- [ ] `https://crm.clepto.io` accessible
- [ ] SSL certificate valid (green padlock)
- [ ] Twenty CRM login page loads

---

## Phase 4: 2FA & User Configuration

### 4.1 Enable 2FA in Twenty CRM
1. Go to: `https://crm.clepto.io`
2. Login as admin
3. Navigate to: **Settings → Security**
4. Enable **"Require 2FA for all users"**

- [ ] 2FA enabled globally
- [ ] Admin 2FA configured and tested

### 4.2 Configure User Roles
- [ ] Admin role configured (you)
- [ ] Additional users invited with appropriate roles
- [ ] Permissions tested

---

## Phase 5: Backup Automation (CRITICAL)

### 5.1 Schedule Daily Backups
```bash
mkdir -p /opt/clepto/backups

# Add cron job
crontab -e
# Add: 0 2 * * * cd /opt/clepto && bash scripts/backup-local.sh >> /var/log/clepto-backup.log 2>&1
```
- [ ] Backup directory created
- [ ] Cron job added (daily at 2 AM)

### 5.2 Test Backup
```bash
cd /opt/clepto
bash scripts/backup-local.sh
ls -la /opt/clepto/backups/
```
- [ ] Manual backup successful
- [ ] Backup file created

### 5.3 Test Restore
```bash
# Create test database
docker exec -it clepto-db psql -U clepto -c "CREATE DATABASE test_restore;"

# Restore latest backup
LATEST_BACKUP=$(ls -t /opt/clepto/backups/*.sql.gz | head -1)
gunzip -c $LATEST_BACKUP | docker exec -i clepto-db psql -U clepto -d test_restore

# Cleanup
docker exec -it clepto-db psql -U clepto -c "DROP DATABASE test_restore;"
```
- [ ] Test restore successful

---

## Phase 6: SSL & Monitoring

### 6.1 Verify SSL Certificate
```bash
echo | openssl s_client -connect crm.clepto.io:443 -servername crm.clepto.io 2>/dev/null | openssl x509 -noout -dates
```
- [ ] SSL certificate valid
- [ ] Certificate expires > 30 days from now
- [ ] Auto-renewal configured (Traefik handles this)

### 6.2 Verify All Services Running
```bash
docker ps --format "table {{.Names}}\t{{.Status}}"
```
Expected containers:
- [ ] `clepto-db` (healthy)
- [ ] `clepto-redis` (healthy)
- [ ] `twenty-server` (healthy)
- [ ] `twenty-worker` (up)

### 6.3 Configure Uptime Monitoring (Recommended)
Use UptimeRobot, Better Uptime, or similar:
- [ ] Monitor `https://crm.clepto.io` (every 5 min)
- [ ] Email alerts enabled

---

## Final Go/No-Go Decision

### Critical Blockers (Must be ✅ to go live)
- [ ] **Twenty CRM deployed and accessible** at `https://crm.clepto.io`
- [ ] **UFW firewall enabled** and tested
- [ ] **Fail2Ban running** for SSH protection
- [ ] **2FA enabled** for all users
- [ ] **Daily backups scheduled** and tested
- [ ] **Backup restore tested** successfully
- [ ] **All containers healthy**
- [ ] **SSL certificate valid**

### Important (Should be ✅ before go-live)
- [ ] Automatic security updates enabled
- [ ] RBAC roles configured
- [ ] Uptime monitoring configured

---

## Emergency Rollback

If something breaks:

```bash
# Stop all Clepto services
cd /opt/clepto/infra
docker compose down

# Restore from backup
LATEST_BACKUP=$(ls -t /opt/clepto/backups/*.sql.gz | head -1)
gunzip -c $LATEST_BACKUP | docker exec -i clepto-db psql -U clepto -d twenty

# Restart services
docker compose up -d

# Check logs
docker compose logs -f
```

---

## Post-Launch Checklist (Week 1)

- [ ] Day 1: Monitor logs for errors
- [ ] Day 2: Verify backups running automatically
- [ ] Day 3: Test 2FA with a new user
- [ ] Day 7: Review disk space usage
- [ ] Day 7: Verify SSL certificates still valid

---

**Last Updated:** 2025-12-31
**Status:** Ready for Deployment
