#!/bin/bash

if [ "$NODE_ENV" = "production" ]; then
  [ -z "$PG_PASSWORD" ] && echo "ERROR: PG_PASSWORD not set!" && exit 1
  [ "$SERVER_URL" = "http://localhost:3000" ] && echo "ERROR: LOCAL URL in PROD!" && exit 1
  [ "$SERVER_URL" != "https://"* ] && echo "ERROR: Non-HTTPS URL in PROD!" && exit 1
fi
echo "✅ Environment validation passed"
