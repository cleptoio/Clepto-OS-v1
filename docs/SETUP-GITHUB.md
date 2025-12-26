# GitHub Integration & Secrets Setup

## 1. Generate GitHub Personal Access Token (PAT)

> **Required for Easypanel Auto-Deploy**

1. Go to: [https://github.com/settings/tokens](https://github.com/settings/tokens)
2. Click **"Generate new token (classic)"**
3. **Name**: `CLEPTO_DEPLOY_TOKEN`
4. **Scopes**:
   - [x] `repo` (Full control of private repositories)
   - [x] `admin:repo_hook` (For webhooks)
5. **Expiration**: 90 Days (Rotate regularly)
6. Click **Generate token** -> **COPY IT IMMEDIATELY** (You won't see it again).

---

## 2. GitHub Secrets (For CI/CD)

If you use GitHub Actions (optional fallback), set these up:

1. Go to your repo: `Settings` → `Secrets and variables` → `Actions`.
2. Click **New repository secret**.
3. Add the following:

| Secret Name | Value Example | Description |
|-------------|---------------|-------------|
| `VPS_HOST` | `148.230.120.207` | Your VPS IP Address |
| `VPS_USER` | `root` | SSH Username |
| `VPS_SSH_PORT` | `22` | SSH Port (default 22) |
| `VPS_SSH_KEY` | `-----BEGIN OPENSSH PRIVATE KEY...` | Your Private SSH Key |

### Generating the SSH Key

On your local machine:
```bash
# Generate key pair
ssh-keygen -t ed25519 -f ~/.ssh/vps_deploy -N ""

# Copy Private Key (Add to GitHub Secret VPS_SSH_KEY)
cat ~/.ssh/vps_deploy

# Copy Public Key (Add to VPS)
cat ~/.ssh/vps_deploy.pub | ssh root@YOUR_VPS_IP 'cat >> ~/.ssh/authorized_keys'
```
