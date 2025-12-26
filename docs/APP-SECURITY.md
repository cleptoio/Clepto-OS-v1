# Application Security Configuration

Policy for securing the Clepto OS application layer.

## 1. Two-Factor Authentication (2FA)

> **Policy: ENFORCED for all users.**

- **Configuration**:
  - `ENABLE_2FA=true` in `.env`
  - `TOTP_WINDOW=1`
- **User Flow**: Users will be prompted to set up TOTP (Google Authenticator) on first login.
- **Backup**: Users must save backup codes offline.

## 2. Role-Based Access Control (RBAC)

Roles are strictly defined to follow the Principle of Least Privilege.

| Role | Permissions |
|------|-------------|
| **Admin** | Full system access. Limit to 1-2 trusted admins. |
| **Manager** | Can manage team/company data, but not system settings. |
| **User** | Limited to assigned projects/tasks. |
| **Guest** | Read-only access (Disabled by default). |

**Setup**: Configure in `Settings` → `Team & Access` → `Roles`.

## 3. Audit Logs

> **Retention: 365 Days** (Compliance Standard)

All critical actions are logged:
- Logins (Success/Failure)
- Record creation/updates/deletions
- Validations and exports

**Access**: `Settings` → `Activity / Audit Log`.

## 4. Session Security

- **Idle Timeout**: 30 Minutes (`SESSION_TIMEOUT_MINUTES=30`)
- **Absolute Timeout**: 8 Hours
- **HTTPS**: Strictly enforced via HSTS headers in Traefik.
