# n8n Workflows - Setup Guide

This directory contains pre-built n8n workflow templates for Clepto OS automation.

## 📋 Available Workflows

### 1. User Onboarding (`01-user-onboarding.json`)
**Trigger**: Webhook when new user is created

**Actions**:
- Sends welcome email via Notifuse
- Notifies admin via Telegram
- Creates role-specific onboarding checklist
- Returns success response

**Setup**:
1. Import into n8n: Settings → Import from File
2. Configure webhook URL in Clepto CRM
3. Update Telegram credentials

---

### 2. Scheduled Reports (`02-scheduled-reports.json`)
**Trigger**: Cron (Every Monday at 8 AM)

**Actions**:
- Fetches weekly metrics from CRM API
- Generates AI summary using Gemini
- Formats HTML email with Clepto branding
- Sends report to admin email

**Setup**:
1. Import into n8n
2. Configure Gemini API credentials
3. Adjust schedule if needed (edit cron expression)

---

### 3. Document Generation (`03-document-generation.json`)
**Trigger**: Webhook for document generation requests

**Actions**:
- Fetches record data (invoice/proposal/report)
- Generates content using AI
- Converts to branded PDF
- Saves to storage
- Updates record with document URL

**Setup**:
1. Import into n8n
2. Configure Gemini API for content generation
3. Set up storage path in environment variables

---

### 4. Alerts & Housekeeping (`04-alerts-housekeeping.json`)
**Trigger**: Cron (Daily at 6 AM)

**Actions**:
- Checks for overdue invoices → Telegram alert
- Finds stale tasks (7+ days inactive) → Emails assignees
- Triggers database backup
- Sends backup confirmation email

**Setup**:
1. Import into n8n
2. Configure Telegram bot
3. Verify backup script path

---

## 🚀 How to Import Workflows

### Step 1: Access n8n

Navigate to your n8n instance (e.g., `https://n8n.clepto.io`)

### Step 2: Import Workflow

1. Click **Workflows** in the left sidebar
2. Click **Import from File**
3. Select a workflow JSON file from this directory
4. Click **Import**

### Step 3: Activate Workflow

1. Open the imported workflow
2. Click **Activate** (toggle in top right)
3. Workflow is now running!

---

## 🔧 Configuration Requirements

### Environment Variables

Add these to your n8n environment or `.env`:

```bash
# CRM API
CRM_API_URL=https://crm.clepto.io
CRM_API_KEY=your-api-key-here

# Mail API
MAIL_DOMAIN=https://mail.clepto.io

# Notifications
TELEGRAM_BOT_TOKEN=your-telegram-bot-token
TELEGRAM_CHAT_ID=your-chat-id

# Admin
ADMIN_EMAIL=admin@clepto.io
```

### Required Credentials in n8n

Configure these credentials in n8n:

1. **Gemini API** (for AI features)
   - Credentials → Add Credential → Google Gemini
   - Enter API key

2. **Telegram** (for notifications)
   - Credentials → Add Credential → Telegram
   - Enter bot token

3. **HTTP Auth** (for API calls)
   - Credentials → Add Credential → Header Auth
   - Name: `Authorization`
   - Value: `Bearer YOUR_API_KEY`

---

## 📝 Customization Tips

### Modify Schedule

Edit the cron expression in Schedule Trigger nodes:

```
0 8 * * 1    = Every Monday at 8 AM
0 6 * * *    = Every day at 6 AM
0 */2 * * *  = Every 2 hours
```

Use [crontab.guru](https://crontab.guru/) to create custom schedules.

### Modify Email Templates

Edit the HTML blocks in workflows to match your branding:

- Update colors (#0e172f, #0bd7d4)
- Change logo URLs
- Modify footer text

### Add More Actions

You can extend workflows by adding nodes:

- **Slack**: Post notifications to Slack
- **Google Sheets**: Log data to spreadsheets
- **Airtable**: Sync data to Airtable
- **Custom HTTP**: Call any API

---

## 🐛 Troubleshooting

### Workflow Not Triggering

**Webhooks**:
- Check webhook URL in CRM settings
- Verify webhook is active in n8n
- Test with manual execution first

**Cron**:
- Check workflow is activated
- Verify cron expression is correct
- Check n8n timezone settings

### API Errors

- Verify API URLs in environment variables
- Check API keys are valid
- Review n8n execution logs

### Email Not Sending

- Verify Notifuse is running
- Check SMTP configuration
- Test with manual email send first

---

## 📚 Learn More

- [n8n Documentation](https://docs.n8n.io)
- [n8n Workflow Templates](https://n8n.io/workflows)
- [Gemini API Docs](https://ai.google.dev/docs)

---

**🤖 Happy Automating!**
