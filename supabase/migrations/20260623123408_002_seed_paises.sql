-- ============================================================
-- FORA DO RADAR — Seed Data: Países da Copa do Mundo
-- ============================================================

-- ──────────────────────────────────────────────────────────
-- PAÍSES
-- ──────────────────────────────────────────────────────────

INSERT INTO paises (nome, codigo, bandeira_url) VALUES

-- Portugal
('Portugal', 'PT', 'https://flagcdn.com/w320/pt.png'),

-- Brasil
('Brasil', 'BR', 'https://flagcdn.com/w320/br.png'),

-- Argentina
('Argentina', 'AR', 'https://flagcdn.com/w320/ar.png'),

-- México
('México', 'MX', 'https://flagcdn.com/w320/mx.png'),

-- Espanha
('Espanha', 'ES', 'https://flagcdn.com/w320/es.png'),

-- França
('França', 'FR', 'https://flagcdn.com/w320/fr.png'),

-- Alemanha
('Alemanha', 'DE', 'https://flagcdn.com/w320/de.png'),

-- Inglaterra
('Inglaterra', 'GB', 'https://flagcdn.com/w320/gb.png'),

-- Estados Unidos
('Estados Unidos', 'US', 'https://flagcdn.com/w320/us.png'),

-- Japão
('Japão', 'JP', 'https://flagcdn.com/w320/jp.png'),

-- Coreia do Sul
('Coreia do Sul', 'KR', 'https://flagcdn.com/w320/kr.png'),

-- Indonésia
('Indonésia', 'ID', 'https://flagcdn.com/w320/id.png'),

-- Finlândia
('Finlândia', 'FI', 'https://flagcdn.com/w320/fi.png')

ON CONFLICT (codigo) DO NOTHING;