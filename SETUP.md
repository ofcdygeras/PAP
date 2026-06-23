# 🚀 Guia de Configuração — Supabase + Fora do Radar

## 1. Criar conta e projeto

1. Vai a **https://supabase.com** e cria uma conta gratuita
2. Clica em **"New project"**
3. Escolhe um nome: `fora-do-radar`
4. Define uma password segura para a base de dados
5. Escolhe a região **West EU (Ireland)** — mais próximo de Portugal
6. Aguarda ~2 minutos enquanto o projeto é criado

---

## 2. Criar as tabelas

No painel do Supabase, vai a **SQL Editor** e corre o ficheiro `fora_do_radar.sql` que já tens:

1. Clica em **"New query"**
2. Cola o conteúdo do ficheiro `fora_do_radar.sql`
3. Clica em **"Run"** (▶️)

> ⚠️ A tabela `utilizadores` vai conflitar com o Supabase Auth.
> Lê a secção 3 abaixo antes de correr o SQL.

---

## 3. Adaptar a tabela `utilizadores` ao Supabase Auth

O Supabase tem o seu próprio sistema de autenticação (`auth.users`).
A tabela `utilizadores` que já tens serve como **perfil público**.

Substitui a criação da tabela `utilizadores` no SQL por este código:

```sql
-- Perfis públicos (ligados ao auth.users do Supabase)
CREATE TABLE public.utilizadores (
  id        uuid REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  username  varchar(50) NOT NULL UNIQUE,
  email     varchar(150) NOT NULL,
  avatar_url text DEFAULT NULL,
  created_at timestamp DEFAULT now()
);

-- Permite que utilizadores leiam/editem apenas o seu próprio perfil
ALTER TABLE utilizadores ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Perfil público visível" ON utilizadores
  FOR SELECT USING (true);

CREATE POLICY "Utilizador edita o seu perfil" ON utilizadores
  FOR ALL USING (auth.uid() = id);

-- Cria automaticamente o perfil quando alguém se regista
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

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
```

---

## 4. Row Level Security (RLS) nas outras tabelas

Corre isto no SQL Editor para as tabelas serem lidas publicamente
mas os favoritos só pelo dono:

```sql
-- Leitura pública das tabelas de conteúdo
ALTER TABLE paises   ENABLE ROW LEVEL SECURITY;
ALTER TABLE ligas    ENABLE ROW LEVEL SECURITY;
ALTER TABLE clubes   ENABLE ROW LEVEL SECURITY;
ALTER TABLE galeria  ENABLE ROW LEVEL SECURITY;
ALTER TABLE camisolas ENABLE ROW LEVEL SECURITY;
ALTER TABLE historias ENABLE ROW LEVEL SECURITY;
ALTER TABLE favoritos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Leitura pública" ON paises    FOR SELECT USING (true);
CREATE POLICY "Leitura pública" ON ligas     FOR SELECT USING (true);
CREATE POLICY "Leitura pública" ON clubes    FOR SELECT USING (true);
CREATE POLICY "Leitura pública" ON galeria   FOR SELECT USING (true);
CREATE POLICY "Leitura pública" ON camisolas FOR SELECT USING (true);
CREATE POLICY "Leitura pública" ON historias FOR SELECT USING (true);

-- Favoritos: só o dono pode ver e editar
CREATE POLICY "Ver favoritos"    ON favoritos FOR SELECT USING (auth.uid() = utilizador_id);
CREATE POLICY "Adicionar fav"    ON favoritos FOR INSERT WITH CHECK (auth.uid() = utilizador_id);
CREATE POLICY "Remover fav"      ON favoritos FOR DELETE USING (auth.uid() = utilizador_id);
```

---

## 5. Obter as credenciais

1. No painel do Supabase, vai a **Project Settings → API**
2. Copia:
   - **Project URL** → ex: `https://abcdefgh.supabase.co`
   - **anon public key** → chave longa começada por `eyJ...`

---

## 6. Colocar as credenciais no projeto

Abre o ficheiro `supabase.js` e substitui as linhas:

```javascript
const SUPABASE_URL      = 'https://SEU_PROJETO.supabase.co'   // ← substitui
const SUPABASE_ANON_KEY = 'SUA_ANON_KEY_AQUI'                 // ← substitui
```

Pelos teus valores reais, ex:

```javascript
const SUPABASE_URL      = 'https://abcdefgh.supabase.co'
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6...'
```

---

## 7. Testar localmente

Como o projeto usa ES Modules (`type="module"`), **não podes abrir os ficheiros
diretamente no browser** (problema de CORS). Usa um servidor local:

### Opção A — VS Code (recomendado)
Instala a extensão **"Live Server"** e clica em **"Go Live"**

### Opção B — Python (se tens Python instalado)
```bash
cd pasta-do-projeto
python -m http.server 3000
# abre http://localhost:3000
```

### Opção C — Node.js
```bash
npx serve .
```

---

## 8. Estrutura final do projeto

```
ForaDoRadar/
├── index.html      ← Página principal (homepage)
├── ligas.html      ← Lista de ligas com filtros e pesquisa
├── auth.html       ← Login + Registo
├── supabase.js     ← Config + todas as funções de BD ⚠️ edita aqui
├── style.css       ← Estilos globais
└── script.js       ← Scripts da homepage
```

---

## 9. Funcionalidades implementadas

| Funcionalidade | Ficheiro |
|---|---|
| Login com email/password | `auth.html` + `supabase.js` → `login()` |
| Registo de conta | `auth.html` + `supabase.js` → `registar()` |
| Estado autenticado no header | `supabase.js` → `initAuthHeader()` |
| Listar ligas | `ligas.html` + `supabase.js` → `getLigas()` |
| Filtrar ligas por país | `ligas.html` (client-side) |
| Pesquisar ligas | `ligas.html` (client-side) |
| Listar clubes | `supabase.js` → `getClubes()` |
| Favoritos | `supabase.js` → `getFavoritos()`, `adicionarFavorito()`, `removerFavorito()` |
| Detalhes de clube | `supabase.js` → `getClube(id)` |

---

## ❓ Problemas comuns

**"Failed to fetch" ou erro de rede**
→ As credenciais estão erradas ou não foram substituídas no `supabase.js`

**"permission denied for table"**
→ Não correste os RLS policies da secção 4

**Os ficheiros não abrem no browser**
→ Precisas de um servidor local (secção 7)

**"User already registered"**
→ O email já existe no Supabase Auth — usa outro email ou faz login
