# Code Review Security Checklist

**For:** Reviewing AI-generated code before deployment  
**Version:** 1.0

---

## Pre-Review Information

| Field | Value |
|-------|-------|
| Reviewer | |
| Date | |
| Component/Feature | |
| AI Tool Used | |
| Commit/PR Link | |

---

## 🔴 CRITICAL Checks (Must all pass)

### Secrets & Credentials
- [ ] No hardcoded API keys (`sk_live_`, `sk_test_`, `api_key=`)
- [ ] No hardcoded passwords (`password=`, `pwd=`)
- [ ] No AWS/GCP credentials in code
- [ ] No private keys in code (`BEGIN RSA`, `BEGIN OPENSSH`)
- [ ] All secrets referenced from `.env`

### Database Security
- [ ] No raw SQL string concatenation
- [ ] All queries use parameterized statements
- [ ] No `SELECT *` without LIMIT
- [ ] Database credentials not exposed

### Input Validation
- [ ] All user inputs validated server-side
- [ ] No `eval()` or `new Function()` on user input
- [ ] No `innerHTML` with unsanitized data
- [ ] File uploads validated (type, size)
- [ ] URLs validated before fetch/redirect

### Authentication
- [ ] JWT tokens have expiration
- [ ] Auth middleware on all private routes
- [ ] Password hashing uses bcrypt/argon2 (not MD5/SHA1)
- [ ] No auth bypass conditions

---

## 🟡 HIGH Checks (Fix before production)

### Error Handling
- [ ] All async functions have try-catch
- [ ] Stack traces not exposed to users
- [ ] Errors logged internally (not to user)
- [ ] No sensitive data in error messages

### Rate Limiting
- [ ] Login endpoint rate-limited
- [ ] API endpoints rate-limited
- [ ] File upload endpoints limited

### Dependencies
- [ ] `npm audit` shows 0 critical/high
- [ ] All packages exist on npmjs.com
- [ ] No typo-squatted package names
- [ ] Versions pinned (no `^` or `~`)

### Configuration
- [ ] `NODE_ENV=production` for prod
- [ ] Debug mode disabled
- [ ] Verbose logging disabled
- [ ] CORS not set to `*`

---

## 🟠 MEDIUM Checks (Fix soon)

### Performance
- [ ] No infinite loops (`while(true)`)
- [ ] No N+1 database queries
- [ ] Pagination on list endpoints
- [ ] Request timeout configured

### Code Quality
- [ ] No `console.log` in production code
- [ ] No unused imports/variables
- [ ] No TODO/FIXME with security implications
- [ ] Error messages user-friendly

### Logging
- [ ] PII not logged (emails, passwords)
- [ ] Sufficient logging for audit trail
- [ ] Log level appropriate (not DEBUG in prod)

---

## 🟢 LOW Checks (Nice to have)

- [ ] Comments for complex logic
- [ ] TypeScript types defined (if TS)
- [ ] Consistent naming conventions
- [ ] Tests exist for critical paths

---

## Review Decision

**Result:** ⬜ Approved | ⬜ Approved with changes | ⬜ Rejected

**Issues Found:**
1. 
2. 
3. 

**Required Changes:**
1. 
2. 
3. 

**Reviewer Signature:** _______________  
**Date:** _______________

---

## AI-Specific Review Questions

When reviewing AI-generated code, also ask:

1. **Does this make sense?** AI may generate plausible-looking nonsense
2. **Is this the standard way?** AI may use deprecated patterns
3. **Does package X exist?** Verify on npmjs.com
4. **Is the logic correct?** AI may have subtle bugs
5. **Is security considered?** AI often ignores security

---

*Template Version: 1.0*  
*Last Updated: 2025-12-26*
