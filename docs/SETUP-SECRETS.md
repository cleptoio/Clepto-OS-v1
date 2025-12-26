# Production Secrets Setup

**CRITICAL: NEVER commit `.env` to GitHub.**

## Method 1: Auto-Generate (Recommended)

We have included a script to generate secure keys automatically.

1. Run the generation script:
   ```bash
   bash scripts/generate-secrets.sh > secrets.env
   ```

2. Open `secrets.env` and copy the values.

3. Open your production `.env` file:
   ```bash
   nano .env
   ```

4. Paste the specific keys (APP_SECRET, JWT_SECRET, etc.).

5. **Securely delete** the temporary file:
   ```bash
   rm secrets.env
   ```

## Method 2: Manual Generation

Run these commands in your terminal to generate keys one by one:

| Secret | Command |
|--------|---------|
| `APP_SECRET` | `openssl rand -base64 32` |
| `JWT_SECRET` | `openssl rand -base64 32` |
| `SESSION_SECRET` | `openssl rand -base64 32` |
| `PG_PASSWORD` | `openssl rand -base64 24 | tr -d '=' | cut -c1-20` |

### Third-Party Keys
These must be obtained from their respective dashboards:
- `NOTIFUSE_API_KEY`: Notifuse Dashboard
- `N8N_API_KEY`: n8n Dashboard settings
- `BACKUP_S3_*`: AWS IAM Console
