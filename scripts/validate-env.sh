#!/bin/bash
set -e

# ============================================
# Clepto OS - Environment Validation
# ============================================
# Validates .env configuration before deployment
# Usage: bash scripts/validate-env.sh

echo "🔍 Validating environment configuration..."

ERRORS=0

# Check required variables exist
check_var() {
    if [ -z "${!1}" ]; then
        echo "❌ ERROR: $1 is not set!"
        ERRORS=$((ERRORS + 1))
    else
        echo "✅ $1 is set"
    fi
}

# Production-specific checks
if [ "$NODE_ENV" = "production" ]; then
    echo ""
    echo "📋 Production mode detected - running strict checks..."
    echo ""
    
    # Critical secrets
    check_var "APP_SECRET"
    check_var "JWT_SECRET"
    check_var "SESSION_SECRET"
    check_var "PG_PASSWORD"
    
    # Database
    check_var "PG_HOST"
    check_var "PG_DATABASE"
    check_var "PG_USER"
    
    # Domain
    check_var "DOMAIN"
    check_var "SERVER_URL"
    
    # Security: Ensure HTTPS
    if [[ "$SERVER_URL" != https://* ]]; then
        echo "❌ ERROR: SERVER_URL must use HTTPS in production!"
        ERRORS=$((ERRORS + 1))
    fi
    
    # Security: Ensure not localhost
    if [[ "$SERVER_URL" == *"localhost"* ]]; then
        echo "❌ ERROR: SERVER_URL contains 'localhost' in production!"
        ERRORS=$((ERRORS + 1))
    fi
    
    # Check for placeholder values
    if [[ "$PG_PASSWORD" == *"REPLACE"* ]] || [[ "$PG_PASSWORD" == *"STRONG"* ]]; then
        echo "❌ ERROR: PG_PASSWORD still contains placeholder text!"
        ERRORS=$((ERRORS + 1))
    fi
    
    if [[ "$JWT_SECRET" == *"REPLACE"* ]] || [[ "$JWT_SECRET" == *"HERE"* ]]; then
        echo "❌ ERROR: JWT_SECRET still contains placeholder text!"
        ERRORS=$((ERRORS + 1))
    fi
fi

echo ""
if [ $ERRORS -gt 0 ]; then
    echo "❌ Validation FAILED with $ERRORS error(s)"
    echo "⚠️  Fix the above issues before deploying!"
    exit 1
else
    echo "✅ Environment validation PASSED!"
    echo "🚀 Ready for deployment"
fi
