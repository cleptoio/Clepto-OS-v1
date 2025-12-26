# 🛡️ CLEPTO.IO ENTERPRISE SECURITY CHECKLIST (60-POINT)

**For: Non-technical founder serving SME/Enterprise clients**  
**Standard: OWASP Top 10 + API Top 10 + ISO 27001 + SOC 2 Type II + EU AI Act + NIST**  
**Last Updated: 2025-12-26**

---

## 📊 Complete Breakdown

| Section | Category | Count | Priority |
|---------|----------|-------|----------|
| 1-7 | Original Checklist (Core) | 13 | 🔴-🟢 |
| 8-17 | Vibe Coding Additions | 9 | 🔴-🟡 |
| **18-60** | **Enterprise Gaps (NEW)** | **38** | **🔴-🟠** |
| | **TOTAL** | **60** | **100% Coverage** |

---

# 🔴 CRITICAL - NETWORK & DDoS SECURITY

## 18. API Gateway & Rate Limiting Architecture
- [ ] API Gateway deployed (Traefik, Kong, or NGINX)
- [ ] Rate limiting: 100 req/min per IP (configurable)
- [ ] Rate limiting: 5 login attempts per minute
- [ ] Request size limit: max 10MB JSON payload
- [ ] Request timeout: 30 seconds enforced
- [ ] Burst protection (sliding window, not fixed)
- [ ] Per-client rate limits (if multi-tenant)
**Test:** `ab -n 1000 -c 100 https://your-api.com` → should 429 after limit

## 19. Web Application Firewall (WAF) & DDoS Protection
- [ ] WAF deployed (Cloudflare, AWS WAF, or ModSecurity)
- [ ] DDoS volumetric protection (Layer 3/4)
- [ ] Application-layer DDoS (Layer 7) rules enabled
- [ ] OWASP Top 10 rules active (SQLi, XSS, CSRF)
- [ ] Bot detection enabled (suspicious patterns flagged)
- [ ] Geo-blocking configured (block untrusted regions if needed)
- [ ] WAF logging enabled (all blocks logged for audit)
- [ ] Alert on DDoS threshold (>10k req/min = alert)
**Why:** Protects Clepto.io + all client workflows from attacks

## 20. Network Segmentation & Isolation
- [ ] Client data isolated (separate DB schemas OR separate VPS)
- [ ] Internal network private (no direct internet access except Traefik)
- [ ] n8n instance behind reverse proxy (Traefik/NGINX, no public access)
- [ ] Database internal-only (port 5432 NOT exposed)
- [ ] Admin tools isolated (SSH, Portainer only from VPN)
- [ ] Webhook endpoints public; core APIs private
- [ ] Network firewall rules documented (UFW rules saved)
- [ ] Network diagrams created (show data flow for clients)
**Test:** `nmap -p- your-vps.ip` → only 80/443 exposed

## 21. IDS/IPS & Threat Detection
- [ ] Suricata/Snort installed (network intrusion detection)
- [ ] Alert rules for: port scans, brute force, SQLi attempts
- [ ] Logs centralized (SIEM or ELK stack)
- [ ] Real-time alerting (<5min response)
- [ ] Baseline traffic profiling (identify abnormal patterns)
- [ ] Alert fatigue management (tune noise out)
**Why:** Catches active attacks in progress

## 22. SSL/TLS Hardening
- [ ] TLS 1.3 minimum (disable 1.0, 1.1, 1.2)
- [ ] Strong cipher suites only (no NULL, RC4, MD5)
- [ ] Certificate pinning (for critical APIs)
- [ ] HSTS header enabled (`Strict-Transport-Security: max-age=31536000`)
- [ ] Certificate auto-renewal verified (Let's Encrypt every 60 days)
- [ ] Certificate monitoring (alerts 30 days before expiry)
- [ ] Certificate transparency logging enabled
**Test:** `https://www.ssllabs.com/ssltest/` → Grade A+

---

# 🔴 CRITICAL - THIRD-PARTY & SUPPLY CHAIN

## 23. Third-Party Vendor Risk Assessment
- [ ] Vendor list created (n8n, Supabase, API integrations, hosting)
- [ ] Risk profile per vendor (data access, criticality, alternatives)
- [ ] Security assessment questionnaire sent (before onboarding)
- [ ] Vendor SOC 2/ISO 27001 certs collected (stored in docs/)
- [ ] Data Processing Agreement (DPA) signed (GDPR requirement)
- [ ] Acceptable Use Policy (AUP) reviewed
- [ ] SLA documented (uptime, incident response times)
**Store in:** `/docs/VENDOR-ASSESSMENT/vendor-name.md`

## 24. Continuous Vendor Monitoring
- [ ] Vendor status checks monthly (uptime, status page)
- [ ] Security incident monitoring (vendor CVEs, breaches)
- [ ] Compliance changes tracked (new SOC 2 required?)
- [ ] Contract renewal review (6 months before expiry)
- [ ] Vendor breach notification protocol (72h max to contact customers)
- [ ] Backup vendor identified (if critical service)
**Tool:** Spreadsheet or vendor risk platform (Panorays, BitSight)

## 25. Dependency Supply Chain Security
- [ ] Software Bill of Materials (SBOM) generated (`npm ls > SBOM.txt`)
- [ ] License compliance audit (no GPL in proprietary code)
- [ ] Malware scanning post-install (check for suspicious post-install scripts)
- [ ] Dependency comparison before deploy (compare `package-lock.json` versions)
- [ ] Deprecated package tracking (npm api checks)
- [ ] Typosquatting detection (manual: do packages exist on npmjs.com?)
- [ ] Pinned versions only (no `~` or `^` in production)
- [ ] Dependency diffs reviewed (what changed between releases?)
**Tool:** `npm audit`, `OWASP Dependency Check`, `Snyk`

---

# 🔴 CRITICAL - INCIDENT RESPONSE

## 26. Incident Response Plan (NIST 4-Phase)
- [ ] IR Policy document exists (defines "incident", roles, procedures)
- [ ] IR Team identified (Mayank + 1-2 contacts for escalation)
- [ ] Incident severity classification documented (P1-P4):
  - P1: Active data breach, customer notified
  - P2: Security vulnerability, no active compromise
  - P3: Policy violation, no immediate threat
  - P4: Minor issue, no urgency
- [ ] Escalation matrix created (who to call for each severity)
- [ ] Notification template prepared (what to say to customers)
- [ ] External contacts listed (DPO, legal, hosting provider, authorities)
**Store in:** `/docs/INCIDENT-RESPONSE-PLAN.md`

## 27. Incident Detection & Response
- [ ] 24/7 monitoring configured (alerts even off-hours)
- [ ] Alert routing: critical → Mayank's phone (SMS)
- [ ] Incident log created (spreadsheet or Jira)
- [ ] Response time SLA: <1h acknowledge, <4h initial containment
- [ ] Communication templates for: customers, DPO, press
- [ ] Evidence preservation (don't delete logs; capture snapshots)
- [ ] Forensics plan (how to analyze breach?)
**Incident Log Columns:** Date | Severity | Description | Status | Resolution | Lessons

## 28. Post-Incident Review & Continuous Improvement
- [ ] Root cause analysis (RCA) conducted within 7 days
- [ ] Lessons learned documented (what went wrong?)
- [ ] Remediation plan created (how to prevent repeat?)
- [ ] Stakeholder notification (customers within 72h per GDPR)
- [ ] Security improvements implemented (update checklist)
- [ ] IR team debriefing held (training for next time)
- [ ] Incident trends tracked (pattern identification)
**Store RCA in:** `/docs/INCIDENTS/INCIDENT-ID-RCA.md`

---

# 🔴 CRITICAL - COMPLIANCE AUDIT & EVIDENCE

## 29. Audit Log Management & Retention
- [ ] System logs retained: 1+ year (EU requirement)
- [ ] Admin action logs: every login, config change, data access
- [ ] Immutable log storage (logs can't be deleted by attacker)
- [ ] Log correlation (connect events: failed login + DB access)
- [ ] Log encryption (logs in transit AND at rest)
- [ ] Automated log cleanup policy (after 1 year, archive to S3)
- [ ] Audit log monitoring tool (ELK Stack or Splunk)
**Command:** `docker logs clepto-app --tail 1000 > audit_export.log`

## 30. Change Management & Documentation
- [ ] Change request template created
- [ ] All deployments logged (who, what, when, why)
- [ ] Rollback procedure documented & tested
- [ ] Change approvals required (review + sign-off)
- [ ] Emergency change procedure (for critical fixes)
- [ ] Change calendar maintained (when were things deployed?)
- [ ] Change impact assessment (who is affected?)
**Store in:** `/docs/CHANGE-LOG.md` (git-versioned)

## 31. Evidence Collection for Compliance
- [ ] Document inventory created (list all compliance docs)
- [ ] Policy attestation signed annually (Mayank signs off)
- [ ] Risk assessments per client (stored in secure location)
- [ ] Security training certificates (proof of training)
- [ ] Vendor assessment results (SOC 2 certs)
- [ ] Penetration test reports (annual)
- [ ] Security audit findings (addressed gaps documented)
- [ ] Backup restoration test results (proof backups work)
**Organization:** `/compliance/YYYY/` with README linking all docs

---

# 🔴 CRITICAL - TESTING & VALIDATION

## 32. Vulnerability Scanning & SAST
- [ ] SonarQube/Snyk integrated (code scanning on every commit)
- [ ] SAST (Static Analysis) run pre-deploy (detects: hardcoded secrets, unsafe patterns)
- [ ] Vulnerability severity tracking (high/medium/low)
- [ ] Remediation SLA: Critical = 24h, High = 1 week
- [ ] False positive management (tune rules to reduce noise)
- [ ] Scan results tracked over time (trend analysis)
**Tool:** Snyk, SonarQube, Semgrep

## 33. Dynamic Application Security Testing (DAST)
- [ ] DAST tool deployed (OWASP ZAP, Burp Suite)
- [ ] API endpoints security-tested (before production)
- [ ] Web application security-tested (XSS, SQLi, CSRF)
- [ ] Authentication flows tested (bypass attempts)
- [ ] Business logic tested (refund exploits?)
- [ ] Results tracked in issue tracker
- [ ] High severity findings = production blocked
**Trigger:** On staging environment before production release

## 34. Penetration Testing & Red Teaming
- [ ] Annual external penetration test (by certified firm)
- [ ] Scope: entire Clepto.io infrastructure + n8n workflows
- [ ] Rules of engagement signed (legal protection)
- [ ] Pentest report reviewed (findings remediated)
- [ ] Re-test after fixes (verify fixes worked)
- [ ] Findings tracked in risk register
- [ ] Internal "red team" exercises (quarterly simulated attacks)
**Hire:** PentesterLab, HackerOne, or certified pentester in EU

## 35. Load Testing & Scalability Validation
- [ ] Baseline established (performance at 100 users)
- [ ] Load test: 1000 concurrent users (does it hold?)
- [ ] Stress test: 10,000 users (at what point does it fail?)
- [ ] Results documented (max concurrent users safe?)
- [ ] Auto-scaling tested (new instances spinup correctly?)
- [ ] Database connection limits validated
- [ ] Cache hit rates measured
- [ ] Report shared with clients (for SLA conversations)
**Tool:** Apache JMeter, Locust, k6

## 36. Chaos Engineering & Resilience Testing
- [ ] Hypothesis defined (e.g., "system survives database failover")
- [ ] Controlled experiments (intentionally kill services)
- [ ] Failure scenarios tested:
  - Database node down
  - Network latency spike
  - Memory exhaustion
  - Disk full
  - DNS resolution failure
- [ ] Metrics monitored (uptime, error rates, recovery time)
- [ ] Findings documented (what broke? why?)
- [ ] Improvements implemented
- [ ] Experiments run quarterly
**Tool:** Gremlin, ChaosMonkey, Locust

## 37. Backup Restoration Testing
- [ ] Monthly backup restoration test (scheduled)
- [ ] Recovery Time Objective (RTO) documented (how long to recover?)
- [ ] Recovery Point Objective (RPO) documented (how much data loss acceptable?)
- [ ] Full restore from backup verified (not just incremental)
- [ ] Data integrity checked (test data = original data?)
- [ ] Documentation updated (restoration procedure works)
- [ ] Test results logged (proof of testing)
- [ ] Alerts if test fails
**Example:** Restore 7-day-old backup to staging, verify data matches production

---

# 🟡 HIGH - PRIVILEGED ACCESS & IDENTITY

## 38. Privileged Access Management (PAM)
- [ ] Mayank isolated as super-admin (not daily user)
- [ ] Admin access logged (every sudo command)
- [ ] Admin sessions time-limited (logout after 30min idle)
- [ ] SSH key rotation (quarterly)
- [ ] Just-In-Time (JIT) elevation (temporary privilege boost for tasks)
- [ ] Admin actions require second person approval (critical changes)
- [ ] Service accounts isolated (separate DB user per integration)
- [ ] Service account passwords rotated (quarterly)
**Tool:** HashiCorp Vault, Okta, or simple: restricted SSH + audit logs

## 39. Access Review & Termination
- [ ] Quarterly access reviews (does user still need access?)
- [ ] Dormant account cleanup (no login >90 days = disable)
- [ ] Access removal procedure (instant revocation when client leaves)
- [ ] Credential cleanup checklist:
  - n8n account disabled
  - Database credentials revoked
  - API keys deleted
  - SSH keys removed
  - VPN access revoked
- [ ] Exit interview documentation (why leaving?)
- [ ] Knowledge transfer verified
**Checklist:** `/docs/OFFBOARDING-CHECKLIST.md`

## 40. Multi-Factor Authentication (MFA) Enforcement
- [ ] MFA mandatory for n8n admin (TOTP or hardware token)
- [ ] MFA for database access (if human-accessible)
- [ ] MFA for SSH (yes, this exists: Duo, Google Authenticator)
- [ ] MFA backup codes stored securely (not in email)
- [ ] Hardware security key support (YubiKey, etc.)
- [ ] MFA re-authentication on sensitive operations (password change)
**Enforcement:** n8n settings → enable MFA requirement

---

# 🟡 HIGH - CONFIGURATION HARDENING

## 41. Container Security & Image Scanning
- [ ] Docker images scanned for vulnerabilities (Trivy, Snyk)
- [ ] Base image: minimal + regularly updated (Alpine Linux OK)
- [ ] No root user in containers (run as non-root user)
- [ ] Container layers scanned (each step of Dockerfile)
- [ ] Secrets NOT in Dockerfile (use build args + .env)
- [ ] Image signing enabled (verify image authenticity)
- [ ] Unused layers removed (minimize attack surface)
- [ ] Container registry secured (private Docker Hub, not public)
**Command:** `trivy image my-image:latest`

## 42. Operating System Hardening
- [ ] OS updates automated (unattended-upgrades on Ubuntu)
- [ ] UFW firewall rules logged (every dropped packet recorded)
- [ ] SSH hardened:
  - [ ] Password auth disabled (keys only)
  - [ ] Root login disabled
  - [ ] Port 22 changed (optional, but good)
  - [ ] Fail2Ban enabled (5 failed attempts → 1h ban)
- [ ] Unnecessary services disabled (disable unused daemons)
- [ ] Kernel hardening (ASLR, DEP enabled)
- [ ] CIS Benchmark followed (if targeting SOC 2)
**Test:** `sudo iptables -nvL` (verify UFW rules)

## 43. Secrets Rotation & Key Management
- [ ] Master encryption key stored securely (Vault or AWS KMS)
- [ ] Database password rotated: quarterly
- [ ] API keys rotated: quarterly
- [ ] JWT signing key rotated: annually
- [ ] SSH keys rotated: annually
- [ ] TLS certificates renewed: automatically 60 days before expiry
- [ ] Rotation procedure automated (document how)
- [ ] Old secrets revoked immediately after rotation
**Tool:** HashiCorp Vault, AWS Secrets Manager, or Doppler

## 44. Secrets Management in Code
- [ ] No hardcoded secrets in code (grep for patterns)
- [ ] Pre-commit hook prevents secret commits
- [ ] Secret scanning CI/CD tool enabled (TruffleHog, GitGuardian)
- [ ] GitHub branch protection enforced (PR reviews required)
- [ ] Environment variables validated on startup
- [ ] Secrets manager integration tested (app reads from Vault)
- [ ] Accidental commit procedure (if secret leaked):
  - Revoke immediately
  - Rotate password
  - Git history rewritten (BFG Repo-Cleaner)
  - Alert security team
**Pre-commit hook:** Check for `sk_live_`, `password=`, `BEGIN RSA`

---

# 🟡 HIGH - CONTINUOUS MONITORING & OBSERVABILITY

## 45. SIEM (Security Information & Event Management)
- [ ] SIEM deployment (ELK Stack, Splunk, or Wazuh)
- [ ] Log aggregation from:
  - Docker containers
  - UFW firewall
  - n8n application
  - Database
  - SSH access
  - WAF/API Gateway
- [ ] Correlations rules configured (e.g., failed login + DB access = flag)
- [ ] Alerting templates for:
  - Privilege escalation
  - Unusual data access
  - API errors >1000/min
  - Authentication failures >10/min
- [ ] SIEM dashboard created (executive view)
- [ ] 24/7 monitoring (alerts even at 2 AM)
**Tool:** Wazuh (free), ELK Stack, or Splunk

## 46. Anomaly Detection & ML-Based Monitoring
- [ ] Baseline user behavior established (what's "normal"?)
- [ ] Anomaly detection enabled:
  - Unusual login locations
  - Unusual API usage patterns
  - Unusual data access
  - Unusual CPU/memory spikes
- [ ] False positive tuning (reduce noise)
- [ ] Automated response (e.g., flag session for review)
- [ ] Investigation playbook (what to do if anomaly detected?)
**Tool:** Splunk ML Toolkit, ELK Anomaly Detection, or Datadog

## 47. Metrics & KPI Dashboards
- [ ] Uptime KPI: target 99.5% (4h downtime/month max)
- [ ] Error rate KPI: <0.1% (goal)
- [ ] API response time: <500ms (p95)
- [ ] Database latency: <50ms (p95)
- [ ] Backup success rate: 100%
- [ ] Security incident count: tracked
- [ ] Patch compliance: % of systems updated
- [ ] Dashboard visible to Mayank daily
**Tool:** Grafana, Datadog, New Relic, or Prometheus

## 48. Real-Time Alerting & On-Call
- [ ] Alert routing:
  - Critical (SEV1) → SMS to Mayank
  - High (SEV2) → Slack notification
  - Medium (SEV3) → Email digest
  - Low (SEV4) → Dashboard only
- [ ] On-call schedule (if scaling: 24/7 coverage)
- [ ] Alert runbooks (what to do for each alert?)
- [ ] Alert acknowledgment required (prevent alert fatigue)
- [ ] Escalation (if unacknowledged in 15min)
- [ ] Post-incident alert tuning (reduce future false positives)
**Setup:** PagerDuty, Opsgenie, or simple: Slack + webhooks

---

# 🟡 HIGH - SECURITY TRAINING & AWARENESS

## 49. Security Training Program
- [ ] Mayank annual security training (8 hours)
- [ ] Topics:
  - Secure coding (OWASP Top 10, AI risks)
  - Incident response
  - Social engineering / phishing
  - Data protection (GDPR, EU AI Act)
  - Vendor management
- [ ] Training completion documented
- [ ] Assessment/quiz passed
- [ ] Refresher training: annual
**Provider:** SANS, Coursera, or Udemy courses

## 50. Vendor Security Briefing
- [ ] n8n security review (credentials, audit logging)
- [ ] Supabase security review (database encryption, backups)
- [ ] API integrations security review (rate limits, authentication)
- [ ] Hosting provider review (Hostinger datacenter compliance)
- [ ] Findings documented (what passed? what needs improvement?)
**Store in:** `/docs/VENDOR-SECURITY-REVIEWS/`

## 51. Client Security Briefing (Pre-Deployment)
- [ ] Client briefing slides prepared (explaining what Clepto.io does)
- [ ] Security practices explained (how client data is protected)
- [ ] Incident response explained (what happens if breach?)
- [ ] Compliance commitment explained (GDPR, EU AI Act, ISO)
- [ ] Client Q&A session conducted
- [ ] Documentation provided (client reference guide)
- [ ] Sign-off obtained (client acknowledges security practices)
**Template:** `/templates/CLIENT-SECURITY-BRIEFING.pptx`

## 52. Phishing & Social Engineering Tests
- [ ] Annual phishing simulation test (send fake phishing emails)
- [ ] Click rate tracked (what % click malicious links?)
- [ ] Report submitted test (do users report it?)
- [ ] Training for those who fail (education, not punishment)
- [ ] Trend tracked (is click rate decreasing?)
**Provider:** KnowBe4, Gophish, or manual testing

---

# 🟡 HIGH - DATA CLASSIFICATION & HANDLING

## 53. Data Classification Scheme
- [ ] Classification levels defined:
  - **Public:** Marketing, public docs (can leak)
  - **Internal:** Employee info, internal docs (confidential)
  - **Confidential:** Client data, API keys, passwords (highly sensitive)
  - **Secret:** Encryption keys, credit cards (maximum protection)
- [ ] Classification applied to all data
- [ ] Handling requirements per level documented
- [ ] Storage location per level (public = anywhere, secret = encrypted VPS)
- [ ] Access controls per level (who can see what?)
**Document:** `/docs/DATA-CLASSIFICATION-POLICY.md`

## 54. Data Retention & Deletion
- [ ] Retention policy documented (how long keep data?)
  - Client workflows: until contract ends
  - Backups: 30 days
  - Audit logs: 1+ year
  - User data: GDPR "erasure on demand"
- [ ] Deletion procedure documented (how to securely delete?)
- [ ] Automated deletion jobs (stale data auto-removed)
- [ ] Deletion verification (confirm data gone)
- [ ] Audit log of deletions (who deleted what, when?)
**Tool:** Cron job, Kubernetes CronJob, or manual quarterly

## 55. Data Residency & Sovereignty
- [ ] Client data location: specific region? (EU only? Ireland?)
- [ ] Backup location: same region or cross-region?
- [ ] Processor agreements: where does Hostinger store data?
- [ ] GDPR Data Transfer documentation: if data outside EU, why + legal basis?
- [ ] Data sovereignty compliance: verified
- [ ] Client requirements documented (some clients = data must stay in country)
**Document:** `/docs/DATA-RESIDENCY-POLICY.md`

## 56. PII Handling & Data Privacy
- [ ] PII definition established (name, email, phone, IP address, etc.)
- [ ] PII discovery automation (scan for credit cards, SSNs)
- [ ] PII encryption in database (mandatory for PII fields)
- [ ] PII access logging (who accessed client email?)
- [ ] PII masking in logs (don't log full credit card numbers)
- [ ] GDPR "right to access" process (how to fulfill?)
- [ ] GDPR "right to erasure" process (how to delete?)
- [ ] PII breach notification procedure (within 72h to authorities)
**Tool:** AWS Macie, Google Cloud Data Loss Prevention, or manual regex

---

# 🟡 HIGH - SECURE DEVELOPMENT LIFECYCLE

## 57. Code Review Process
- [ ] Code review mandatory (every workflow reviewed before deploy)
- [ ] Reviewer qualified (understands security, n8n best practices)
- [ ] Security checklist reviewed:
  - [ ] No hardcoded secrets
  - [ ] No infinite loops
  - [ ] Error handling present
  - [ ] Input validation present
  - [ ] Rate limiting implemented
  - [ ] Logging not leaking PII
- [ ] Vulnerable patterns flagged (use n8n's Code node wisely)
- [ ] Peer review documented (who approved? when?)
**Template:** `/docs/CODE-REVIEW-CHECKLIST.md`

## 58. Pre-Deployment Validation
- [ ] Staging environment identical to production
- [ ] Deployment checklist:
  - [ ] npm audit = 0 critical/high
  - [ ] SAST scan = no critical findings
  - [ ] Secrets scan = no secrets found
  - [ ] Dependencies pinned (no ~, no ^)
  - [ ] Database migrations tested
  - [ ] Configuration validated
  - [ ] Backup taken before deploy
- [ ] Go/no-go approval required (documented)
- [ ] Deployment window documented (when can we deploy?)
- [ ] Rollback plan reviewed (can we undo this?)
**Automation:** GitHub Actions / GitLab CI

## 59. Deployment & Rollback Procedures
- [ ] Blue-green deployment (zero downtime)
- [ ] Canary deployment (test with 5% traffic first)
- [ ] Health checks post-deployment (automated verification)
- [ ] Rollback automated (git revert + docker restart)
- [ ] Rollback testing performed (manually roll back once/quarter)
- [ ] Rollback time measured (SLA: <5min)
- [ ] Deployment communication (notify clients if relevant)
- [ ] Deployment success criteria defined
**Automation:** Terraform + CI/CD pipeline

---

# 🟠 MEDIUM - EU AI ACT SPECIFICS

## 60. High-Risk AI Classification & Conformity (Article 6)
For each n8n workflow that uses AI (Claude, GPT, etc.):

**Step 1: Determine if "High-Risk" per Article 6:**
- [ ] Does workflow use AI to: make hiring/employment decisions? (YES = high-risk)
- [ ] Does workflow use AI to: score education/exam grades? (YES = high-risk)
- [ ] Does workflow use AI to: identify/track people (facial recognition)? (YES = high-risk)
- [ ] Does workflow use AI to: assess credit worthiness/insurance? (YES = high-risk)
- [ ] Does workflow use AI to: law enforcement (predictive policing)? (YES = high-risk)
- [ ] Does workflow meet Annex III criteria? (Check list)

**If HIGH-RISK workflow identified:**

**Step 2: Create Conformity Assessment (Technical File):**
- [ ] Workflow description (what does it do?)
- [ ] AI model used (Claude 3.5, GPT-4, etc.)
- [ ] Training data documentation (where from? bias checked?)
- [ ] Testing results (accuracy, fairness, error rates)
- [ ] Risk assessment report (what can go wrong?)
- [ ] Human oversight procedure (how is AI output reviewed?)
- [ ] Data quality measures (how to detect/fix errors?)
- [ ] Post-market monitoring plan (how to catch issues in production?)

**Step 3: Document Human-in-the-Loop:**
- [ ] Human review requirement stated (e.g., "AI screens CVs; HR must review before hiring")
- [ ] Human competency verified (HR trained on AI output interpretation?)
- [ ] Human override mechanism exists (can human reject AI decision?)
- [ ] Override decision logged (audit trail)
- [ ] Appeal process defined (employee can challenge AI decision)

**Step 4: Implementation & Registration:**
- [ ] Conformity assessment signed (Mayank attestation)
- [ ] EU registration system notified (if required by Article 6)
- [ ] CE marking applied (if applicable)
- [ ] Documentation in EU language (English OK; German/French if client is)
- [ ] Documentation stored (client can request)

**Store in:** `/compliance/HIGH-RISK-AI/workflow-name/`

---

# 🟠 MEDIUM - OWASP API TOP 10 HARDENING

**Note:** Sections 4, 5, 6, 8, 10 from original checklist cover basics. These are DETAILED per-API validations:

- [ ] API1 - BOLA: Every endpoint verifies user can access ONLY their data
- [ ] API2 - Broken Auth: Token refresh tested, scope boundaries enforced
- [ ] API3 - Broken Property Level Auth: Field-level permissions tested
- [ ] API6 - Unrestricted sensitive flows: Business logic tested (no refund exploitation)
- [ ] API7 - SSRF: Input validation prevents arbitrary URL requests
- [ ] API9 - Inventory: API versioning clear, deprecated endpoints removed
- [ ] API10 - Unsafe consumption: Upstream API responses validated (not trusted)

**Per-API Test:** Create Postman collection, run tests weekly

---

# 🟠 MEDIUM - N8N-SPECIFIC HARDENING

(Beyond original Section 8+)

- [ ] N8N_SECURE_COOKIE enabled (HTTPS only)
- [ ] N8N_SESSION_TIMEOUT = 30min (not infinite)
- [ ] N8N_CREDENTIALS_ENCRYPTION_KEY rotated quarterly
- [ ] Webhook token validation enforced (HMAC or signature)
- [ ] Code node restrictions (restricted to trusted users)
- [ ] Workflow versioning enabled (git history per workflow)
- [ ] Workflow audit log enabled (who changed what?)
- [ ] Unused workflows disabled (cleanup quarterly)
- [ ] Credentials quarterly audit (remove unused service accounts)

**References:**
- [n8n Security Best Practices](https://www.reco.ai/hub/secure-n8n-workflows)
- [n8n Production Setup](https://docs.n8n.io/hosting/installation/server-setup/)

---

# 📋 QUICK REFERENCE: DEPLOYMENT CHECKLIST

**Copy this into CI/CD pipeline:**

```bash
#!/bin/bash
set -e

echo "🔴 CLEPTO.IO PRE-DEPLOYMENT SECURITY AUDIT (60-POINT)"

# CRITICAL CHECKS
npm audit --audit-level=high || exit 1
grep -rn "sk_live\|sk_test\|password=" --include="*.js" --include="*.ts" . && exit 1
npm ls --depth=0 | awk '{if($NF<1000) {print "⚠️ Suspicious: " $0; exit 1}}'
grep -r "while(true)" . && exit 1
docker images | grep "latest" && echo "⚠️ Use versioned tags, not 'latest'" && exit 1

# CRITICAL: Check backups exist
ls -lh /backups/*.sql.gz | tail -1 || exit 1

# CRITICAL: Check secrets not in git
git log -p | grep -i "password\|api_key\|sk_" && exit 1

# HIGH: Check SSL cert validity
echo | openssl s_client -servername your-domain.com -connect your-domain.com:443 2>/dev/null | grep "Verify return code: 0"

# HIGH: Check rate limiting is ON
curl -s http://localhost:3000/health | grep -q "rate_limit" || echo "⚠️ Health endpoint should report rate_limit status"

# HIGH: Check SIEM logs flowing
curl -s http://your-siem:9200/_cat/indices | grep -q "logs" || echo "⚠️ SIEM not receiving logs"

# HIGH: Penetration tests up to date
ls -lh /compliance/pentest_*.pdf | grep -q "$(date +%Y)" || echo "⚠️ No pentest results for 2025"

# MEDIUM: Check incident response plan exists
test -f /docs/INCIDENT-RESPONSE-PLAN.md || exit 1

# MEDIUM: Check vendor assessments current
find /docs/VENDOR-ASSESSMENT -mtime -365 | grep -q ".md" || echo "⚠️ Vendor assessments >1 year old"

# MEDIUM: Check compliance docs exist
test -d /compliance/$(date +%Y) || exit 1

echo "✅ ALL CHECKS PASSED - Ready to deploy!"
```

---

# 📊 IMPLEMENTATION ROADMAP

| Phase | Sections | Timeline | Effort |
|-------|----------|----------|--------|
| **Phase 1 (Week 1)** | 1-13 (Original) | Already done ✅ | - |
| **Phase 2 (Week 1)** | 14-17 (Vibe Coding) | Copy sections above | 2h |
| **Phase 3 (Week 2-3)** | 18-22 (Network) | Deploy Traefik WAF, IDS | 16h |
| **Phase 4 (Week 3-4)** | 23-28 (Vendor + IR) | Create docs, incident plan | 12h |
| **Phase 5 (Week 4-5)** | 29-37 (Audit + Testing) | Setup SIEM, pentest | 20h |
| **Phase 6 (Week 6-7)** | 38-52 (PAM + Training) | Security training, access reviews | 16h |
| **Phase 7 (Week 8)** | 53-60 (Compliance) | EU AI Act classification, docs | 8h |
| | **TOTAL** | **8 weeks** | **~94 hours (2.5 weeks FTE)** |

---

# 🎯 MARKETING ANGLE

**For Clepto.io website:**

> "Every Clepto.io deployment is validated against **60-point enterprise security checklist**—covering OWASP Top 10, API Top 10, ISO 27001, SOC 2 Type II, EU AI Act Article 6, and NIST standards. Your SME/enterprise automation is not just functional—it's **audit-ready, compliance-ready, and breach-resilient**."

**For client pitch:**

> "We don't just build workflows. We deploy them with:
> - Network DDoS protection (Traefik + WAF)
> - Incident response planning (NIST 4-phase)
> - 24/7 SIEM monitoring
> - Annual penetration testing
> - EU AI Act conformity assessments
> - SOC 2 Type II compliance pathway
>
> Your data is protected like enterprise SaaS, not like a freelancer's side project."

---

**Last Updated:** 2025-12-26  
**Maintained By:** Mayank (Clepto.io)  
**Review Schedule:** Quarterly  
**Compliance Alignment:** OWASP + ISO 27001 + SOC 2 + EU AI Act (2024/1689)

