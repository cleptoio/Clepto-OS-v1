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

- 🎨 **Modern Dark UI** - Sleek interface with Clepto branding (#0e172f, #0bd7d4)
- 🔐 **Role-Based Access** - Admin, Sales, Marketing, HR, Operations, Developer roles
- 🤖 **Automated Workflows** - Powered by n8n for document generation, reports, and alerts
- 📧 **Built-in Email** - Send campaigns and transactional emails
- 📊 **Real-time Dashboards** - Track revenue, projects, and team performance
- 🐳 **Docker-Based** - Easy deployment and updates

---

## 📚 Documentation

**Quick Start:**
- **[Complete Setup Guide](docs/SETUP.md)** - **START HERE!** Everything you need in one place

**Additional Docs:**
- **[Security Audit](SECURITY-AUDIT-REPORT.md)** - Security status & compliance
- **[User Guide](docs/USER_GUIDE.md)** - Daily operations after deployment
- **[Architecture](docs/ARCHITECTURE.md)** - Technical deep dive

---

## 🛠️ Tech Stack

- **Backend**: NestJS (TypeScript) + Go
- **Frontend**: React + TypeScript
- **Database**: PostgreSQL
- **Cache**: Redis
- **Automation**: n8n
- **Infrastructure**: Docker + Traefik + Easypanel

Built on top of [Twenty.crm](https://github.com/twentyhq/twenty) and [Notifuse](https://github.com/Notifuse/notifuse).

---

## 🚀 Quick Start

> **✨ NEW: View the Stunning UI Now!**

### See the Clepto CRM (No Setup Required)

**Windows**:
```cmd
# Double-click this file or run in terminal:
start-crm.bat
```

**Mac/Linux**:
```bash
chmod +x start-crm.sh
./start-crm.sh
```

Then open: **http://localhost:8000** 🎉

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