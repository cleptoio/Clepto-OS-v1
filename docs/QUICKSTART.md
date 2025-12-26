# ⚡ Quick Start - Clepto OS

**Get Clepto OS running in 10 minutes** (for developers with Docker experience)

> **Not a developer?** Use the [Complete Setup Guide](SETUP.md) instead.

---

## Prerequisites

- VPS with Ubuntu 24.04 (2GB RAM minimum)
- Docker & Docker Compose installed
- Domain name with DNS pointed to your VPS
- SSH access to your VPS

---

## 🚀 Steps

### 1. Clone Repository

```bash
ssh root@YOUR_VPS_IP
cd ~
git clone https://github.com/YOUR_USERNAME/Clepto-OS-v1.git
cd Clepto-OS-v1
```

### 2. Configure Environment

```bash
cp infra/env/.env.example .env
nano .env
```

**Update these values**:
```bash
DOMAIN=your-domain.com
CRM_DOMAIN=crm.your-domain.com
MAIL_DOMAIN=mail.your-domain.com
ADMIN_EMAIL=your-email@domain.com

# Change ALL passwords to strong values!
POSTGRES_PASSWORD=your-strong-password
DB_CRM_PASSWORD=your-strong-password
DB_MAIL_PASSWORD=your-strong-password
REDIS_PASSWORD=your-strong-password
JWT_SECRET=your-long-random-string
SESSION_SECRET=your-long-random-string
```

### 3. Set Up Firewall

```bash
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable
```

### 4. Deploy

```bash
# Production deployment
docker-compose -f infra/docker-compose.yml up -d

# Or for local development
docker-compose -f infra/docker-compose.dev.yml up -d
```

### 5. Monitor Deployment

```bash
# Watch logs
docker-compose -f infra/docker-compose.yml logs -f

# Check status
docker-compose -f infra/docker-compose.yml ps
```

### 6. Create Admin User

```bash
# Once CRM is integrated (Phase 3)
docker-compose -f infra/docker-compose.yml exec clepto-crm npm run create-admin
```

### 7. Access

Navigate to: `https://crm.your-domain.com`

---

## 🔄 Auto-Deploy Setup

Make deployment script executable:

```bash
chmod +x ~/Clepto-OS-v1/scripts/deploy.sh
```

When you push changes to GitHub:

```bash
ssh root@YOUR_VPS_IP
~/Clepto-OS-v1/scripts/deploy.sh
```

---

## 📦 What's Included

- ✅ **Docker infrastructure** - Traefik, PostgreSQL, Redis
- ✅ **Auto-deployment script** - One command to update
- ✅ **Automated backups** - Daily database backups
- ✅ **n8n workflows** - Pre-built automation templates
- ✅ **Security setup** - Firewall, SSL, best practices
- ⏳ **CRM (Twenty.crm)** - Coming in Phase 3
- ⏳ **Mail (Notifuse)** - Coming in Phase 5

---

## 🛠️ Useful Commands

```bash
# View logs
docker-compose -f infra/docker-compose.yml logs -f

# Restart services
docker-compose -f infra/docker-compose.yml restart

# Stop all
docker-compose -f infra/docker-compose.yml down

# Manual backup
~/Clepto-OS-v1/scripts/backup.sh

# Deploy updates
~/Clepto-OS-v1/scripts/deploy.sh
```

---

## 📚 More Help

- [Complete Setup Guide](SETUP.md) - Detailed, step-by-step (non-technical friendly)
- [Architecture](ARCHITECTURE.md) - System design and tech stack
- [Security Best Practices](SECURITY.md) - Hardening your deployment

---

## 🎯 Next Steps

1. **Phase 3**: Integrate Twenty.crm as Clepto CRM
2. **Phase 4**: Build custom modules (Projects, HR, Finance)
3. **Phase 5**: Integrate Notifuse for email
4. **Phase 6**: Set up n8n workflows

Refer to the [Implementation Plan](../brain/implementation_plan.md) for details.

---

**🚀 Happy Deploying!**
