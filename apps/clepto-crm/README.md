# Clepto CRM - Web Application

Modern, production-ready CRM interface for Clepto OS.

## Features

✨ **Stunning Dark UI** - Modern design with Clepto branding (#0e172f, #0bd7d4)
📊 **Interactive Dashboard** - Stats cards, revenue charts, activity feed
🎯 **Module Navigation** - CRM, Projects, HR, Finance, Docs, Email
📱 **Responsive Design** - Works on desktop, tablet, and mobile
⚡ **Fast & Lightweight** - Vanilla HTML/CSS/JS, no heavy frameworks
🎨 **Smooth Animations** - Polished micro-interactions

## Quick Start

### Local Development

```bash
# Navigate to CRM directory
cd apps/clepto-crm

# Start local server (Python)
python -m http.server 8000 --directory public

# Or using Node.js
npx serve public -p 8000

# Open browser
http://localhost:8000
```

### Production Deployment

The CRM will be served via Docker/Traefik in production (Phase 3).

## Project Structure

```
clepto-crm/
├── public/
│   ├── index.html          # Main application
│   ├── assets/
│   │   ├── css/
│   │   │   └── styles.css  # All styles (Clepto branded)
│   │   ├── js/
│   │   │   └── app.js      # Application logic
│   │   └── images/         # Logo and assets
│   └── ...
└── README.md
```

## Modules

| Module | Status | Description |
|--------|--------|-------------|
| **Dashboard** | ✅ Complete | Overview with stats, charts, activity |
| **Contacts** | ✅ Complete | Contact management |
| **Companies** | 🔄 Planned | Company relationships |
| **Deals** | 🔄 Planned | Sales pipeline |
| **Projects** | ✅ Complete | Project tracking with cards |
| **Tasks** | 🔄 Planned | Task management |
| **HR** | 🔄 Planned | Employee management |
| **Finance** | 🔄 Planned | Invoices and revenue |
| **Docs** | 🔄 Planned | Document repository |
| **Email** | 🔄 Planned | Campaigns (Notifuse integration) |

## Tech Stack

- **HTML5** - Semantic markup
- **CSS3** - Modern styling with CSS custom properties
- **Vanilla JavaScript** - No framework dependencies
- **Chart.js** - Revenue visualization
- **Lucide Icons** - Beautiful icon system
- **Google Fonts** - Inter font family

## Keyboard Shortcuts

- `Ctrl+K` - Focus search bar

## Branding

All UI elements use Clepto branding:
- Primary Background: `#0e172f`
- Accent Color: `#0bd7d4`
- Typography: Inter (Google Fonts)
- Dark theme only

## Next Steps (Phase 4)

1. Backend API integration
2. Full CRUD operations for all modules
3. Real-time updates
4. User authentication
5. Role-based access control
6. Database integration (PostgreSQL)

## Browser Support

- Chrome/Edge (latest)
- Firefox (latest)
- Safari (latest)

---

**Built with ❤️ for Clepto.io**
