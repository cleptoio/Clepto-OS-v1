#!/bin/bash
#
# Clepto OS - VPS Security Hardening Script
# Run this on your Ubuntu VPS to implement production-grade security
#
# Usage: sudo bash scripts/harden-vps.sh
#

set -e

echo "🔒 Clepto OS - VPS Security Hardening"
echo "======================================"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
   echo "❌ Please run as root (sudo bash scripts/harden-vps.sh)"
   exit 1
fi

echo "📋 This script will:"
echo "  1. Install and configure UFW firewall"
echo "  2. Install and configure Fail2Ban"
echo "  3. Enable automatic security updates"
echo "  4. Harden SSH configuration"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

# ============================================
# 1. UFW Firewall Setup
# ============================================
echo ""
echo "🔥 [1/4] Configuring UFW Firewall..."

apt update -qq
apt install -y ufw

# Default policies
ufw --force default deny incoming
ufw --force default allow outgoing

# Allow SSH (CRITICAL!)
ufw allow 22/tcp comment 'SSH'

# Allow HTTP/HTTPS (Traefik)
ufw allow 80/tcp comment 'HTTP'
ufw allow 443/tcp comment 'HTTPS'

# Enable firewall
ufw --force enable

echo "✅ UFW firewall enabled"
ufw status verbose

# ============================================
# 2. Fail2Ban Installation
# ============================================
echo ""
echo "🚫 [2/4] Installing Fail2Ban..."

apt install -y fail2ban

# Get admin email
read -p "Enter your email for Fail2Ban alerts: " ADMIN_EMAIL

# Create custom jail configuration
cat > /etc/fail2ban/jail.local <<EOF
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5
destemail = ${ADMIN_EMAIL}
sendername = Fail2Ban-CleptOS
action = %(action_mwl)s

[sshd]
enabled = true
port = 22
logpath = /var/log/auth.log
maxretry = 3
bantime = 86400
EOF

# Start and enable Fail2Ban
systemctl enable fail2ban
systemctl restart fail2ban

echo "✅ Fail2Ban installed and configured"
fail2ban-client status

# ============================================
# 3. Automatic Security Updates
# ============================================
echo ""
echo "🔄 [3/4] Enabling Automatic Security Updates..."

apt install -y unattended-upgrades apt-listchanges

# Configure unattended-upgrades
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

echo "✅ Automatic security updates enabled"
unattended-upgrades --dry-run

# ============================================
# 4. SSH Hardening
# ============================================
echo ""
echo "🔐 [4/4] Hardening SSH Configuration..."

# Backup SSH config
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup.$(date +%Y%m%d)

# Check if SSH key authentication is already set up
if [ ! -f ~/.ssh/authorized_keys ] || [ ! -s ~/.ssh/authorized_keys ]; then
    echo "⚠️  WARNING: No SSH keys found in ~/.ssh/authorized_keys"
    echo "⚠️  Disabling password authentication will lock you out!"
    echo ""
    read -p "Do you have SSH key authentication set up? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Please set up SSH key authentication first:"
        echo "   1. On your local machine: ssh-keygen -t ed25519"
        echo "   2. Copy key to VPS: ssh-copy-id root@148.230.120.207"
        echo "   3. Test SSH key login before running this script again"
        echo ""
        echo "Skipping SSH hardening for now..."
        exit 0
    fi
fi

# Harden SSH config
cat >> /etc/ssh/sshd_config <<'EOF'

# Clepto OS Security Hardening
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

# Test SSH config
if sshd -t; then
    echo "✅ SSH configuration valid"
    systemctl restart sshd
    echo "✅ SSH service restarted"
else
    echo "❌ SSH configuration test failed!"
    echo "Restoring backup..."
    cp /etc/ssh/sshd_config.backup.$(date +%Y%m%d) /etc/ssh/sshd_config
    exit 1
fi

# ============================================
# Summary
# ============================================
echo ""
echo "✅ VPS Security Hardening Complete!"
echo "===================================="
echo ""
echo "📊 Summary:"
echo "  ✅ UFW Firewall: Enabled (SSH, HTTP, HTTPS allowed)"
echo "  ✅ Fail2Ban: Running (SSH brute-force protection)"
echo "  ✅ Auto-Updates: Enabled (security patches only)"
echo "  ✅ SSH: Hardened (key-only authentication)"
echo ""
echo "⚠️  IMPORTANT: Test SSH login in a NEW terminal before closing this one!"
echo "   ssh root@148.230.120.207"
echo ""
echo "📋 Next Steps:"
echo "  1. Review GO-LIVE-CHECKLIST.md"
echo "  2. Deploy Notifuse"
echo "  3. Configure 2FA and RBAC"
echo "  4. Set up backups"
echo ""
