# 🚀 Pushing Clepto OS to GitHub

Follow these steps to push your Clepto OS repository to GitHub.

---

## Step 1: Create GitHub Repository

1. Go to [GitHub.com](https://github.com) and log in
2. Click the **+** icon (top right) → **New repository**
3. **Repository name**: `Clepto-OS-v1` (or your preferred name)
4. **Description**: "Self-hosted CRM+ERP+HR platform for Clepto.io"
5. **Visibility**: 
   - Public (initially, as you mentioned)
   - You can change to Private later in Settings
6. **DO NOT** initialize with README, .gitignore, or license (we already have these)
7. Click **Create repository**

---

## Step 2: Connect Local Repository to GitHub

On your **local computer** (not VPS), open PowerShell or Command Prompt:

```powershell
# Navigate to your project
cd "C:\Users\mayan\OneDrive\Desktop\Clepto OS v1\Clepto-OS-v1"

# Add GitHub as remote (replace YOUR-USERNAME)
git remote add origin https://github.com/YOUR-USERNAME/Clepto-OS-v1.git

# Verify remote was added
git remote -v
```

You should see:
```
origin  https://github.com/YOUR-USERNAME/Clepto-OS-v1.git (fetch)
origin  https://github.com/YOUR-USERNAME/Clepto-OS-v1.git (push)
```

---

## Step 3: Push to GitHub

```powershell
# Push to GitHub (main branch)
git push -u origin main
```

**If prompted for credentials**:
- **Username**: Your GitHub username
- **Password**: Use a [Personal Access Token](https://github.com/settings/tokens), NOT your GitHub password
  - Go to GitHub → Settings → Developer settings → Personal access tokens → Generate new token
  - Select scopes: `repo` (full control of private repositories)
  - Copy the token and paste it as your password

---

## Step 4: Verify on GitHub

1. Go to your repository on GitHub: `https://github.com/YOUR-USERNAME/Clepto-OS-v1`
2. You should see all your files:
   - README.md
   - docs/
   - infra/
   - automation/
   - scripts/
   - etc.

✅ **Success!** Your code is now on GitHub.

---

## Step 5: Set Up SSH for VPS (One-Time Setup)

This allows your VPS to automatically pull code from GitHub.

### On Your VPS:

```bash
ssh root@YOUR_VPS_IP

# Generate SSH key
ssh-keygen -t ed25519 -C "vps@clepto.io"

# Press Enter for all prompts (no passphrase)

# Display public key
cat ~/.ssh/id_ed25519.pub
```

**Copy the entire output** (starts with `ssh-ed25519...`)

### On GitHub:

1. Go to your repository → **Settings** → **Deploy keys** (in left sidebar)
2. Click **Add deploy key**
3. **Title**: "Clepto OS VPS"
4. **Key**: Paste the SSH key you copied
5. ☑️ **Allow write access** (if you want to push from VPS)
6. Click **Add key**

### Test SSH Connection (on VPS):

```bash
ssh -T git@github.com
```

You should see: `Hi YOUR-USERNAME! You've successfully authenticated...`

---

## Step 6: Clone Repository on VPS

```bash
# Navigate to home directory
cd ~

# Clone using SSH (replace YOUR-USERNAME)
git clone git@github.com:YOUR-USERNAME/Clepto-OS-v1.git

# Enter directory
cd Clepto-OS-v1

# Verify files
ls -la
```

✅ **Your VPS now has the code!**

---

## 🔄 Workflow: Making Changes

From now on, your workflow is:

### On Your Local Machine (Windows):

```powershell
# Make changes to files (using VS Code, Claude, etc.)

# Check what changed
git status

# Add all changes
git add .

# Commit with descriptive message
git commit -m "Updated button colors to #0bd7d4"

# Push to GitHub
git push origin main
```

### On Your VPS:

```bash
# SSH into VPS
ssh root@YOUR_VPS_IP

# Run deployment script (pulls latest code + redeploys)
~/Clepto-OS-v1/scripts/deploy.sh
```

That's it! Your changes are now live! 🎉

---

## 🔒 Making Repository Private

Once you're ready:

1. Go to your GitHub repository
2. Click **Settings** (tab at the top)
3. Scroll down to **Danger Zone**
4. Click **Change visibility**
5. Select **Make private**
6. Confirm by typing the repository name

**Note**: Private repositories require authentication. Your VPS SSH key will still work!

---

## 📝 GitHub Best Practices

### Branching Strategy (Optional but Recommended)

```powershell
# Create a new branch for features
git checkout -b feature/new-dashboard

# Make changes...

# Commit
git commit -m "Add new dashboard design"

# Push branch to GitHub
git push origin feature/new-dashboard

# On GitHub, create Pull Request to merge into main
```

### Commit Message Tips

Good commit messages:
- ✅ "Fixed login button color to match brand"
- ✅ "Added email validation to user forms"
- ✅ "Updated Docker Compose to include Redis"

Bad commit messages:
- ❌ "fix"
- ❌ "changes"
- ❌ "stuff"

### .gitignore Verification

Make sure you never commit:
- `.env` files (contains passwords!)
- `node_modules/`
- Database files
- Any secrets

Run this to check:
```powershell
git status
```

If `.env` shows up:
```powershell
git rm --cached .env
git commit -m "Remove .env from tracking"
git push
```

---

## 🆘 Troubleshooting

### "Permission denied (publickey)"

**Fix on VPS**:
```bash
# Make sure SSH key is added to GitHub
cat ~/.ssh/id_ed25519.pub

# Copy and add to GitHub → Settings → SSH keys
```

### "Repository not found"

Check:
- Repository name is correct
- Your GitHub username is correct in the URL
- Repository visibility (if private, make sure you're authenticated)

### Merge Conflicts

If VPS has local changes and GitHub has updates:

```bash
cd ~/Clepto-OS-v1

# Stash your local changes
git stash

# Pull from GitHub
git pull origin main

# Re-apply your changes
git stash pop
```

---

## ✅ Next Steps

1. ✅ Push to GitHub (Step 3)
2. ✅ Set up VPS SSH key (Step 5)
3. ✅ Clone on VPS (Step 6)
4. ⏭️ Follow [SETUP.md](SETUP.md) to deploy Clepto OS
5. ⏭️ Start Phase 3: Integrate Twenty.crm

---

**🚀 Happy Pushing!**

Need help? Email: support@clepto.io
