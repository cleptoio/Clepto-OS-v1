# Clepto OS User Guide

**Daily workflow for updating and maintaining Clepto OS.**

## How to Update (Daily Workflow)

### 1. Code Changes (UI, Logic)
90% of your updates will follow this flow.

1. **Make Changes Locally**
   ```bash
   nano apps/clepto-crm/public/index.html
   # ... edit code ...
   ```

2. **Test Locally**
   ```bash
   ./start-crm.bat  # Windows
   ```

3. **Push to Production**
   ```bash
   git add .
   git commit -m "feat: updated dashboard layout"
   git push origin main
   ```
   **Result:** Auto-deploy triggers. Live in 2-5 mins.

### 2. Config Changes (Env Vars)
1. Add variable to `.env.example` & commit.
2. **On VPS/Easypanel**: Manually add the new variable value.
3. Restart container.

### 3. Rollback (Undo a Mistake)
If a bug reaches production:

```bash
git revert HEAD
git push origin main
```
This creates a new commit that undoes the last one. Auto-deploy fixes production.

## Monitoring (Weekly)

- **Check Backups**: `aws s3 ls s3://clepto-backups-prod/`
- **Check Disk Space**: `ssh root@x df -h`
- **Check Logs**: `docker logs clepto-crm --tail 50`
