# Offboarding Checklist

**For:** Revoking access when client/user leaves  
**Version:** 1.0

---

## User Information

| Field | Value |
|-------|-------|
| User Name | |
| Email | |
| Role | |
| Exit Date | |
| Reason | Contract end / Voluntary / Termination |
| Knowledge Transfer Complete | ⬜ Yes / ⬜ No / ⬜ N/A |

---

## Access Revocation Checklist

### Application Access
- [ ] n8n account disabled/deleted
- [ ] Database user credentials revoked
- [ ] Application user account disabled
- [ ] All active sessions terminated

### Infrastructure Access
- [ ] SSH key removed from authorized_keys
- [ ] VPN access revoked (if applicable)
- [ ] Admin panel access revoked
- [ ] Monitoring dashboard access revoked

### API & Integrations
- [ ] API keys deleted/rotated
- [ ] OAuth tokens revoked
- [ ] Webhook secrets rotated
- [ ] Third-party integration access removed

### Data Handling
- [ ] User's personal data handled per GDPR
- [ ] Client data exported (if requested)
- [ ] Client data deleted (if contract ended)
- [ ] Backup data marked for exclusion

### Assets
- [ ] Any Clepto.io assets returned (if applicable)
- [ ] Shared passwords rotated
- [ ] Shared accounts access removed

---

## Verification

| Check | Verified By | Date |
|-------|-------------|------|
| Cannot log in to n8n | | |
| Cannot SSH to VPS | | |
| Cannot access database | | |
| Cannot use API keys | | |

---

## Sign-Off

**Completed by:** _______________  
**Date:** _______________  
**Verified by:** _______________  
**Date:** _______________

---

*Template Version: 1.0*  
*Last Updated: 2025-12-26*
