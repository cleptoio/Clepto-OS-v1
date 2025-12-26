const API_URL = '/api'; // Relative path for production (via Traefik)

// Login Function
async function login(email, password) {
    try {
        const response = await fetch(`${API_URL}/auth/login`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ email, password })
        });

        const data = await response.json();

        if (response.ok) {
            // Save token
            localStorage.setItem('token', data.token);
            localStorage.setItem('user', JSON.stringify(data.user));

            // Redirect
            window.location.href = '/';
        } else {
            throw new Error(data.message || 'Login failed');
        }
    } catch (err) {
        document.getElementById('loginError').textContent = err.message;
        document.getElementById('loginError').style.display = 'block';
    }
}

// Logout Function
function logout() {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    window.location.href = '/login.html';
}

// Check Auth on Page Load
function checkAuth() {
    const token = localStorage.getItem('token');

    // If no token and not on login page, redirect to login
    if (!token && !window.location.pathname.includes('login.html')) {
        window.location.href = '/login.html';
    }

    // If token exists and on login page, redirect to dashboard
    if (token && window.location.pathname.includes('login.html')) {
        window.location.href = '/';
    }
}

// Event Listeners
document.addEventListener('DOMContentLoaded', () => {
    checkAuth();

    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            login(email, password);
        });
    }

    // Attach logout to any logout buttons
    const logoutBtn = document.getElementById('logoutBtn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', (e) => {
            e.preventDefault();
            logout();
        });
    }
});
