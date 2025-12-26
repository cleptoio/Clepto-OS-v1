# Clepto OS

**A self-hosted, white-label CRM + ERP + HR + Docs + Email platform for agencies and SMEs**

![Clepto OS](https://img.shields.io/badge/Status-In%20Development-yellow)
![License](https://img.shields.io/badge/License-Proprietary-red)

---

## 🚀 What is Clepto OS?

Clepto OS is an all-in-one business operations platform that combines:

- **CRM**: Manage contacts, companies, and deals
- **Project Management**: Kanban boards with drag-and-drop
- **HR Management**: Employees, leaves, onboarding workflows
- **Finance**: Invoice generation and revenue tracking
- **Documents**: Internal SOPs and knowledge base
- **Email**: Campaigns and transactional emails

All in one beautifully designed, self-hosted platform with **full control over your data**.

---

## ✨ Features

### 🖥️ Clepto CRM (Frontend)
- **Dashboard**: Real-time business overview with charts and activity feed.
- **Contacts**: Manage verified contacts with VIP status.
- **Projects**: Kanban-style project tracking.
- **UI/UX**: Premium dark theme designed for enterprise use.

### 🧠 Clepto API (Backend Service)
- **Authentication**: Secure Login/JWT-based session management.
- **Database**: PostgreSQL integration for persistent data.
- **API**: RESTful endpoints for user management and CRM data.
- **Security**: Helmet headers, CORS protection, and input sanitization.

---

## 🚀 Quick Start (Local Development)

### Prerequisites
- Docker & Docker Compose
- Node.js 18+ (optional, for local script execution)

### 1. Start Everything (Frontend + Backend + DB)
**Windows**:
```cmd
start-crm.bat
```

**Mac/Linux**:
```bash
./start-crm.sh
```

This command will:
1. Start the Docker containers (DB, Redis, API, Frontend)
2. Seed the database with the default Admin user
3. Launch the CRM in your browser

### default Credentials
- **Email:** `admin@clepto.io`
- **Password:** `admin123`

---

### Deploy to VPS (Full Setup)

**For Non-Technical Users**: Follow the [Complete Setup Guide](docs/SETUP.md) for step-by-step instructions with screenshots.

### Prerequisites
- A VPS (Ubuntu 24.04) with at least 2GB RAM
- A domain name (e.g., `clepto.io`)
- GitHub account

### Deploy to VPS
1. Follow the [Setup Guide](docs/SETUP.md)
2. Connect your VPS to this GitHub repo
3. Make changes in GitHub → automatic deployment!

---

## 🎨 Branding

Clepto OS uses the Clepto.io brand identity:
- **Primary Background**: `#0e172f` (Deep Navy)
- **Accent Color**: `#0bd7d4` (Cyan)
- **Typography**: Inter / DM Sans

All user-facing elements are branded as "Clepto" with no references to underlying open-source tools.

---

## 📝 License

Proprietary - © 2025 Clepto.io. All rights reserved.

---

## 🆘 Support

For issues or questions:
- Email: support@clepto.io
- Documentation: Check the `docs/` folder

---

**Built with ❤️ by Clepto.io**