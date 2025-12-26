# 🛡️ AI Robustness Checklist (60-Point Enterprise Edition)

**Purpose:** Validate ANY AI-generated code before deployment  
**Standards:** OWASP Top 10 + API Top 10 + ISO 27001 + SOC 2 + EU AI Act + NIST  
**How to use:** Paste to AI assistant: *"Review my code against this checklist"*

---

## 📊 Complete Breakdown

| Section | Category | Count | Priority |
|---------|----------|-------|----------|
| 1-5 | Secrets & Credentials | 5 | 🔴 CRITICAL |
| 6-11 | Database Security | 6 | 🔴 CRITICAL |
| 12-19 | Authentication & Authorization | 8 | 🔴 CRITICAL |
| 20-26 | Input Validation & XSS | 7 | 🔴 CRITICAL |
| 27-32 | API Gateway & Rate Limiting | 6 | 🔴 CRITICAL |
| 33-40 | Network & DDoS Protection | 8 | 🔴 CRITICAL |
| 41-45 | Third-Party & Supply Chain | 5 | 🔴 CRITICAL |
| 46-48 | Incident Response | 3 | 🔴 CRITICAL |
| 49-53 | Dependencies & Packages | 5 | 🟡 HIGH |
| 54-59 | Error Handling & Logging | 6 | 🟡 HIGH |
| 60-67 | Infrastructure & Docker | 8 | 🟡 HIGH |
| 68-72 | Backup & Recovery | 5 | 🟡 HIGH |
| 73-80 | Privileged Access (PAM) | 8 | 🟡 HIGH |
| 81-88 | Container & OS Hardening | 8 | 🟡 HIGH |
| 89-95 | Monitoring & SIEM | 7 | 🟡 HIGH |
| 96-98 | Security Training | 3 | 🟡 HIGH |
| 99-104 | Data Classification | 6 | 🟠 MEDIUM |
| 105-109 | Performance & DoS | 5 | 🟠 MEDIUM |
| 110-115 | Compliance & Privacy | 6 | 🟠 MEDIUM |
| 116-120 | Code Quality | 5 | 🟢 LOW |
| 121-125 | Deployment & CI/CD | 5 | 🟢 LOW |
| 126-130 | EU AI Act Specifics | 5 | 🟠 MEDIUM |

---

# 🔴 CRITICAL - Network & DDoS Security

## 1. API Gateway & Rate Limiting Architecture
- [ ] API Gateway deployed (Traefik, Kong, or NGINX)
- [ ] Rate limiting: 100 req/min per IP (configurable)
- [ ] Rate limiting: 5 login attempts per minute
- [ ] Request size limit: max 10MB JSON payload
- [ ] Request timeout: 30 seconds enforced
- [ ] Burst protection (sliding window, not fixed)

## 2. Web Application Firewall (WAF) & DDoS Protection
- [ ] WAF deployed (Cloudflare, AWS WAF, or ModSecurity)
- [ ] DDoS volumetric protection (Layer 3/4)
- [ ] Application-layer DDoS (Layer 7) rules enabled
- [ ] OWASP Top 10 rules active (SQLi, XSS, CSRF)
- [ ] Bot detection enabled
- [ ] Geo-blocking configured (if needed)
- [ ] WAF logging enabled for audit

## 3. Network Segmentation & Isolation
- [ ] Client data isolated (separate DB schemas OR separate VPS)
- [ ] Internal network private (no direct internet access except Traefik)
- [ ] n8n instance behind reverse proxy
- [ ] Database internal-only (port 5432 NOT exposed)
- [ ] Admin tools isolated (SSH only from trusted IPs)
- [ ] Webhook endpoints public; core APIs private
- [ ] Network firewall rules documented

## 4. SSL/TLS Hardening
- [ ] TLS 1.2+ minimum (disable 1.0, 1.1)
- [ ] Strong cipher suites only (no NULL, RC4, MD5)
- [ ] HSTS header enabled
- [ ] Certificate auto-renewal verified (Let's Encrypt)
- [ ] Certificate monitoring (alerts 30 days before expiry)
**Test:** `https://www.ssllabs.com/ssltest/` → Grade A+

---

# 🔴 CRITICAL - Secrets & API Keys

## 5. No Hardcoded Secrets
- [ ] Search for: `sk_live`, `sk_test`, `api_key=`, `Bearer`, `password=`
- [ ] No secrets in frontend code (JavaScript bundles expose everything!)
- [ ] All secrets in `.env` file
- [ ] `.env` in `.gitignore`
- [ ] Secrets not in Git history: `git log -p | grep -i password`

## 6. Pre-commit Hook for Secrets
- [ ] Pre-commit hook prevents secret commits
- [ ] Secret scanning CI/CD tool enabled (TruffleHog, GitGuardian)
- [ ] GitHub branch protection enforced
- [ ] Accidental commit procedure documented

---

# 🔴 CRITICAL - Database Security

## 7. SQL Injection Prevention
- [ ] Parameterized queries only - NO string concatenation
  ```javascript
  // ❌ BAD
  db.query(`SELECT * FROM users WHERE email = '${userEmail}'`);
  
  // ✅ GOOD
  db.query('SELECT * FROM users WHERE email = $1', [userEmail]);
  ```
- [ ] Database not exposed to internet
- [ ] Strong database password (20+ characters)
- [ ] Separate database user (not using root/postgres)
- [ ] Database backups configured
- [ ] Connection limits set

---

# 🔴 CRITICAL - Authentication & Authorization

## 8. Password & Token Security
- [ ] Passwords hashed (bcrypt, argon2 - NOT md5/sha1)
- [ ] JWT tokens expire (Access: 1h, Refresh: 7d max)
- [ ] Protected routes have middleware
- [ ] Admin routes require admin role (RBAC)
- [ ] Session timeout configured (30 min)
- [ ] 2FA available for admin accounts
- [ ] Account lockout after 5 failed attempts
- [ ] MFA mandatory for n8n admin

---

# 🔴 CRITICAL - Input Validation & XSS

## 9. XSS Prevention
- [ ] No `dangerouslySetInnerHTML` (or use DOMPurify)
- [ ] No raw `innerHTML` - use `textContent`
- [ ] No `eval()` or `new Function()`
- [ ] Server-side validation (don't trust client-side)
- [ ] Input length limits
- [ ] Email/URL validation
- [ ] File upload validation (type, size, malware scan)

---

# 🔴 CRITICAL - Third-Party & Supply Chain

## 10. Vendor Risk Assessment
- [ ] Vendor list created (n8n, API integrations, hosting)
- [ ] Risk profile per vendor
- [ ] Security assessment questionnaire sent
- [ ] Vendor SOC 2/ISO 27001 certs collected
- [ ] Data Processing Agreement (DPA) signed

## 11. Dependency Supply Chain Security
- [ ] Software Bill of Materials (SBOM) generated
- [ ] License compliance audit
- [ ] Typosquatting detection (verify packages on npmjs.com)
- [ ] Pinned versions only (no `~` or `^` in production)
- [ ] Dependency diffs reviewed

---

# 🔴 CRITICAL - Incident Response

## 12. Incident Response Plan
- [ ] IR Policy document exists
- [ ] IR Team identified
- [ ] Incident severity classification (P1-P4)
- [ ] Escalation matrix created
- [ ] Notification templates prepared
- [ ] 24/7 monitoring configured
- [ ] Response time SLA: <1h acknowledge, <4h containment
- [ ] Root cause analysis conducted within 7 days
- [ ] Stakeholder notification within 72h (GDPR)

---

# 🟡 HIGH - Dependencies & Packages

## 13. Package Security
- [ ] Run `npm audit` - fix all high/critical
- [ ] Verify package names on npmjs.com
- [ ] No deprecated packages
- [ ] Lock file committed (`package-lock.json`)
- [ ] Pin major versions (avoid `"latest"`)

---

# 🟡 HIGH - Error Handling & Logging

## 14. Error Security
- [ ] No stack traces to users
- [ ] All async functions have try-catch
- [ ] No sensitive data in logs
- [ ] Error logging enabled
- [ ] `NODE_ENV=production`
- [ ] Log rotation configured

## 15. Audit Log Management
- [ ] System logs retained 1+ year
- [ ] Admin action logs (every login, config change)
- [ ] Immutable log storage
- [ ] Log encryption (transit AND rest)
- [ ] Automated log cleanup policy

---

# 🟡 HIGH - Infrastructure & Docker

## 16. Container Security
- [ ] Docker images scanned (Trivy, Snyk)
- [ ] No root user in containers
- [ ] Secrets NOT in Dockerfile
- [ ] Container registry secured
- [ ] Only necessary ports exposed (80, 443)
- [ ] Resource limits set (CPU, memory)
- [ ] Health checks configured
- [ ] `.dockerignore` exists

## 17. Operating System Hardening
- [ ] OS updates automated
- [ ] UFW firewall rules logged
- [ ] SSH hardened (password auth disabled, key-only)
- [ ] Root login disabled
- [ ] Fail2Ban enabled
- [ ] Unnecessary services disabled

---

# 🟡 HIGH - Backup & Recovery

## 18. Backup Configuration
- [ ] Automated daily backups
- [ ] Backup retention policy (7-30 days)
- [ ] Offsite backup option (S3 or separate server)
- [ ] Monthly backup restoration test
- [ ] RTO/RPO documented

---

# 🟡 HIGH - Privileged Access Management

## 19. Access Control
- [ ] Admin access logged
- [ ] Admin sessions time-limited (30min idle logout)
- [ ] SSH key rotation (quarterly)
- [ ] Service accounts isolated
- [ ] Quarterly access reviews
- [ ] Dormant account cleanup (>90 days = disable)
- [ ] Offboarding checklist exists

---

# 🟡 HIGH - Secrets Rotation

## 20. Key Management
- [ ] Database password rotated: quarterly
- [ ] API keys rotated: quarterly
- [ ] JWT signing key rotated: annually
- [ ] SSH keys rotated: annually
- [ ] TLS certificates renewed: automatically
- [ ] Old secrets revoked immediately after rotation

---

# 🟡 HIGH - Monitoring & SIEM

## 21. Security Monitoring
- [ ] SIEM deployment (ELK, Splunk, or Wazuh)
- [ ] Log aggregation from all sources
- [ ] Correlation rules configured
- [ ] Alerting templates for privilege escalation, API errors
- [ ] 24/7 monitoring

## 22. Metrics & KPI Dashboards
- [ ] Uptime KPI: target 99.5%
- [ ] Error rate KPI: <0.1%
- [ ] API response time: <500ms (p95)
- [ ] Backup success rate: 100%
- [ ] Security incident count tracked

---

# 🟠 MEDIUM - Data Classification

## 23. Data Protection
- [ ] Classification levels defined (Public, Internal, Confidential, Secret)
- [ ] Classification applied to all data
- [ ] Handling requirements per level
- [ ] Data retention policy documented
- [ ] Automated deletion jobs
- [ ] GDPR "right to erasure" process

## 24. PII Handling
- [ ] PII definition established
- [ ] PII encryption in database
- [ ] PII access logging
- [ ] PII masking in logs
- [ ] Breach notification procedure (within 72h)

---

# 🟠 MEDIUM - Performance & DoS

## 25. DoS Protection
- [ ] No infinite loops
- [ ] No N+1 queries
- [ ] Pagination implemented
- [ ] Max file upload size (50MB)
- [ ] Request timeout (30 seconds)

---

# 🟠 MEDIUM - Compliance & Privacy

## 26. GDPR Compliance
- [ ] Data encryption in transit (HTTPS)
- [ ] User data deletion possible
- [ ] Audit logs enabled
- [ ] Privacy policy page
- [ ] Cookie consent

---

# 🟢 LOW - Code Quality

## 27. Code Standards
- [ ] No console.log in production
- [ ] No unused imports/variables
- [ ] Consistent error messages
- [ ] TypeScript types defined (if TS)
- [ ] Comments for complex logic

---

# 🟢 LOW - Deployment & CI/CD

## 28. Deployment Process
- [ ] Environment variables documented
- [ ] Deployment script exists
- [ ] Rollback procedure documented
- [ ] Health check endpoint
- [ ] Zero-downtime deployment

---

# 🟠 MEDIUM - EU AI Act (High-Risk AI)

## 29. AI Workflow Classification
For workflows using AI (Claude, GPT, etc.):
- [ ] Does workflow make hiring/employment decisions? (= high-risk)
- [ ] Does workflow assess credit/insurance? (= high-risk)
- [ ] Does workflow identify/track people? (= high-risk)

**If HIGH-RISK:**
- [ ] Conformity assessment created
- [ ] Human oversight procedure documented
- [ ] Human override mechanism exists
- [ ] Appeal process defined
- [ ] Documentation stored in `/compliance/HIGH-RISK-AI/`

---

# 🟠 MEDIUM - n8n-Specific Hardening

## 30. n8n Security
- [ ] N8N_SECURE_COOKIE enabled
- [ ] N8N_SESSION_TIMEOUT = 30min
- [ ] N8N_CREDENTIALS_ENCRYPTION_KEY rotated quarterly
- [ ] Webhook token validation enforced
- [ ] Code node restricted to trusted users
- [ ] Unused workflows disabled
- [ ] Credentials quarterly audit

---

# 📋 Pre-Deployment Script

```bash
#!/bin/bash
set -e

echo "🛡️ AI ROBUSTNESS PRE-DEPLOYMENT AUDIT"

# CRITICAL: Secrets
grep -rn "sk_live\|sk_test\|password=" --include="*.js" --include="*.ts" . && exit 1

# CRITICAL: npm audit
npm audit --audit-level=high || exit 1

# CRITICAL: Backups exist
ls -lh /backups/*.sql.gz | tail -1 || exit 1

# CRITICAL: Git history clean
git log -p | grep -i "password\|api_key\|sk_" && exit 1

# HIGH: SSL cert valid
echo | openssl s_client -servername your-domain.com -connect your-domain.com:443 2>/dev/null | grep "Verify return code: 0"

# MEDIUM: IR Plan exists
test -f docs/INCIDENT-RESPONSE-PLAN.md || exit 1

echo "✅ ALL CHECKS PASSED - Ready to deploy!"
```

---

# 📝 Prompt Templates

### Full Security Review
```
Review this code against enterprise security standards:
1. Hardcoded secrets or API keys
2. SQL injection vulnerabilities
3. XSS vulnerabilities  
4. Authentication/authorization issues
5. Rate limiting
6. OWASP Top 10 compliance
Be specific about file names and line numbers.
```

### Compliance Review
```
Review for GDPR, SOC 2, ISO 27001 compliance:
1. Data encryption (transit and rest)
2. Audit logging
3. User data deletion capability
4. Access controls
5. Secure session management
List gaps with remediation steps.
```

### n8n Workflow Review
```
Review this n8n workflow for:
1. Credential exposure
2. Infinite loop risks
3. Error handling
4. Rate limit considerations
5. Data handling security
```

---

# ✅ Sign-Off Checklist

Before production deployment:

- [ ] All 🔴 CRITICAL items fixed
- [ ] `npm audit` = 0 critical/high
- [ ] Backups tested and working
- [ ] SSL certificate valid
- [ ] Rate limiting active
- [ ] Firewall configured (UFW)
- [ ] Fail2Ban active
- [ ] Secrets in `.env` only
- [ ] Incident Response Plan exists
- [ ] Admin accounts have 2FA

**Project:** _______________  
**Signature:** _______________  
**Date:** _______________

---

*Version: 2.0 (60-Point Enterprise Edition)*  
*Standards: OWASP + ISO 27001 + SOC 2 + EU AI Act + NIST*  
*Last Updated: 2025-12-26*
