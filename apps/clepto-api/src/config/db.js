const { Pool } = require('pg');

const pool = new Pool({
    user: process.env.PG_USER || 'clepto',
    host: process.env.PG_HOST || 'localhost',
    database: process.env.PG_DATABASE || 'clepto_os',
    password: process.env.PG_PASSWORD,
    port: process.env.PG_PORT || 5432,
});

pool.on('error', (err) => {
    console.error('Unexpected error on idle client', err);
    process.exit(-1);
});

module.exports = {
    query: (text, params) => pool.query(text, params),
    pool,
};
