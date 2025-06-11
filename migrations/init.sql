-- KI Website Workshop Database Schema

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Workshops table
CREATE TABLE workshops (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    password_hash VARCHAR(255),
    max_cost_per_user DECIMAL(10,2) DEFAULT 1.00,
    is_active BOOLEAN DEFAULT false,
    admin_user_id INTEGER,
    settings JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT NOW()
);

-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    workshop_id INTEGER REFERENCES workshops(id),
    username VARCHAR(100) NOT NULL,
    display_name VARCHAR(100),
    password_hash VARCHAR(255) NOT NULL,
    session_token VARCHAR(255) UNIQUE DEFAULT gen_random_uuid()::text,
    role VARCHAR(20) DEFAULT 'PARTICIPANT' CHECK (role IN ('ADMIN', 'PARTICIPANT')),
    joined_at TIMESTAMP DEFAULT NOW(),
    last_seen TIMESTAMP DEFAULT NOW(),
    UNIQUE(workshop_id, username)
);

-- Add foreign key for admin_user_id after users table is created
ALTER TABLE workshops ADD CONSTRAINT fk_admin_user 
    FOREIGN KEY (admin_user_id) REFERENCES users(id);

-- Create partial unique index for active workshops (only one can be active)
CREATE UNIQUE INDEX idx_workshops_only_one_active 
    ON workshops (is_active) WHERE is_active = true;

-- Websites/Projects table
CREATE TABLE websites (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) DEFAULT 'Meine Website',
    html TEXT DEFAULT '<h1>Willkommen auf meiner Website!</h1>',
    css TEXT DEFAULT 'body { font-family: Arial, sans-serif; margin: 20px; }',
    js TEXT DEFAULT '',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- LLM API Calls table
CREATE TABLE llm_calls (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    website_id INTEGER REFERENCES websites(id) ON DELETE CASCADE,
    prompt TEXT NOT NULL,
    response_type VARCHAR(20) CHECK (response_type IN ('CHAT', 'UPDATE', 'REWRITE')),
    response_data JSONB NOT NULL,
    model VARCHAR(50) DEFAULT 'gpt-4.1-mini',
    prompt_tokens INTEGER NOT NULL,
    completion_tokens INTEGER NOT NULL,
    total_tokens INTEGER NOT NULL,
    cost DECIMAL(10,6) NOT NULL,
    error_message TEXT,
    is_error_fix BOOLEAN DEFAULT false,
    parent_call_id INTEGER REFERENCES llm_calls(id),
    duration_ms INTEGER,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Chat Messages table
CREATE TABLE chat_messages (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    website_id INTEGER REFERENCES websites(id) ON DELETE CASCADE,
    role VARCHAR(20) NOT NULL CHECK (role IN ('user', 'assistant', 'system')),
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Code History table (for rollback)
CREATE TABLE code_history (
    id SERIAL PRIMARY KEY,
    website_id INTEGER REFERENCES websites(id) ON DELETE CASCADE,
    html TEXT NOT NULL,
    css TEXT NOT NULL,
    js TEXT NOT NULL,
    change_type VARCHAR(20) CHECK (change_type IN ('MANUAL', 'AI_UPDATE', 'AI_REWRITE', 'ROLLBACK')),
    llm_call_id INTEGER REFERENCES llm_calls(id),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Templates table
CREATE TABLE templates (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    html TEXT NOT NULL,
    css TEXT NOT NULL,
    js TEXT,
    category VARCHAR(50),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Website Likes table
CREATE TABLE website_likes (
    id SERIAL PRIMARY KEY,
    website_id INTEGER REFERENCES websites(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(website_id, user_id)
);

-- Create indices
CREATE INDEX idx_users_workshop ON users(workshop_id);
CREATE INDEX idx_users_session ON users(session_token);
CREATE INDEX idx_websites_user ON websites(user_id);
CREATE INDEX idx_llm_calls_user ON llm_calls(user_id);
CREATE INDEX idx_llm_calls_created ON llm_calls(created_at);
CREATE INDEX idx_chat_messages_user_website ON chat_messages(user_id, website_id);
CREATE INDEX idx_code_history_website ON code_history(website_id, created_at DESC);
CREATE INDEX idx_website_likes_website ON website_likes(website_id);
CREATE INDEX idx_website_likes_user ON website_likes(user_id);

-- Create views

-- User costs view
CREATE VIEW user_costs AS
SELECT 
    u.id as user_id,
    u.username,
    u.display_name,
    u.workshop_id,
    COUNT(l.id) as total_calls,
    COALESCE(SUM(l.total_tokens), 0) as total_tokens,
    COALESCE(SUM(l.cost), 0) as total_cost,
    MAX(l.created_at) as last_api_call
FROM users u
LEFT JOIN llm_calls l ON u.id = l.user_id
GROUP BY u.id;

-- Workshop statistics view
CREATE VIEW workshop_stats AS
SELECT 
    w.id as workshop_id,
    w.name,
    COUNT(DISTINCT u.id) as user_count,
    COUNT(DISTINCT ws.id) as website_count,
    COUNT(l.id) as total_api_calls,
    COALESCE(SUM(l.cost), 0) as total_cost,
    COALESCE(AVG(uc.total_cost), 0) as avg_cost_per_user
FROM workshops w
LEFT JOIN users u ON w.id = u.workshop_id
LEFT JOIN websites ws ON u.id = ws.user_id
LEFT JOIN llm_calls l ON u.id = l.user_id
LEFT JOIN user_costs uc ON u.id = uc.user_id
GROUP BY w.id;

-- Active sessions view (for gallery)
CREATE VIEW active_sessions AS
SELECT 
    u.id as user_id,
    u.username,
    u.display_name,
    w.id as website_id,
    w.name as website_name,
    w.html,
    w.css,
    w.js,
    w.updated_at
FROM users u
JOIN websites w ON u.id = w.user_id
WHERE w.is_active = true
AND u.last_seen > NOW() - INTERVAL '5 minutes'
ORDER BY w.updated_at DESC;

-- Insert default templates
INSERT INTO templates (name, description, html, css, category) VALUES
('Persönliche Vorstellung', 'Eine einfache Seite, um dich vorzustellen', 
'<!DOCTYPE html>
<html>
<head>
    <title>Über mich</title>
</head>
<body>
    <div class="container">
        <h1>Hallo, ich bin [Dein Name]</h1>
        <p>Willkommen auf meiner persönlichen Website!</p>
        <h2>Über mich</h2>
        <p>Hier kannst du etwas über dich erzählen...</p>
        <h2>Meine Hobbys</h2>
        <ul>
            <li>Hobby 1</li>
            <li>Hobby 2</li>
            <li>Hobby 3</li>
        </ul>
    </div>
</body>
</html>',
'body {
    font-family: Arial, sans-serif;
    line-height: 1.6;
    margin: 0;
    padding: 0;
    background-color: #f4f4f4;
}

.container {
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
    background-color: white;
    box-shadow: 0 0 10px rgba(0,0,0,0.1);
}

h1 {
    color: #333;
}

h2 {
    color: #666;
}',
'personal'),

('Fotosammlung', 'Eine Galerie für deine Lieblingsbilder',
'<!DOCTYPE html>
<html>
<head>
    <title>Meine Fotogalerie</title>
</head>
<body>
    <h1>Meine Lieblingsfotos</h1>
    <div class="gallery">
        <div class="photo">
            <img src="https://picsum.photos/300/200?random=1" alt="Foto 1">
            <p>Beschreibung des Fotos</p>
        </div>
        <div class="photo">
            <img src="https://picsum.photos/300/200?random=2" alt="Foto 2">
            <p>Beschreibung des Fotos</p>
        </div>
        <div class="photo">
            <img src="https://picsum.photos/300/200?random=3" alt="Foto 3">
            <p>Beschreibung des Fotos</p>
        </div>
    </div>
</body>
</html>',
'.gallery {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 20px;
    padding: 20px;
}

.photo {
    border: 1px solid #ddd;
    padding: 10px;
    text-align: center;
}

.photo img {
    width: 100%;
    height: auto;
}

h1 {
    text-align: center;
    color: #333;
}',
'gallery'),

('Lieblingsspiel', 'Präsentiere dein Lieblingsvideospiel oder -sport',
'<!DOCTYPE html>
<html>
<head>
    <title>Mein Lieblingsspiel</title>
</head>
<body>
    <header>
        <h1>🎮 Mein Lieblingsspiel</h1>
    </header>
    <main>
        <section class="hero">
            <h2>Spielname hier</h2>
            <p>Warum ich dieses Spiel liebe...</p>
        </section>
        <section class="features">
            <h3>Was macht es besonders?</h3>
            <div class="feature-grid">
                <div class="feature">
                    <h4>Feature 1</h4>
                    <p>Beschreibung</p>
                </div>
                <div class="feature">
                    <h4>Feature 2</h4>
                    <p>Beschreibung</p>
                </div>
                <div class="feature">
                    <h4>Feature 3</h4>
                    <p>Beschreibung</p>
                </div>
            </div>
        </section>
    </main>
</body>
</html>',
'body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: linear-gradient(to bottom, #1a1a2e, #0f0f1e);
    color: white;
}

header {
    text-align: center;
    padding: 2rem;
    background: rgba(255,255,255,0.1);
}

.hero {
    text-align: center;
    padding: 3rem;
}

.features {
    padding: 2rem;
}

.feature-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 2rem;
    margin-top: 2rem;
}

.feature {
    background: rgba(255,255,255,0.1);
    padding: 1.5rem;
    border-radius: 10px;
}',
'gaming');