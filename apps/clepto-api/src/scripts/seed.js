require('dotenv').config();
const { Pool } = require('pg');
const bcrypt = require('bcryptjs');

const pool = new Pool({
    user: process.env.PG_USER || 'clepto',
    host: process.env.PG_HOST || 'localhost',
    database: process.env.PG_DATABASE || 'clepto_os',
    password: process.env.PG_PASSWORD,
    port: process.env.PG_PORT || 5432,
});

async function seed() {
    try {
        console.log('🌱 Seeding Database...');

        // Connect
        const client = await pool.connect();

        // 1. Create Tables (Manual run of init.sql content for simplicity in seed)
        console.log('   Creating tables...');
        await client.query(`
            CREATE TABLE IF NOT EXISTS users (
                id SERIAL PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                email VARCHAR(255) UNIQUE NOT NULL,
                password_hash VARCHAR(255) NOT NULL,
                role VARCHAR(50) DEFAULT 'user',
                created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
            );
        `);

        // 2. Check if admin exists
        const check = await client.query("SELECT * FROM users WHERE email = 'admin@clepto.io'");
        if (check.rows.length > 0) {
            console.log('   ⚠️ Admin user already exists. Skipping.');
        } else {
            // 3. Create Admin User
            const salt = await bcrypt.genSalt(10);
            const hash = await bcrypt.hash('admin123', salt);

            await client.query(
                "INSERT INTO users (name, email, password_hash, role) VALUES ($1, $2, $3, $4)",
                ['Admin User', 'admin@clepto.io', hash, 'admin']
            );
            console.log('   ✅ Admin user created: admin@clepto.io / admin123');
        }

        client.release();
        console.log('✨ Seeding complete!');
        process.exit(0);

    } catch (err) {
        console.error('❌ Seeding failed:', err);
        process.exit(1);
    }
}

seed();
