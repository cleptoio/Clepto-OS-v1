# Easypanel Auto-Deploy Setup

**Deploy updates automatically on Git Push.**

## Step 1: Connect GitHub
1. Dashboard: Settings → Code Sources → **Add GitHub**.
2. Authorize Easypanel.
3. Select `cleptoio/Clepto-OS-v1`.

## Step 2: Create App
1. **Name**: Clepto CRM
2. **Source**: GitHub (`cleptoio/Clepto-OS-v1`)
3. **Branch**: `main`
4. **Build Type**: Docker Compose

## Step 3: Environment Variables
Go to **App Settings** → **Environment Variables**.
Copy/Paste values from your local `.env`.

> **Tip**: Use Easypanel's "Secrets" tab for sensitive keys.

## Step 4: Enable CI/CD
1. **App Settings** → **Deployments**.
2. Check **"Auto deploy on push to main branch"**.
3. Save.

## Workflow
1. Commit code locally: `git push origin main`
2. Easypanel detects push.
3. Pulls code -> Rebuilds Docker -> Restarts containers.
4. **Zero downtime updates!**
