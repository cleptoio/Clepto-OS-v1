# 🛡️ CLEPTO PROJECT MASTER CHECKLIST
**Version 3.0 (Authorized for Production)**

> **THIS IS THE SINGLE SOURCE OF TRUTH.**
> Implement this checklist for EVERY project to ensure Enterprise-Grade Security, Compliance, and Robustness.

---

## 🏗️ 1. Project Initialization & Architecture

### A. Infrastructure Hardening
- [ ] **Network Isolation**: Database port (5432/3306) NEVER exposed to public internet.
- [ ] **Reverse Proxy**: All traffic via Traefik/Nginx (Ports 80/443 only).
- [ ] **Rate Limiting**: Enforce 100 req/min/IP via simple-rate-limiter or Traefik Middleware.
- [ ] **SSL/TLS**: A+ Grade on SSL Labs (TLS 1.2+, HSTS Enabled).
- [ ] **DDoS Protection**: Basic WAF rules enabled (Cloudflare or ModSecurity).

### B. Secrets Management
- [ ] **No Hardcoded Secrets**: Scan code for `sk_live`, `password`, `api_key`.
- [ ] **Environment Variables**: All secrets loaded from `.env` only.
- [ ] **.gitignore**: Ensure `.env`, `node_modules`, and backup files are ignored.
- [ ] **Secret Rotation**: Plan to rotate keys quarterly.

---

## 🧠 2. AI Robustness & Safety (The Vibe Coding Standard)

### A. Input/Output Safety
- [ ] **No Raw innerHTML**: Use `textContent` or `DOMPurify` for rendering AI text.
- [ ] **No dangerous eval()**: Never execute AI-generated code strings directly.
- [ ] **Output Validation**: Validate JSON structure from LLMs before using it.
- [ ] **Token Limits**: Enforce strict max_tokens to prevent cost spikes.

### B. EU AI Act Compliance (If High Risk)
- [ ] **Human Oversight**: Critical decisions (hiring, credit) require human review.
- [ ] **Transparency**: Users must be told they are interacting with an AI.
- [ ] **Data Governance**: Training data (if fine-tuning) must be documented.

---

## 🔐 3. Security & Compliance (The 60-Point Standard)

### A. Authentication
- [ ] **Strong Passwords**: Bcrypt/Argon2 hashing (never plain text).
- [ ] **JWT Security**: Short-lived access tokens (15m), HttpOnly cookies preferred.
- [ ] **RBAC**: Enforce role-based access on ALL backend routes.

### B. Database
- [ ] **SQL Injection**: Use parameterized queries (ORMs like Prisma/TypeORM do this).
- [ ] **Backups**: Automated daily backups to S3/Offsite.
- [ ] **Encryption**: Encrypt sensitive PII (emails, phone numbers) at rest.

### C. Monitoring & Logs
- [ ] **Audit Logs**: Log who did what (User X deleted Project Y).
- [ ] **Error Masks**: Never show stack traces to users in production.
- [ ] **Uptime**: Setup UptimeRobot or similar checking `/health` endpoint.

---

## 📋 4. Deployment & Handover

- [ ] **Pre-Flight Check**: usage of `npm audit` shows 0 critical vulnerabilities.
- [ ] **Clean Git History**: No secrets in commit history.
- [ ] **Documentation**: `README.md` includes setup, env vars, and architecture.
- [ ] **Vendor Assessment**: Review used 3rd party APIs for security.

---

## ✍️ Sign-Off
**Project Name:** _______________________
**Developer:** _______________________
**Date:** _______________________
**Status:** [ ] READY FOR PRODUCTION
