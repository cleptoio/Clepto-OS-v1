#!/bin/bash

# Auto-generate strong secrets for .env
echo "APP_SECRET=$(openssl rand -base64 32)"
echo "JWT_SECRET=$(openssl rand -base64 32)"
echo "SESSION_SECRET=$(openssl rand -base64 32)"
echo "PG_PASSWORD=$(openssl rand -base64 24 | tr -d '=' | cut -c1-20)"
