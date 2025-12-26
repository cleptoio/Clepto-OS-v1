# Data Classification Policy

**Version:** 1.0  
**Effective Date:** 2025-12-26  
**Owner:** Mayank Khanvilkar

---

## 1. Classification Levels

| Level | Label | Description | Examples |
|-------|-------|-------------|----------|
| **Level 1** | 🟢 **Public** | Can be freely shared | Marketing materials, public docs |
| **Level 2** | 🔵 **Internal** | Clepto.io internal only | Employee info, internal processes |
| **Level 3** | 🟡 **Confidential** | Business-sensitive | Client data, API keys, contracts |
| **Level 4** | 🔴 **Secret** | Maximum protection | Encryption keys, passwords, credit cards |

---

## 2. Handling Requirements

### 🟢 Public
- **Storage:** Anywhere
- **Transmission:** Any method
- **Access:** Anyone
- **Retention:** Until obsolete
- **Disposal:** No special requirements

### 🔵 Internal
- **Storage:** Clepto.io systems only
- **Transmission:** Email OK, avoid public channels
- **Access:** Clepto.io employees only
- **Retention:** 3 years
- **Disposal:** Delete when no longer needed

### 🟡 Confidential
- **Storage:** Encrypted volumes only
- **Transmission:** TLS/HTTPS required, encrypted email preferred
- **Access:** Need-to-know basis
- **Retention:** Per client contract
- **Disposal:** Secure deletion (overwrite), log deletion

### 🔴 Secret
- **Storage:** Encrypted, access-controlled vault (e.g., .env, HashiCorp Vault)
- **Transmission:** Never in plaintext, avoid email
- **Access:** Mayank only, or explicitly authorized
- **Retention:** Until rotated/deprecated
- **Disposal:** Immediate secure deletion, credential rotation

---

## 3. Data Inventory

| Data Type | Classification | Location | Owner |
|-----------|---------------|----------|-------|
| Marketing content | 🟢 Public | Website, GitHub | Mayank |
| Client names | 🟡 Confidential | Database | Mayank |
| Client workflows | 🟡 Confidential | n8n, Database | Mayank |
| Database password | 🔴 Secret | .env file | Mayank |
| API keys (Resend, etc.) | 🔴 Secret | .env file | Mayank |
| Client emails | 🟡 Confidential | Database | Mayank |
| Backup files | 🟡 Confidential | /backups/, Hostinger | Mayank |

---

## 4. PII Definition

The following data types are considered **Personally Identifiable Information (PII)**:
- Full name
- Email address
- Phone number
- Physical address
- IP address
- National ID numbers
- Financial information
- Biometric data

**PII Handling:**
- Always classified as 🟡 Confidential minimum
- Encrypted at rest and in transit
- Access logged
- Masked in logs (no full emails in error logs)
- GDPR rights applicable (access, erasure)

---

## 5. Data Retention

| Data Type | Retention Period | Deletion Method |
|-----------|-----------------|-----------------|
| Client data | Until contract ends + 30 days | Secure deletion |
| Audit logs | 1 year (GDPR compliance) | Automated archival |
| Backups | 30 days | Automated rotation |
| Marketing data | Indefinite | Manual |
| System logs | 90 days | Automated rotation |

---

## 6. Data Deletion Procedure

1. **Identify data to delete** (user request, contract end, retention expiry)
2. **Verify authorization** (who requested? why?)
3. **Create backup** (if needed for audit trail)
4. **Delete from primary storage** (database)
5. **Delete from backups** (if GDPR erasure request)
6. **Verify deletion** (confirm data gone)
7. **Log deletion** (who deleted, what, when)

---

## 7. Review History

| Date | Reviewer | Changes |
|------|----------|---------|
| 2025-12-26 | Mayank | Initial version |

---

*Approved by: Mayank Khanvilkar*  
*Date: 2025-12-26*
