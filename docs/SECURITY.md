# VPS Security Hardening Guide

Follow these steps to secure your Ubuntu 24.04 VPS.

## 1. Firewall (UFW)

Prevent unauthorized access by closing all ports except necessary ones.

```bash
# 1. Install UFW
sudo apt update && sudo apt install -y ufw

# 2. Allow SSH (CRITICAL: Do this first!)
sudo ufw allow ssh
# OR specific port if changed: sudo ufw allow 2222/tcp

# 3. Allow HTTP/HTTPS (Traefik)
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# 4. Deny everything else
sudo ufw default deny incoming
sudo ufw default allow outgoing

# 5. Enable
sudo ufw enable
```

## 2. Fail2Ban (Brute Force Protection)

Ban IPs that blindly attack your SSH port.

```bash
# Install
sudo apt install -y fail2ban

# Configure Jail
sudo nano /etc/fail2ban/jail.local
```

**Paste Configuration:**
```ini
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 5
bantime = 3600
```

```bash
# Restart
sudo systemctl restart fail2ban
```

## 3. Automatic OS Updates

Keep Linux secure automatically.

```bash
sudo apt install -y unattended-upgrades apt-listchanges
sudo nano /etc/apt/apt.conf.d/50unattended-upgrades
```

Uncomment/Add:
```
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "02:00";
```

## 4. Database Isolation

Ensure PostgreSQL is **NOT** exposed to the public internet.

- Run `docker ps`
- Check `clepto-db` PORTS column.
- It should **NOT** show `0.0.0.0:5432`.
- It should only show internal Docker ports (e.g. `5432/tcp`).

If exposed, remove `ports:` section from `docker-compose.yml`.
