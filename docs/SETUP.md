# 🚀 Complete Setup Guide for Clepto OS

**This is the ONLY guide you need!** Everything in one place, in simple language.

---

## 📋 What You'll Need

Before starting, have these ready:
- ✅ GitHub token (you already have this!)
- ✅ VPS access: `ssh root@148.230.120.207`
- ✅ Domain: `crm.clepto.io` (will configure DNS)
- ✅ n8n: https://n8n.srv1003656.hstgr.cloud/

---

## Step 1: Generate Your Secret Keys (5 minutes)

You need 3 random secret keys for security. 

### Option A: Use Online Generator (Easiest)
1. Go to: https://www.random.org/strings/?num=3&len=32&digits=on&upperalpha=on&loweralpha=on&unique=on&format=html&rnd=new
2. Click "Get Strings"
3. **Copy all 3 strings** and save them in a text file on your computer

### Option B: Use Your VPS
SSH into your VPS and run:
```bash
openssl rand -base64 32
```
Run it 3 times, save each result.

**Save these 3 secrets as:**
- `APP_SECRET`
- `JWT_SECRET`  
- `SESSION_SECRET`

---

## Step 2: Choose a Database Password

Pick a **strong password** (20+ characters, mix of letters/numbers/symbols).

**Save it as:** `PG_PASSWORD`

---

## Step 3: SSH Into Your VPS

Open PowerShell (Windows) or Terminal (Mac):

```powershell
ssh root@148.230.120.207
```

Enter your password when prompted.

---

## Step 4: Create Database

Your PostgreSQL is already running. Create a new database for Clepto:

```bash
docker exec -it postgres-16-alpine psql -U postgres
```

Inside PostgreSQL, paste this (replace `YOUR_PASSWORD` with your Step 2 password):

```sql
CREATE DATABASE clepto_os;
CREATE USER clepto WITH PASSWORD 'YOUR_PASSWORD';
GRANT ALL PRIVILEGES ON DATABASE clepto_os TO clepto;
\q
```

**Example:**
```sql
CREATE DATABASE clepto_os;
CREATE USER clepto WITH PASSWORD 'MyS3cur3P@ssw0rd2024!';
GRANT ALL PRIVILEGES ON DATABASE clepto_os TO clepto;
\q
```

---

## Step 5: Clone Clepto OS from GitHub

Still in your VPS terminal:

```bash
cd /opt
git clone https://github.com/cleptoio/Clepto-OS-v1.git clepto
cd clepto
```

---

## Step 6: Create Your Environment File

Create the `.env` file:

```bash
nano .env
```

Paste this (replace values with YOUR secrets from Steps 1-2):

```env
# ========== BASICS ==========
NODE_ENV=production
DOMAIN=crm.clepto.io
SERVER_URL=https://crm.clepto.io

# ========== SECRETS (from Step 1) ==========
APP_SECRET=PASTE_YOUR_APP_SECRET_HERE
JWT_SECRET=PASTE_YOUR_JWT_SECRET_HERE
SESSION_SECRET=PASTE_YOUR_SESSION_SECRET_HERE

# ========== DATABASE (from Step 2) ==========
PG_HOST=postgres-16-alpine
PG_PORT=5432
PG_DATABASE=clepto_os
PG_USER=clepto
PG_PASSWORD=PASTE_YOUR_DATABASE_PASSWORD_HERE

# ========== EMAIL (Resend) ==========
RESEND_API_KEY=re_K49fDJ7C_BrbYYi9rwuM28guhp8B8PGPi
SMTP_FROM=noreply@clepto.io
ADMIN_EMAIL=mayank.khanvilkar@clepto.io

# ========== n8n ==========
N8N_WEBHOOK_URL=https://n8n.srv1003656.hstgr.cloud/webhook

# ========== SECURITY DEFAULTS (don't change) ==========
JWT_EXPIRES_IN=1h
SESSION_TIMEOUT_MINUTES=30
ENABLE_2FA=true
CORS_ALLOWED_ORIGINS=https://crm.clepto.io
```

**To save:**
- Press `Ctrl + X`
- Press `Y`
- Press `Enter`

---

## Step 7: Configure DNS (Hostinger)

1. Go to **Hostinger Dashboard** → **Domains**
2. Click on `clepto.io` → **DNS / Name Servers**
3. Click **"Add Record"**
4. Add:
   - **Type:** A
   - **Name:** crm
   - **Value:** 148.230.120.207
   - **TTL:** 3600
5. Click **Save**

**Wait 5-10 minutes** for DNS to update.

---

## Step 8: Update Docker Config for Traefik

Your Traefik is already running, so we connect Clepto to it:

```bash
cd /opt/clepto/infra
nano docker-compose.yml
```

Find the `clepto-db` service and **uncomment it** (remove the `#` from all lines).

Then scroll down and find the **networks section at the bottom**. Add this:

```yaml
networks:
  clepto-network:
    driver: bridge
  traefik_public:
    external: true
```

Find the commented `# clepto-crm:` service. **Uncomment it** and update it to:

```yaml
  clepto-crm:
    build: ../apps/clepto-crm
    container_name: clepto-crm
    restart: unless-stopped
    depends_on:
      - clepto-db
    environment:
      DATABASE_URL: postgresql://${PG_USER}:${PG_PASSWORD}@clepto-db:5432/${PG_DATABASE}
      NODE_ENV: ${NODE_ENV}
      RESEND_API_KEY: ${RESEND_API_KEY}
    networks:
      - clepto-network
      - traefik_public
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.clepto.rule=Host(`crm.clepto.io`)"
      - "traefik.http.routers.clepto.entrypoints=websecure"
      - "traefik.http.routers.clepto.tls.certresolver=letsencrypt"
      - "traefik.http.services.clepto.loadbalancer.server.port=3000"
```

**Save:** `Ctrl+X`, `Y`, `Enter`

---

## Step 9: Set Up Automated Backups

```bash
# Make script executable
chmod +x /opt/clepto/scripts/backup-local.sh

# Schedule daily backups at 2 AM
crontab -e

# Add this line (copy-paste):
0 2 * * * /opt/clepto/scripts/backup-local.sh >> /var/log/clepto-backup.log 2>&1
```

**Save:** `Ctrl+X`, `Y`, `Enter`

---

## Step 10: Start Clepto OS

```bash
cd /opt/clepto/infra
docker-compose up -d
```

**This will:**
- Start your database
- Build your application
- Connect to Traefik for SSL

**Wait 2-3 minutes** for everything to start.

---

## Step 11: Check if It's Working

```bash
# Check running containers
docker ps | grep clepto

# Check logs (should say "Server started")
docker logs clepto-crm
```

If you see errors, copy them and ask for help!

---

## Step 12: Test in Browser

Open: **https://crm.clepto.io**

You should see:
- ✅ Green padlock (SSL working)
- ✅ Clepto CRM interface

---

## 🎉 You're Done!

### What You Have Now:
- ✅ Clepto OS running on crm.clepto.io
- ✅ Database connected
- ✅ SSL certificate auto-renewed
- ✅ Daily backups at 2 AM
- ✅ Email ready (Resend)

### Next Steps:
1. **Create Your Account:** First signup becomes admin
2. **Import n8n Workflows:** Upload the 4 JSON files from `automation/n8n-workflows/` to your n8n
3. **Enable 2FA:** Settings → Security

---

## 🆘 Troubleshooting

### Can't access crm.clepto.io?

**Check DNS:**
```bash
nslookup crm.clepto.io
```
Should show: `148.230.120.207`

**Check Traefik:**
```bash
docker logs root-traefik |-1 | grep crm.clepto.io
```

**Check Clepto:**
```bash
docker logs clepto-crm --tail 50
```

### Database Connection Error?

```bash
# Test database connection
docker exec -it postgres-16-alpine psql -U clepto -d clepto_os -c "SELECT 1;"
```

Should return: `1`

### Need to Restart?

```bash
cd /opt/clepto/infra
docker-compose restart
```

---

## 📝 Important Files You Created

Keep these safe:
- **Secrets:** APP_SECRET, JWT_SECRET, SESSION_SECRET
- **Database Password:** The one you chose in Step 2
- **GitHub Token:** For deployments

---

**Need help? Check `docs/USER_GUIDE.md` for daily operations!**
