#!/bin/bash
set -e

# ============================================
# Clepto OS - Secure Secrets Generator
# ============================================
# Generates cryptographically secure secrets for production
# Usage: bash scripts/generate-secrets.sh

echo "🔐 Generating secure secrets for Clepto OS..."
echo ""
echo "# ========== COPY THESE TO YOUR .env FILE =========="
echo ""

# Generate 32-byte base64 secrets
APP_SECRET=$(openssl rand -base64 32)
JWT_SECRET=$(openssl rand -base64 32)
SESSION_SECRET=$(openssl rand -base64 32)
REDIS_PASSWORD=$(openssl rand -base64 24 | tr -d '=' | cut -c1-20)

# Generate 20-char alphanumeric database password
PG_PASSWORD=$(openssl rand -base64 24 | tr -d '=+/' | cut -c1-20)

echo "APP_SECRET=$APP_SECRET"
echo "JWT_SECRET=$JWT_SECRET"
echo "SESSION_SECRET=$SESSION_SECRET"
echo "PG_PASSWORD=$PG_PASSWORD"
echo "REDIS_PASSWORD=$REDIS_PASSWORD"
echo ""
echo "# ========== END OF SECRETS =========="
echo ""
echo "⚠️  IMPORTANT: Save these secrets securely!"
echo "⚠️  Never commit .env to Git!"
echo "✅ Secrets generated successfully!"
