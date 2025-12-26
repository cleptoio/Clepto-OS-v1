// ============================================
// Clepto OS - Main Application JavaScript
// ============================================
// 
// ⚠️ SECURITY NOTE (2025-12-26):
// This frontend currently uses STATIC/HARDCODED data only.
// The innerHTML usage is SAFE because data is from local code, 
// NOT from user input or external APIs.
//
// 🚨 WHEN CONNECTING TO BACKEND API:
// 1. Install DOMPurify: npm install dompurify
// 2. Sanitize ALL API responses before innerHTML:
//    import DOMPurify from 'dompurify';
//    container.innerHTML = DOMPurify.sanitize(apiResponse);
// 3. Prefer textContent over innerHTML where possible
// ============================================

// State Management
const app = {
    currentPage: 'dashboard',
    user: {
        name: 'Admin',
        role: 'Administrator',
        avatar: 'A'
    }
};

// Navigation
function initNavigation() {
    const navItems = document.querySelectorAll('.nav-item');

    navItems.forEach(item => {
        item.addEventListener('click', (e) => {
            e.preventDefault();
            const page = item.getAttribute('data-page');
            navigateToPage(page);
        });
    });
}

function navigateToPage(pageName) {
    // Update active nav item
    document.querySelectorAll('.nav-item').forEach(item => {
        item.classList.remove('active');
    });
    document.querySelector(`[data-page="${pageName}"]`).classList.add('active');

    // Update page content
    document.querySelectorAll('.page').forEach(page => {
        page.classList.remove('active');
    });

    const targetPage = document.getElementById(`${pageName}-page`);
    if (targetPage) {
        targetPage.classList.add('active');
        app.currentPage = pageName;

        // Load page content if empty
        if (!targetPage.innerHTML.trim()) {
            loadPageContent(pageName, targetPage);
        }
    }
}

// Dynamic Page Loading
function loadPageContent(pageName, container) {
    const pages = {
        contacts: generateContactsPage,
        companies: generateCompaniesPage,
        deals: generateDealsPage,
        projects: generateProjectsPage,
        tasks: generateTasksPage,
        hr: generateHRPage,
        finance: generateFinancePage,
        docs: generateDocsPage,
        email: generateEmailPage
    };

    if (pages[pageName]) {
        container.innerHTML = pages[pageName]();
        lucide.createIcons();
    }
}

// Page Generators
function generateContactsPage() {
    return `
        <div class="page-header">
            <div>
                <h1>Contacts</h1>
                <p class="page-subtitle">Manage your contacts and relationships</p>
            </div>
            <button class="btn btn-primary" onclick="showToast('New contact modal coming soon!')">
                <i data-lucide="plus"></i>
                <span>Add Contact</span>
            </button>
        </div>
        
        <div class="card">
            <div class="card-header">
                <h3>All Contacts</h3>
                <div style="display: flex; gap: 12px;">
                    <input type="search" placeholder="Search contacts..." style="padding: 8px 12px; background: var(--primary-bg); border: 1px solid var(--border-color); border-radius: 6px; color: var(--text-primary);">
                    <select class="select-minimal">
                        <option>All Contacts</option>
                        <option>Recent</option>
                        <option>VIP</option>
                    </select>
                </div>
            </div>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Company</th>
                        <th>Phone</th>
                        <th>Last Contact</th>
                        <th>Tags</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>
                            <div class="assignee">
                                <div class="avatar-sm">SJ</div>
                                Sarah Johnson
                            </div>
                        </td>
                        <td>sarah.j@acmecorp.com</td>
                        <td>Acme Corp</td>
                        <td>+1 (555) 123-4567</td>
                        <td>2 days ago</td>
                        <td><span class="badge badge-high">VIP</span></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="assignee">
                                <div class="avatar-sm">JD</div>
                                John Davis
                            </div>
                        </td>
                        <td>john.d@techstart.io</td>
                        <td>TechStart</td>
                        <td>+1 (555) 987-6543</td>
                        <td>1 week ago</td>
                        <td><span class="badge badge-medium">Lead</span></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="assignee">
                                <div class="avatar-sm">MB</div>
                                Maria Brown
                            </div>
                        </td>
                        <td>maria@enterprise.com</td>
                        <td>Enterprise Inc</td>
                        <td>+1 (555) 456-7890</td>
                        <td>3 days ago</td>
                        <td><span class="badge badge-low">Active</span></td>
                    </tr>
                </tbody>
            </table>
        </div>
    `;
}

function generateProjectsPage() {
    return `
        <div class="page-header">
            <div>
                <h1>Projects</h1>
                <p class="page-subtitle">Track and manage all your projects</p>
            </div>
            <button class="btn btn-primary" onclick="showToast('Project creation coming soon!')">
                <i data-lucide="plus"></i>
                <span>New Project</span>
            </button>
        </div>
        
        <div class="stats-grid" style="margin-bottom: 32px;">
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(34, 197, 94, 0.1);">
                    <i data-lucide="folder" style="color: #22c55e;"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">Active Projects</div>
                    <div class="stat-value">12</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(59, 130, 246, 0.1);">
                    <i data-lucide="clock" style="color: #3b82f6;"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">In Progress</div>
                    <div class="stat-value">8</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(168, 85, 247, 0.1);">
                    <i data-lucide="check-circle" style="color: #a855f7;"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">Completed (MTD)</div>
                    <div class="stat-value">15</div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3>All Projects</h3>
                <select class="select-minimal">
                    <option>All Projects</option>
                    <option>In Progress</option>
                    <option>Completed</option>
                </select>
            </div>
            <div style="padding: 24px; display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px;">
                ${generateProjectCard('Website Redesign', 'In Progress', '75%', '#3b82f6')}
                ${generateProjectCard('Mobile App', 'In Progress', '45%', '#a855f7')}
                ${generateProjectCard('API Integration', 'Review', '90%', '#f59e0b')}
                ${generateProjectCard('Marketing Campaign', 'Planning', '20%', '#22c55e')}
            </div>
        </div>
    `;
}

function generateProjectCard(name, status, progress, color) {
    return `
        <div style="background: var(--tertiary-bg); border: 1px solid var(--border-color); border-radius: 12px; padding: 20px; cursor: pointer; transition: all 0.2s;" onmouseover="this.style.borderColor='var(--accent)'" onmouseout="this.style.borderColor='var(--border-color)'">
            <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 12px;">
                <h4 style="color: var(--text-primary); font-size: 16px; font-weight: 600;">${name}</h4>
                <span class="status-badge status-progress">${status}</span>
            </div>
            <div style="margin-bottom: 16px;">
                <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                    <span style="font-size: 12px; color: var(--text-muted);">Progress</span>
                    <span style="font-size: 12px; color: var(--text-primary); font-weight: 500;">${progress}</span>
                </div>
                <div style="height: 6px; background: var(--primary-bg); border-radius: 3px; overflow: hidden;">
                    <div style="height: 100%; width: ${progress}; background: ${color}; border-radius: 3px;"></div>
                </div>
            </div>
            <div style="display: flex; gap: 8px;">
                <div class="avatar-sm">JD</div>
                <div class="avatar-sm">SJ</div>
                <div class="avatar-sm">MB</div>
            </div>
        </div>
    `;
}

function generateCompaniesPage() {
    return `<div class="page-header"><h1>Companies</h1><p class="page-subtitle">Manage your company relationships</p></div><div class="card" style="padding: 40px; text-align: center;"><i data-lucide="building-2" style="width: 64px; height: 64px; color: var(--text-muted); margin-bottom: 16px;"></i><h3 style="color: var(--text-primary); margin-bottom: 8px;">Companies Module</h3><p style="color: var(--text-muted);">Coming soon in Phase 4</p></div>`;
}

function generateDealsPage() {
    return `<div class="page-header"><h1>Deals</h1><p class="page-subtitle">Track your sales pipeline</p></div><div class="card" style="padding: 40px; text-align: center;"><i data-lucide="handshake" style="width: 64px; height: 64px; color: var(--text-muted); margin-bottom: 16px;"></i><h3 style="color: var(--text-primary); margin-bottom: 8px;">Deals Pipeline</h3><p style="color: var(--text-muted);">Coming soon in Phase 4</p></div>`;
}

function generateTasksPage() {
    return `<div class="page-header"><h1>Tasks</h1><p class="page-subtitle">Manage your tasks and assignments</p></div><div class="card" style="padding: 40px; text-align: center;"><i data-lucide="check-square" style="width: 64px; height: 64px; color: var(--text-muted); margin-bottom: 16px;"></i><h3 style="color: var(--text-primary); margin-bottom: 8px;">Task Management</h3><p style="color: var(--text-muted);">Coming soon in Phase 4</p></div>`;
}

function generateHRPage() {
    return `<div class="page-header"><h1>HR Management</h1><p class="page-subtitle">Employee management and onboarding</p></div><div class="card" style="padding: 40px; text-align: center;"><i data-lucide="user-cog" style="width: 64px; height: 64px; color: var(--text-muted); margin-bottom: 16px;"></i><h3 style="color: var(--text-primary); margin-bottom: 8px;">HR OS</h3><p style="color: var(--text-muted);">Coming soon in Phase 4</p></div>`;
}

function generateFinancePage() {
    return `<div class="page-header"><h1>Finance</h1><p class="page-subtitle">Invoices and revenue tracking</p></div><div class="card" style="padding: 40px; text-align: center;"><i data-lucide="dollar-sign" style="width: 64px; height: 64px; color: var(--text-muted); margin-bottom: 16px;"></i><h3 style="color: var(--text-primary); margin-bottom: 8px;">Finance Module</h3><p style="color: var(--text-muted);">Coming soon in Phase 4</p></div>`;
}

function generateDocsPage() {
    return `<div class="page-header"><h1>Documents & SOPs</h1><p class="page-subtitle">Knowledge base and documentation</p></div><div class="card" style="padding: 40px; text-align: center;"><i data-lucide="file-text" style="width: 64px; height: 64px; color: var(--text-muted); margin-bottom: 16px;"></i><h3 style="color: var(--text-primary); margin-bottom: 8px;">Document Repository</h3><p style="color: var(--text-muted);">Coming soon in Phase 4</p></div>`;
}

function generateEmailPage() {
    return `<div class="page-header"><h1>Email & Campaigns</h1><p class="page-subtitle">Marketing and transactional emails</p></div><div class="card" style="padding: 40px; text-align: center;"><i data-lucide="mail" style="width: 64px; height: 64px; color: var(--text-muted); margin-bottom: 16px;"></i><h3 style="color: var(--text-primary); margin-bottom: 8px;">Email Module</h3><p style="color: var(--text-muted);">Powered by Notifuse (Phase 5)</p></div>`;
}

// Toast Notifications
function showToast(message, type = 'info') {
    const container = document.getElementById('toast-container');
    const toast = document.createElement('div');
    toast.className = 'toast';
    toast.innerHTML = `
        <div style="display: flex; gap: 12px; align-items: start;">
            <i data-lucide="${type === 'success' ? 'check-circle' : 'info'}" style="width: 20px; height: 20px; color: var(--accent);"></i>
            <div style="flex: 1;">
                <div style="font-weight: 500; color: var(--text-primary); margin-bottom: 2px;">${message}</div>
            </div>
        </div>
    `;

    container.appendChild(toast);
    lucide.createIcons();

    setTimeout(() => {
        toast.style.animation = 'slideOutRight 0.3s ease-out';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

// Chart Initialization
function initChart() {
    const ctx = document.getElementById('revenueChart');
    if (!ctx) return;

    new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
            datasets: [{
                label: 'Revenue',
                data: [32000, 38000, 35000, 42000, 45000, 48352],
                borderColor: '#0bd7d4',
                backgroundColor: 'rgba(11, 215, 212, 0.1)',
                tension: 0.4,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        color: '#718096',
                        callback: function (value) {
                            return '$' + value.toLocaleString();
                        }
                    },
                    grid: {
                        color: '#2d3748'
                    }
                },
                x: {
                    ticks: {
                        color: '#718096'
                    },
                    grid: {
                        color: '#2d3748'
                    }
                }
            }
        }
    });
}

// Mobile Menu Toggle
function initMobileMenu() {
    const toggle = document.querySelector('.mobile-menu-toggle');
    const sidebar = document.querySelector('.sidebar');

    if (toggle && sidebar) {
        toggle.addEventListener('click', () => {
            sidebar.classList.toggle('open');
        });
    }
}

// Initialize App
document.addEventListener('DOMContentLoaded', () => {
    initNavigation();
    initMobileMenu();
    initChart();
    console.log('✨ Clepto OS initialized!');
});

// Keyboard Shortcuts
document.addEventListener('keydown', (e) => {
    // Ctrl+K for search
    if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
        e.preventDefault();
        document.querySelector('.search-bar input').focus();
    }
});
