-- ============================================================
-- FORA DO RADAR — Database Schema Setup
-- ============================================================

-- ──────────────────────────────────────────────────────────
-- 1. TABELA: PAISES
-- ──────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.paises (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(150) NOT NULL UNIQUE,
  codigo VARCHAR(5) NOT NULL UNIQUE,
  bandeira_url TEXT,
  created_at TIMESTAMP DEFAULT now()
);

ALTER TABLE paises ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Leitura pública" ON paises FOR SELECT USING (true);

-- ──────────────────────────────────────────────────────────
-- 2. TABELA: LIGAS
-- ──────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.ligas (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(255) NOT NULL UNIQUE,
  divisao VARCHAR(100),
  logo_url TEXT,
  pais_id INTEGER NOT NULL REFERENCES paises(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT now()
);

ALTER TABLE ligas ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Leitura pública" ON ligas FOR SELECT USING (true);

-- ──────────────────────────────────────────────────────────
-- 3. TABELA: CLUBES
-- ──────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.clubes (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(255) NOT NULL UNIQUE,
  cidade VARCHAR(150),
  ano_fundacao INTEGER,
  descricao TEXT,
  escudo_url TEXT,
  cores VARCHAR(255),
  treinador VARCHAR(150),
  estadio_nome VARCHAR(255),
  estadio_imagem TEXT,
  liga_id INTEGER NOT NULL REFERENCES ligas(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT now()
);

ALTER TABLE clubes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Leitura pública" ON clubes FOR SELECT USING (true);

-- ──────────────────────────────────────────────────────────
-- 4. TABELA: UTILIZADORES (Perfis Públicos)
-- Ligada ao auth.users do Supabase
-- ──────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.utilizadores (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(150) NOT NULL,
  avatar_url TEXT DEFAULT NULL,
  created_at TIMESTAMP DEFAULT now()
);

ALTER TABLE utilizadores ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Perfil público visível" ON utilizadores
  FOR SELECT USING (true);

CREATE POLICY "Utilizador edita o seu perfil" ON utilizadores
  FOR ALL USING (auth.uid() = id);

-- ──────────────────────────────────────────────────────────
-- 5. TRIGGER: Criar perfil automaticamente no registo
-- ──────────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.utilizadores (id, email, username)
  VALUES (
    new.id,
    new.email,
    COALESCE(new.raw_user_meta_data->>'username', split_part(new.email, '@', 1))
  );
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- ──────────────────────────────────────────────────────────
-- 6. TABELA: CAMISOLAS
-- ──────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.camisolas (
  id SERIAL PRIMARY KEY,
  clube_id INTEGER NOT NULL REFERENCES clubes(id) ON DELETE CASCADE,
  nome VARCHAR(255),
  tipo VARCHAR(50),
  epoca VARCHAR(20),
  imagem_url TEXT,
  created_at TIMESTAMP DEFAULT now()
);

ALTER TABLE camisolas ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Leitura pública" ON camisolas FOR SELECT USING (true);

-- ──────────────────────────────────────────────────────────
-- 7. TABELA: GALERIA (Fotos/videos de clubes)
-- ──────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.galeria (
  id SERIAL PRIMARY KEY,
  clube_id INTEGER NOT NULL REFERENCES clubes(id) ON DELETE CASCADE,
  titulo VARCHAR(255),
  descricao TEXT,
  imagem_url TEXT,
  tipo VARCHAR(20),
  created_at TIMESTAMP DEFAULT now()
);

ALTER TABLE galeria ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Leitura pública" ON galeria FOR SELECT USING (true);

-- ──────────────────────────────────────────────────────────
-- 8. TABELA: HISTORIAS (Notícias/artigos sobre clubes)
-- ──────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.historias (
  id SERIAL PRIMARY KEY,
  clube_id INTEGER NOT NULL REFERENCES clubes(id) ON DELETE CASCADE,
  titulo VARCHAR(255) NOT NULL,
  conteudo TEXT,
  autor VARCHAR(150),
  criada_em TIMESTAMP DEFAULT now(),
  atualizada_em TIMESTAMP DEFAULT now()
);

ALTER TABLE historias ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Leitura pública" ON historias FOR SELECT USING (true);

-- ──────────────────────────────────────────────────────────
-- 9. TABELA: FAVORITOS (Clubes favoritos por utilizador)
-- ──────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.favoritos (
  id SERIAL PRIMARY KEY,
  utilizador_id UUID NOT NULL REFERENCES utilizadores(id) ON DELETE CASCADE,
  clube_id INTEGER NOT NULL REFERENCES clubes(id) ON DELETE CASCADE,
  adicionado_em TIMESTAMP DEFAULT now(),
  UNIQUE(utilizador_id, clube_id)
);

ALTER TABLE favoritos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Ver favoritos próprios" ON favoritos
  FOR SELECT USING (auth.uid() = utilizador_id);

CREATE POLICY "Adicionar favorito" ON favoritos
  FOR INSERT WITH CHECK (auth.uid() = utilizador_id);

CREATE POLICY "Remover favorito" ON favoritos
  FOR DELETE USING (auth.uid() = utilizador_id);