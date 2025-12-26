# 🚀 Clepto OS - Complete Setup Guide for Non-Coders

Welcome! This guide will walk you through setting up Clepto OS on your VPS **step by step**. No coding experience needed!

## 📋 What You'll Need

Before starting, make sure you have:

- ✅ A VPS (Virtual Private Server) with Ubuntu 24.04
  - Minimum: 2GB RAM, 2 CPU cores, 50GB storage
  - Recommended providers: DigitalOcean, Linode, Hetzner, Vultr
- ✅ A domain name (e.g., `clepto.io`)
- ✅ GitHub account (free)
- ✅ SSH client installed on your computer
  - **Windows**: Use built-in PowerShell or download [PuTTY](https://www.putty.org/)
  - **Mac/Linux**: Built-in terminal works!

---

## 🎯 Overview: What We'll Do

1. Set up your VPS (install Docker, configure firewall)
2. Configure your domain DNS
3. Connect your VPS to GitHub (so updates deploy automatically)
4. Deploy Clepto OS
5. Access your platform!

**Estimated Time**: 30-45 minutes

---

## Step 1: Access Your VPS via SSH

### What is SSH?
SSH (Secure Shell) is a way to remotely control your server using commands. Think of it like remote desktop, but with text commands.

### How to Connect

#### On Windows (PowerShell):
1. Press `Windows Key + X` and select "Windows PowerShell" or "Terminal"
2. Type this command (replace with your VPS IP):
   ```powershell
   ssh root@YOUR_VPS_IP_ADDRESS
   ```
   Example: `ssh root@123.45.67.89`

3. First time connecting? You'll see a message asking "Are you sure you want to continue connecting?" Type `yes` and press Enter
4. Enter your VPS password (you received this from your VPS provider)

#### On Mac/Linux:
1. Open Terminal (press `Cmd + Space`, type "Terminal")
2. Type:
   ```bash
   ssh root@YOUR_VPS_IP_ADDRESS
   ```
3. Same as Windows - type `yes` when prompted, then enter your password

> **✏️ Tip**: Your password won't show when typing - that's normal! Just type it and press Enter.

---

## Step 2: Update Your VPS

Once connected, run these commands **one by one** (copy, paste, press Enter):

```bash
# Update package list
apt update

# Upgrade all packages
apt upgrade -y

# Install basic tools
apt install -y curl git ufw fail2ban
```

**What this does**: Updates your server to the latest versions and installs essential security tools.

⏱️ **Wait time**: 2-5 minutes

---

## Step 3: Install Docker

Docker is the technology that runs Clepto OS. Let's install it:

```bash
# Download Docker installation script
curl -fsSL https://get.docker.com -o get-docker.sh

# Run the installer
sh get-docker.sh

# Start Docker automatically on boot
systemctl enable docker

# Start Docker now
systemctl start docker

# Verify Docker is working
docker --version
```

You should see something like: `Docker version 24.0.7, build...`

✅ **Success!** Docker is installed.

---

## Step 4: Install Docker Compose

Docker Compose helps manage multiple Docker containers (services) together.

```bash
# Download Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make it executable
chmod +x /usr/local/bin/docker-compose

# Verify installation
docker-compose --version
```

You should see: `Docker Compose version v2.x.x`

---

## Step 5: Configure Firewall (Security!)

We'll set up a firewall to protect your server. Only allow necessary ports:

```bash
# Allow SSH (so you can connect)
ufw allow 22/tcp

# Allow HTTP (for web traffic)
ufw allow 80/tcp

# Allow HTTPS (for secure web traffic)
ufw allow 443/tcp

# Enable firewall
ufw --force enable

# Check status
ufw status
```

You should see:
```
Status: active

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
80/tcp                     ALLOW       Anywhere
443/tcp                    ALLOW       Anywhere
```

✅ **Firewall configured!**

---

## Step 6: Set Up SSH Key for GitHub

This allows your VPS to automatically pull code from GitHub.

### Generate SSH Key on VPS

```bash
# Generate a new SSH key
ssh-keygen -t ed25519 -C "vps@clepto.io"
```

**When prompted**:
- "Enter file in which to save the key": Press **Enter** (use default)
- "Enter passphrase": Press **Enter** (no passphrase for automation)
- "Enter same passphrase again": Press **Enter**

### Copy Your Public Key

```bash
# Display your public key
cat ~/.ssh/id_ed25519.pub
```

You'll see something like:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... vps@clepto.io
```

**📋 COPY THIS ENTIRE LINE** (including `ssh-ed25519` and the email at the end)

### Add SSH Key to GitHub

1. Go to [GitHub.com](https://github.com) and log in
2. Click your **profile picture** (top right) → **Settings**
3. In left sidebar, click **SSH and GPG keys**
4. Click **New SSH key** (green button)
5. **Title**: Enter "Clepto OS VPS"
6. **Key**: Paste the key you copied
7. Click **Add SSH key**

✅ **GitHub connection ready!**

---

## Step 7: Configure Your Domain DNS

You need to point your domain to your VPS.

### Get Your VPS IP Address

If you're still connected via SSH:
```bash
curl -4 ifconfig.me
```

This shows your public IP (e.g., `123.45.67.89`). **Write this down!**

### Add DNS Records

Log in to your domain registrar (e.g., Namecheap, GoDaddy, Cloudflare) and add these **A records**:

| Type | Name | Value | TTL |
|------|------|-------|-----|
| A | @ | YOUR_VPS_IP | 300 |
| A | crm | YOUR_VPS_IP | 300 |
| A | mail | YOUR_VPS_IP | 300 |
| A | www | YOUR_VPS_IP | 300 |

**Example** (if your domain is `clepto.io` and IP is `123.45.67.89`):
- `@` → `123.45.67.89` (clepto.io)
- `crm` → `123.45.67.89` (crm.clepto.io)
- `mail` → `123.45.67.89` (mail.clepto.io)

⏱️ **Wait 5-10 minutes** for DNS to propagate.

---

## Step 8: Clone Clepto OS Repository

Back in your SSH terminal:

```bash
# Go to home directory
cd ~

# Clone the repository
git clone git@github.com:cleptoio/Clepto-OS-v1.git

# Enter the directory
cd Clepto-OS-v1
```

> **⚠️ Important**: Replace `cleptoio/Clepto-OS-v1` with your actual GitHub username and repo name!

---

## Step 9: Configure Environment Variables

Environment variables are settings for your application (database passwords, domain names, etc.).

```bash
# Copy the example environment file
cp infra/env/.env.example .env

# Edit the file
nano .env
```

### What to Change in .env

You'll see a file with various settings. Use **arrow keys** to navigate. Change these values:

```bash
# Domain Settings
DOMAIN=clepto.io                    # Your domain (without www)
CRM_DOMAIN=crm.clepto.io           # CRM subdomain
MAIL_DOMAIN=mail.clepto.io         # Mail subdomain

# Database Passwords (CHANGE THESE!)
POSTGRES_PASSWORD=CHANGE_ME_TO_STRONG_PASSWORD_1
DB_CRM_PASSWORD=CHANGE_ME_TO_STRONG_PASSWORD_2
DB_MAIL_PASSWORD=CHANGE_ME_TO_STRONG_PASSWORD_3

# Admin Email
ADMIN_EMAIL=your-email@clepto.io   # Your email for SSL certificates

# n8n Settings
N8N_WEBHOOK_URL=https://n8n.clepto.io  # If you have n8n running
```

**To save and exit**:
1. Press `Ctrl + X`
2. Press `Y` (yes to save)
3. Press `Enter` (confirm filename)

> **🔐 Security Tip**: Use strong, random passwords! You can generate them at [passwordsgenerator.net](https://passwordsgenerator.net/)

---

## Step 10: Deploy Clepto OS! 🚀

Now the moment we've been waiting for:

```bash
# Make sure you're in the project directory
cd ~/Clepto-OS-v1

# Start all services
docker-compose -f infra/docker-compose.yml up -d
```

**What `-d` means**: Run in "detached" mode (in the background)

### Monitor the Deployment

```bash
# Watch the logs (press Ctrl+C to stop watching)
docker-compose -f infra/docker-compose.yml logs -f
```

You'll see lots of text scrolling. Look for messages like:
- `✓ Container clepto-crm started`
- `✓ Container clepto-mail started`
- `Server is running on port 3000`

⏱️ **First-time setup takes**: 5-10 minutes (Docker downloads and builds everything)

---

## Step 11: Create Admin User

Once deployment is complete, create your first admin user:

```bash
# Access the CRM container
docker-compose -f infra/docker-compose.yml exec clepto-crm sh

# Inside the container, run the admin creation script
npm run create-admin
```

Follow the prompts to enter:
- **Email**: Your admin email
- **Password**: Your admin password
- **First Name**: Your first name
- **Last Name**: Your last name

Type `exit` to leave the container.

---

## Step 12: Access Clepto OS! 🎉

Open your browser and navigate to:

```
https://crm.clepto.io
```

(Replace `clepto.io` with your actual domain)

You should see the **Clepto OS login page** with your branding!

**Login with**:
- Email: The email you created in Step 11
- Password: The password you created in Step 11

---

## 🔄 How to Make Changes (Auto-Deploy)

Now that everything is set up, here's the magic part - **automatic deployments**!

### Setup Auto-Deploy Script

On your VPS, create a deployment script:

```bash
# Create the script
nano ~/deploy-clepto.sh
```

Paste this content:

```bash
#!/bin/bash

echo "🚀 Deploying Clepto OS updates..."

cd ~/Clepto-OS-v1

echo "📥 Pulling latest code from GitHub..."
git pull origin main

echo "🐳 Rebuilding containers..."
docker-compose -f infra/docker-compose.yml down
docker-compose -f infra/docker-compose.yml up -d --build

echo "🧹 Cleaning up old Docker images..."
docker image prune -f

echo "✅ Deployment complete!"
docker-compose -f infra/docker-compose.yml ps
```

**Save**: `Ctrl + X`, then `Y`, then `Enter`

Make it executable:

```bash
chmod +x ~/deploy-clepto.sh
```

### How to Deploy Updates

Whenever you make changes in GitHub (via Claude or directly):

1. **SSH into your VPS** (like in Step 1)
2. **Run the deploy script**:
   ```bash
   ~/deploy-clepto.sh
   ```
3. **Wait 2-3 minutes** for rebuild
4. **Done!** Your changes are live

---

## 🎨 Making Changes via Claude/GitHub

### Workflow:

1. **Open your repo in VS Code / Claude Desktop**
   - Clone the GitHub repo to your computer
   - Make changes to files (colors, features, text, etc.)

2. **Commit and Push to GitHub**
   ```bash
   git add .
   git commit -m "Updated button colors"
   git push origin main
   ```

3. **Deploy to VPS**
   - SSH into VPS
   - Run `~/deploy-clepto.sh`

4. **See Changes Live!**
   - Refresh `https://crm.clepto.io` in your browser

### Common Files to Edit:

**Change Colors/Branding:**
- `apps/clepto-crm/packages/twenty-front/src/theme/colors.ts`
- `apps/clepto-crm/packages/twenty-front/src/theme/constants.ts`

**Change Logo:**
- Replace files in `apps/clepto-crm/packages/twenty-front/public/logo/`

**Change Text/Labels:**
- Search for the text in the codebase and replace it

---

## 🔐 Security Best Practices

### Change Default SSH Port (Optional but Recommended)

```bash
nano /etc/ssh/sshd_config
```

Find the line `#Port 22` and change to `Port 2222` (or any number between 1024-65535)

Restart SSH:
```bash
systemctl restart sshd
```

**⚠️ Don't forget to update UFW:**
```bash
ufw allow 2222/tcp
ufw delete allow 22/tcp
```

**Next time you connect**:
```bash
ssh -p 2222 root@YOUR_VPS_IP
```

### Set Up Automatic Backups

Create a backup script:

```bash
nano ~/backup-clepto.sh
```

Paste:

```bash
#!/bin/bash

BACKUP_DIR=~/backups
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

echo "🗄️ Backing up databases..."

docker-compose -f ~/Clepto-OS-v1/infra/docker-compose.yml exec -T postgres-crm pg_dump -U clepto clepto_crm > $BACKUP_DIR/crm_$DATE.sql

docker-compose -f ~/Clepto-OS-v1/infra/docker-compose.yml exec -T postgres-mail pg_dump -U clepto clepto_mail > $BACKUP_DIR/mail_$DATE.sql

# Keep only last 7 days of backups
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete

echo "✅ Backup complete: $BACKUP_DIR"
ls -lh $BACKUP_DIR
```

Make executable:
```bash
chmod +x ~/backup-clepto.sh
```

Schedule daily backups (runs at 2 AM):
```bash
crontab -e
```

Add this line:
```
0 2 * * * /root/backup-clepto.sh >> /var/log/clepto-backup.log 2>&1
```

---

## 🛠️ Useful Commands

### Check Status of Services

```bash
cd ~/Clepto-OS-v1
docker-compose -f infra/docker-compose.yml ps
```

### View Logs

```bash
# All services
docker-compose -f infra/docker-compose.yml logs -f

# Specific service
docker-compose -f infra/docker-compose.yml logs -f clepto-crm
```

### Restart a Service

```bash
docker-compose -f infra/docker-compose.yml restart clepto-crm
```

### Stop All Services

```bash
docker-compose -f infra/docker-compose.yml down
```

### Start All Services

```bash
docker-compose -f infra/docker-compose.yml up -d
```

### Check Disk Space

```bash
df -h
```

### Check Memory Usage

```bash
free -h
```

---

## 🚨 Troubleshooting

### "Cannot connect to crm.clepto.io"

**Check:**
1. DNS records are correct (use [whatsmydns.net](https://whatsmydns.net))
2. Services are running: `docker-compose ps`
3. Firewall allows ports 80/443: `ufw status`

### "502 Bad Gateway"

**Solution:**
```bash
# Restart services
cd ~/Clepto-OS-v1
docker-compose -f infra/docker-compose.yml restart
```

### "Out of disk space"

**Solution:**
```bash
# Clean up Docker
docker system prune -a
```

### Services Won't Start

**Check logs:**
```bash
docker-compose -f infra/docker-compose.yml logs
```

Look for error messages and search them online or contact support.

---

## 📞 Getting Help

If you get stuck:

1. **Check the logs** (see Useful Commands above)
2. **Search the error message** on Google/Stack Overflow
3. **Contact support**: support@clepto.io
4. **GitHub Issues**: Open an issue in your repository

---

## 🎓 What You've Accomplished

Congratulations! You've:

✅ Set up a secure VPS
✅ Installed Docker and Docker Compose
✅ Configured DNS and SSL
✅ Deployed Clepto OS
✅ Set up automatic deployments from GitHub
✅ Configured backups

**You're now running your own self-hosted business platform!** 🎉

---

## 📚 Next Steps

1. **Customize branding** - Change colors, logo, text
2. **Add team members** - Create user accounts
3. **Import data** - Add contacts, companies, projects
4. **Set up n8n workflows** - Automate tasks
5. **Configure email** - Set up SMTP for sending emails

Check out other guides in the `docs/` folder for more information!

---

**Need help?** Email: support@clepto.io

**Made with ❤️ by Clepto.io**
