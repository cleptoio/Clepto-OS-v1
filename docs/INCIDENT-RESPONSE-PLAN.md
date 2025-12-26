# Incident Response Plan

**Version:** 1.0  
**Effective Date:** 2025-12-26  
**Owner:** Mayank Khanvilkar  
**Review Schedule:** Quarterly

---

## 1. Purpose

This document defines Clepto.io's procedures for detecting, responding to, and recovering from security incidents.

---

## 2. Incident Definition

A **security incident** is any event that:
- Compromises confidentiality, integrity, or availability of data
- Violates security policies
- Indicates unauthorized access or data breach

---

## 3. Incident Severity Classification

| Severity | Definition | Response Time | Examples |
|----------|------------|---------------|----------|
| **P1 - Critical** | Active data breach, customer data exposed | 1 hour | Database leaked, ransomware, credentials stolen |
| **P2 - High** | Security vulnerability, no active compromise | 4 hours | Unpatched CVE, misconfiguration detected |
| **P3 - Medium** | Policy violation, no immediate threat | 24 hours | Unauthorized access attempt, failed logins |
| **P4 - Low** | Minor issue, no urgency | 72 hours | Suspicious but harmless activity |

---

## 4. Incident Response Team

| Role | Name | Contact | Backup |
|------|------|---------|--------|
| **Primary Responder** | Mayank Khanvilkar | mayank.khanvilkar@clepto.io | - |
| **Technical Lead** | Mayank Khanvilkar | Phone: [REDACTED] | - |
| **Communications** | Mayank Khanvilkar | - | - |

**External Contacts:**
- Hostinger Support: support@hostinger.com
- Legal Advisor: [TBD]
- Cyber Insurance: [TBD]
- Irish Data Protection Commission: info@dataprotection.ie

---

## 5. Incident Response Phases (NIST Framework)

### Phase 1: Preparation
- [ ] This IR Plan documented and accessible
- [ ] Backup restoration tested
- [ ] Monitoring tools configured (logs, alerts)
- [ ] Contact list updated
- [ ] Communication templates ready

### Phase 2: Detection & Analysis
1. **Identify the incident:**
   - What happened?
   - When was it detected?
   - Who detected it?
   - What systems are affected?

2. **Assess severity:**
   - Use severity table above
   - Document initial findings

3. **Preserve evidence:**
   - DO NOT delete logs
   - Take screenshots
   - Export relevant logs: `docker logs [container] > incident_log.txt`
   - Create VPS snapshot (Hostinger)

### Phase 3: Containment, Eradication & Recovery
1. **Containment (Stop the bleeding):**
   - Block attacker IP: `sudo ufw deny from [IP]`
   - Disable compromised account
   - Take affected service offline if needed

2. **Eradication (Remove the threat):**
   - Patch vulnerability
   - Remove malicious files
   - Rotate all affected credentials

3. **Recovery (Restore normal operations):**
   - Restore from backup if needed
   - Verify systems are clean
   - Monitor closely for 24-48 hours

### Phase 4: Post-Incident Activity
1. **Root Cause Analysis (within 7 days):**
   - What happened?
   - Why did it happen?
   - How can we prevent it?

2. **Notification (within 72 hours for GDPR):**
   - Notify affected customers
   - Notify Data Protection Authority if required

3. **Lessons Learned:**
   - Update this IR Plan
   - Update security checklist
   - Train on new procedures

---

## 6. Communication Templates

### Customer Notification Template (Data Breach)
```
Subject: Important Security Notice from Clepto.io

Dear [Customer Name],

We are writing to inform you of a security incident that may have affected your data.

What happened: [Brief description]
When it occurred: [Date/time]
What data was affected: [Types of data]
What we are doing: [Actions taken]
What you should do: [Recommendations]

We sincerely apologize and are taking steps to prevent future incidents.

Contact: security@clepto.io

Regards,
Clepto.io Team
```

### Authority Notification Template (GDPR)
```
To: Irish Data Protection Commission
Subject: Data Breach Notification - Clepto.io

Organization: Clepto.io
DPO Contact: mayank.khanvilkar@clepto.io
Date of Discovery: [Date]
Nature of Breach: [Description]
Categories of Data: [Personal data types]
Approximate Number of Affected: [Number]
Consequences: [Potential impact]
Measures Taken: [Actions]
```

---

## 7. Incident Log

| Date | Severity | Description | Status | Resolution | RCA Link |
|------|----------|-------------|--------|------------|----------|
| - | - | - | - | - | - |

---

## 8. Review History

| Date | Reviewer | Changes |
|------|----------|---------|
| 2025-12-26 | Mayank | Initial version |

---

*Reviewed and approved by: Mayank Khanvilkar*  
*Date: 2025-12-26*
