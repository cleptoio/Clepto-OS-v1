# 🛡️ AI Robustness Checklist

**Purpose:** Use this checklist to validate ANY AI-generated code before deployment.  
**How to use:** Paste this to your AI assistant and ask: *"Review my code against this checklist and report any issues."*

---

## 📋 Quick Summary

| Category | Items | Priority |
|----------|-------|----------|
| [1. Secrets & API Keys](#1-secrets--api-keys) | 5 | 🔴 CRITICAL |
| [2. Database Security](#2-database-security) | 6 | 🔴 CRITICAL |
| [3. Authentication & Authorization](#3-authentication--authorization) | 8 | 🔴 CRITICAL |
| [4. Input Validation & XSS](#4-input-validation--xss) | 7 | 🔴 CRITICAL |
| [5. API & Rate Limiting](#5-api--rate-limiting) | 6 | 🟡 HIGH |
| [6. Dependencies & Packages](#6-dependencies--packages) | 5 | 🟡 HIGH |
| [7. Error Handling & Logging](#7-error-handling--logging) | 6 | 🟡 HIGH |
| [8. Infrastructure & Docker](#8-infrastructure--docker) | 8 | 🟡 HIGH |
| [9. Backup & Recovery](#9-backup--recovery) | 5 | 🟡 HIGH |
| [10. Performance & DoS](#10-performance--dos) | 5 | 🟠 MEDIUM |
| [11. Compliance & Privacy](#11-compliance--privacy) | 6 | 🟠 MEDIUM |
| [12. Code Quality](#12-code-quality) | 5 | 🟢 LOW |
| [13. Deployment & CI/CD](#13-deployment--cicd) | 5 | 🟢 LOW |

---

## 🔴 CRITICAL - Must Fix Before Deployment

### 1. Secrets & API Keys

Ask your AI: *"Search this codebase for hardcoded secrets"*

- [ ] **No hardcoded API keys** - Search for: `sk_live`, `sk_test`, `api_key=`, `Bearer`, `password=`
- [ ] **No secrets in frontend code** - JavaScript/React bundles expose everything!
- [ ] **All secrets in `.env` file** - Never in source code
- [ ] **`.env` in `.gitignore`** - Must NOT be committed to Git
- [ ] **Secrets not in Git history** - Run: `git log -p | grep -i password` (should return nothing)

**Fix:** Move all secrets to `.env` file and reference via `process.env.SECRET_NAME`

---

### 2. Database Security

Ask your AI: *"Check for SQL injection vulnerabilities"*

- [ ] **Parameterized queries only** - No string concatenation in SQL
  ```javascript
  // ❌ BAD
  db.query(`SELECT * FROM users WHERE email = '${userEmail}'`);
  
  // ✅ GOOD
  db.query('SELECT * FROM users WHERE email = $1', [userEmail]);
  ```
- [ ] **Database not exposed to internet** - Only accessible within Docker network
- [ ] **Strong database password** - 20+ characters, alphanumeric + symbols
- [ ] **Separate database user** - Not using `root` or `postgres` admin user
- [ ] **Database backups configured** - Daily automated backups
- [ ] **Connection limits set** - Prevent connection exhaustion attacks

---

### 3. Authentication & Authorization

Ask your AI: *"Review authentication implementation for security issues"*

- [ ] **Passwords hashed** - Using bcrypt, argon2, or scrypt (NOT md5/sha1)
- [ ] **JWT tokens expire** - Access: 1 hour, Refresh: 7 days max
  ```javascript
  // ❌ BAD - No expiration
  jwt.sign(payload, secret);
  
  // ✅ GOOD - Has expiration
  jwt.sign(payload, secret, { expiresIn: '1h' });
  ```
- [ ] **Protected routes have middleware** - Auth check before accessing data
- [ ] **Admin routes require admin role** - Role-based access control (RBAC)
- [ ] **No auth bypass** - All private endpoints require valid token
- [ ] **Session timeout configured** - 30 minutes idle timeout
- [ ] **2FA available** - For admin accounts at minimum
- [ ] **Account lockout** - After 5 failed login attempts

---

### 4. Input Validation & XSS

Ask your AI: *"Check for XSS vulnerabilities and missing input validation"*

- [ ] **No `dangerouslySetInnerHTML`** - Or must use DOMPurify
- [ ] **No raw `innerHTML`** - Use `textContent` instead
- [ ] **No `eval()` or `new Function()`** - Never execute user input
- [ ] **Server-side validation** - Don't trust client-side only
- [ ] **Input length limits** - Max characters for all fields
- [ ] **Email/URL validation** - Using proper regex or libraries
- [ ] **File upload validation** - Check type, size, scan for malware

**Fix:** Install `dompurify` for any HTML rendering: `npm install dompurify`

---

## 🟡 HIGH - Fix Before Production Launch

### 5. API & Rate Limiting

Ask your AI: *"Check if rate limiting is implemented"*

- [ ] **Rate limiting on all endpoints** - 100 requests/minute per IP typical
- [ ] **Rate limiting on login** - 5 attempts/minute to prevent brute force
- [ ] **GraphQL depth limiting** - Max depth 10 to prevent query attacks
- [ ] **Request size limits** - Max 10MB for JSON payloads
- [ ] **Timeout configured** - 30 seconds max per request
- [ ] **CORS properly scoped** - NOT using `*` (wildcard)
  ```javascript
  // ❌ BAD
  app.use(cors({ origin: '*' }));
  
  // ✅ GOOD
  app.use(cors({ origin: 'https://yourdomain.com' }));
  ```

---

### 6. Dependencies & Packages

Ask your AI: *"Check if all npm packages are legitimate and up-to-date"*

- [ ] **Run `npm audit`** - Fix all high/critical vulnerabilities
- [ ] **Verify package names** - AI may suggest typo-squatted packages
  - Check download count on npmjs.com (legitimate packages have 1000s+ weekly)
- [ ] **No deprecated packages** - Update to maintained alternatives
- [ ] **Lock file committed** - `package-lock.json` in version control
- [ ] **Pin major versions** - Avoid `"package": "latest"`

**Common AI mistakes:**
- `axios-api` (fake) → Use `axios` (real)
- `huggingface-cli` (fake) → Use `@huggingface/hub` (real)

---

### 7. Error Handling & Logging

Ask your AI: *"Check error handling and ensure no stack traces leak to users"*

- [ ] **No stack traces to users** - Return generic error messages
  ```javascript
  // ❌ BAD
  res.status(500).json({ error: err.stack });
  
  // ✅ GOOD
  console.error('[ERROR]', err); // Log internally
  res.status(500).json({ error: 'Internal server error' });
  ```
- [ ] **All async functions have try-catch** - No unhandled promise rejections
- [ ] **No sensitive data in logs** - No passwords, tokens, PII
- [ ] **Error logging enabled** - Errors saved for debugging
- [ ] **NODE_ENV=production** - Ensures safe error handling
- [ ] **Log rotation configured** - Prevent disk filling up

---

### 8. Infrastructure & Docker

Ask your AI: *"Review Docker configuration for security"*

- [ ] **No root user in containers** - Use non-root where possible
- [ ] **Only necessary ports exposed** - 80, 443 via Traefik only
- [ ] **Database port NOT exposed** - Internal Docker network only
- [ ] **Resource limits set** - CPU and memory limits per container
  ```yaml
  deploy:
    resources:
      limits:
        cpus: '1'
        memory: 1G
  ```
- [ ] **Health checks configured** - Docker restarts unhealthy containers
- [ ] **`.dockerignore` exists** - Excludes node_modules, .env
- [ ] **HTTPS enforced** - HTTP redirects to HTTPS
- [ ] **SSL certificates auto-renewed** - Let's Encrypt or similar

---

### 9. Backup & Recovery

Ask your AI: *"Verify backup configuration"*

- [ ] **Automated daily backups** - Cron job at 2 AM or similar
- [ ] **Backup retention policy** - Keep 7-30 days of backups
- [ ] **Offsite backup option** - S3, Google Cloud, or separate server
- [ ] **Backup tested** - Actually restored once to verify it works
- [ ] **Database backup script exists** - Using `pg_dump` or equivalent

---

## 🟠 MEDIUM - Should Fix Soon

### 10. Performance & DoS

Ask your AI: *"Check for performance issues and DoS vulnerabilities"*

- [ ] **No infinite loops** - Check `while(true)` patterns
- [ ] **No N+1 queries** - Batch database queries where possible
- [ ] **Pagination implemented** - Don't return 10,000 records at once
- [ ] **Max file upload size** - 50MB typical, reject larger
- [ ] **Request timeout** - 30 seconds, then terminate

---

### 11. Compliance & Privacy

Ask your AI: *"Check GDPR and data privacy compliance"*

- [ ] **Data encryption in transit** - HTTPS everywhere
- [ ] **Data encryption at rest** - Encrypted database volumes (optional)
- [ ] **User data deletion possible** - GDPR "right to be forgotten"
- [ ] **Audit logs enabled** - Track who accessed what
- [ ] **Privacy policy page** - Required for user-facing apps
- [ ] **Cookie consent** - If using cookies/tracking

---

## 🟢 LOW - Nice to Have

### 12. Code Quality

Ask your AI: *"Review code quality and identify issues"*

- [ ] **No console.log in production** - Remove or use proper logging
- [ ] **No unused imports/variables** - Clean code
- [ ] **Consistent error messages** - User-friendly language
- [ ] **TypeScript types defined** - If using TypeScript
- [ ] **Comments for complex logic** - Document non-obvious code

---

### 13. Deployment & CI/CD

Ask your AI: *"Review deployment configuration"*

- [ ] **Environment variables documented** - `.env.example` file
- [ ] **Deployment script exists** - Automated deployment
- [ ] **Rollback procedure documented** - How to undo a bad deploy
- [ ] **Health check endpoint** - `/health` returns 200 OK
- [ ] **Zero-downtime deployment** - Blue-green or rolling updates

---

## 🚀 How to Use This Checklist

### For New Projects

1. Copy this file to your project root
2. Paste to your AI: *"Review my project against this checklist"*
3. Fix all 🔴 CRITICAL items before deployment
4. Fix 🟡 HIGH items before production launch
5. Address 🟠 MEDIUM and 🟢 LOW items over time

### For Existing Projects

1. Run: `npm audit` to find vulnerable packages
2. Search for hardcoded secrets: `grep -r "sk_live\|password=" .`
3. Check if `.env` is in `.gitignore`
4. Review authentication middleware
5. Test backup restoration

### Commands to Run

```bash
# Check for secrets in code
grep -rn "sk_live_\|sk_test_\|api_key=\|password=" --include="*.js" --include="*.ts" .

# Check for vulnerable packages
npm audit

# Check for outdated packages
npm outdated

# Verify .gitignore
cat .gitignore | grep -E ".env|node_modules"

# Test database backup
pg_dump -U username dbname | gzip > backup_test.sql.gz
```

---

## 📝 Prompt Templates

### Security Review Prompt
```
I am about to deploy this code to production. Please review it against 
enterprise security standards and identify:
1. Hardcoded secrets or API keys
2. SQL injection vulnerabilities
3. XSS vulnerabilities  
4. Authentication/authorization issues
5. Missing rate limiting
6. Any other security concerns

Be specific about file names and line numbers.
```

### Compliance Review Prompt
```
Review this code for GDPR and SOC 2 compliance. Check for:
1. Data encryption (transit and rest)
2. Audit logging
3. User data deletion capability
4. Access controls and authentication
5. Secure session management

List any compliance gaps with remediation steps.
```

### Infrastructure Review Prompt
```
Review my Docker/infrastructure configuration for:
1. Exposed ports that shouldn't be public
2. Missing resource limits
3. Containers running as root
4. Missing health checks
5. Database security
6. SSL/TLS configuration
```

---

## ✅ Sign-Off Checklist

Before deploying to production, ensure:

- [ ] All 🔴 CRITICAL items are fixed
- [ ] Security review completed by AI
- [ ] `npm audit` shows 0 high/critical vulnerabilities
- [ ] Backups tested and working
- [ ] SSL certificate valid
- [ ] Rate limiting active
- [ ] Firewall configured (UFW)
- [ ] Fail2Ban protecting SSH
- [ ] Secrets in `.env` only (not in code)
- [ ] Admin accounts have 2FA

**Signature:** _______________  
**Date:** _______________  
**Project:** _______________

---

*Created by: Senior Full-Stack Security Engineer, DevOps, Compliance Officer*  
*Last Updated: 2025-12-26*  
*Version: 1.0*
