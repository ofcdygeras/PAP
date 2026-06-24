// ============================================================
//  supabase.js — Fora do Radar
//  Config central + funções de autenticação e base de dados
//
//  IMPORTANTE: substitui os valores em SUPABASE_URL e
//  SUPABASE_ANON_KEY pelos do teu projeto em supabase.com
//  Dashboard → Project Settings → API
// ============================================================

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// ── 1. CONFIGURAÇÃO ──────────────────────────────────────────
const SUPABASE_URL      = 'https://wvuvgfyprxceyjyvalfq.supabase.co'   // ← substitui
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind2dXZnZnlwcnhjZXlqeXZhbGZxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkxMzk4MzgsImV4cCI6MjA5NDcxNTgzOH0.pUwsf5HnRwNlier22mpHrJ_0GPZwGuYYomorQKJAEWI'                 // ← substitui

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
  },
})

// ── 2. AUTENTICAÇÃO ──────────────────────────────────────────

/**
 * Regista um novo utilizador.
 * Cria conta em auth.users e insere perfil em public.utilizadores.
 */
export async function registar({ username, email, password }) {
  // 2a. Criar conta no Supabase Auth.
  // O trigger `on_auth_user_created` no Supabase já cria o perfil em `utilizadores`.
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      data: {
        username,
      },
    },
  })
  if (error) throw error

  return data
}

/**
 * Faz login com email + password.
 */
export async function login({ email, password }) {
  const { data, error } = await supabase.auth.signInWithPassword({ email, password })
  if (error) throw error
  return data
}

/**
 * Termina a sessão do utilizador.
 */
export async function logout() {
  const { error } = await supabase.auth.signOut()
  if (error) throw error
}

/**
 * Retorna o utilizador autenticado (ou null).
 */
export async function getUser() {
  const { data: { user }, error } = await supabase.auth.getUser()
  if (error) {
    console.warn('getUser error:', error)
  }

  if (user) return user

  const {
    data: { session },
    error: sessionError,
  } = await supabase.auth.getSession()

  if (sessionError) {
    console.warn('getSession error:', sessionError)
  }

  return session?.user ?? null
}

/**
 * Retorna o perfil completo (tabela utilizadores) do user autenticado.
 */
export async function getPerfil() {
  const user = await getUser()
  if (!user) return null

  const { data, error } = await supabase
    .from('utilizadores')
    .select('*')
    .eq('id', user.id)
    .single()

  if (error) {
    return {
      username: user.email?.split('@')[0] || 'Conta',
      email: user.email,
      id: user.id,
    }
  }
  return data
}

// ── 3. PAÍSES ────────────────────────────────────────────────

/** Lista todos os países. */
export async function getPaises() {
  // Tenta carregar do Supabase; se falhar ou devolver poucos itens,
  // faz fallback para um ficheiro local `supabase/seed/paises.json`.
  let queryError = null
  try {
    const { data, error } = await supabase
      .from('paises')
      .select('*')
      .order('nome')

    if (!error && Array.isArray(data) && data.length >= 5) {
      return data
    }
    if (error) queryError = error
    // se data for muito pequeno (p.ex. apenas 3), considera fallback
  } catch (err) {
    queryError = err
  }

  try {
    const resp = await fetch('/supabase/seed/paises.json')
    if (!resp.ok) throw new Error('Falha ao carregar seed local')
    const local = await resp.json()
    console.warn('Usando seed local de /supabase/seed/paises.json')
    return local
  } catch (localErr) {
    console.error('Erro ao carregar seed local:', localErr)
    // Se houver um erro de query original, lança esse; caso contrário lança o localErr
    if (queryError) throw queryError
    throw localErr
  }
}

// ── 4. LIGAS ─────────────────────────────────────────────────

/** Lista todas as ligas, com info do país. */
export async function getLigas() {
  // Tenta carregar ligas do Supabase; se falhar ou devolver poucos itens,
  // faz fallback para `supabase/seed/ligas.json`.
  let queryError = null
  try {
    const { data, error } = await supabase
      .from('ligas')
      .select(`*, paises(nome, codigo, bandeira_url)`)
      .order('nome')

    if (!error && Array.isArray(data) && data.length >= 5) {
      return data
    }
    if (error) queryError = error
  } catch (err) {
    queryError = err
  }

  try {
    const resp = await fetch('/supabase/seed/ligas.json')
    if (!resp.ok) throw new Error('Falha ao carregar ligas locais')
    const local = await resp.json()
    // O ficheiro local não inclui a chave `paises` embutida; carregar países e associar
    const paises = await getPaises()
    const paisMap = Object.fromEntries((paises || []).map(p => [p.id, p]))
    return local.map(l => ({ ...l, paises: paisMap[l.pais_id] || null }))
  } catch (localErr) {
    console.error('Erro ao carregar ligas locais:', localErr)
    if (queryError) throw queryError
    throw localErr
  }
}

/** Lista ligas de um país específico. */
export async function getLigasPorPais(paisId) {
  const { data, error } = await supabase
    .from('ligas')
    .select(`*, paises(nome, codigo, bandeira_url)`)
    .eq('pais_id', paisId)
    .order('nome')
  if (error) throw error
  return data
}

/** Detalhes de uma liga (com clubes). */
export async function getLiga(id) {
  const { data, error } = await supabase
    .from('ligas')
    .select(`*, paises(nome, codigo), clubes(*)`)
    .eq('id', id)
    .single()
  if (error) throw error
  return data
}

// ── 5. CLUBES ────────────────────────────────────────────────

/** Lista todos os clubes, com liga e país. */
export async function getClubes() {
  // Tenta carregar clubes do Supabase; se falhar, faz fallback para `supabase/seed/clubes.json`.
  let queryError = null
  try {
    console.log('🔄 Buscando clubes da API...')
    const { data, error } = await supabase
      .from('clubes')
      .select(`*, ligas(nome, paises(nome, codigo))`)
      .order('nome')

    if (!error && Array.isArray(data) && data.length >= 5) {
      console.log('✅ Clubes recebidos:', data.length)
      return data
    }
    if (error) queryError = error
  } catch (err) {
    queryError = err
  }

  try {
    const resp = await fetch('/supabase/seed/clubes.json')
    if (!resp.ok) throw new Error('Falha ao carregar clubes locais')
    const local = await resp.json()
    // Anexar info de liga e país a cada clube para compatibilidade com o frontend
    const ligas = await getLigas()
    const ligaMap = Object.fromEntries((ligas || []).map(l => [l.id, l]))
    const clubesWithLigas = local.map(c => ({ ...c, ligas: ligaMap[c.liga_id] || null }))
    console.warn('Usando clubes locais de /supabase/seed/clubes.json')
    return clubesWithLigas
  } catch (localErr) {
    console.error('Erro ao carregar clubes locais:', localErr)
    if (queryError) throw queryError
    throw localErr
  }
}

/** Clubes de uma liga específica. */
export async function getClubesPorLiga(ligaId) {
  let queryError = null
  try {
    const { data, error } = await supabase
      .from('clubes')
      .select(`*`)
      .eq('liga_id', ligaId)
      .order('nome')
    if (!error && Array.isArray(data)) {
      return data
    }
    if (error) queryError = error
  } catch (err) {
    queryError = err
  }

  try {
    const resp = await fetch('/supabase/seed/clubes.json')
    if (!resp.ok) throw new Error('Falha ao carregar clubes locais')
    const local = await resp.json()
    return local.filter(clube => clube.liga_id === ligaId)
  } catch (localErr) {
    if (queryError) throw queryError
    throw localErr
  }
}

/** Detalhes completos de um clube (com liga e país). */
export async function getClube(id) {
  const { data, error } = await supabase
    .from('clubes')
    .select(`*, ligas(nome, divisao, paises(nome, codigo))`)
    .eq('id', id)
    .single()
  if (error) throw error
  return data
}

/** Pesquisa clubes por nome. */
export async function pesquisarClubes(query) {
  const { data, error } = await supabase
    .from('clubes')
    .select(`*`)
    .ilike('nome', `%${query}%`)
    .order('nome')
  if (error) throw error
  return data
}

// ── 6. FAVORITOS ─────────────────────────────────────────────

/** Lista os clubes favoritos do utilizador autenticado. */
export async function getFavoritos() {
  const user = await getUser()
  if (!user) return []
  const { data, error } = await supabase
    .from('favoritos')
    .select(`*, clubes(*, ligas(nome, paises(nome)))`)
    .eq('utilizador_id', user.id)
  if (error) throw error
  return data
}

/** Adiciona um clube aos favoritos. */
export async function adicionarFavorito(clubeId) {
  const user = await getUser()
  if (!user) throw new Error('Não autenticado')
  const { data, error } = await supabase
    .from('favoritos')
    .insert([{ utilizador_id: user.id, clube_id: clubeId }])
  if (error) throw error
  return data
}

/** Remove um clube dos favoritos. */
export async function removerFavorito(clubeId) {
  const user = await getUser()
  if (!user) throw new Error('Não autenticado')
  const { error } = await supabase
    .from('favoritos')
    .delete()
    .eq('utilizador_id', user.id)
    .eq('clube_id', clubeId)
  if (error) throw error
}

/** Verifica se um clube é favorito. */
export async function isFavorito(clubeId) {
  const user = await getUser()
  if (!user) return false
  const { data } = await supabase
    .from('favoritos')
    .select('id')
    .eq('utilizador_id', user.id)
    .eq('clube_id', clubeId)
    .single()
  return !!data
}

// ── 7. GALERIA ───────────────────────────────────────────────

/** Imagens da galeria de um clube. */
export async function getGaleria(clubeId) {
  const { data, error } = await supabase
    .from('galeria')
    .select('*')
    .eq('clube_id', clubeId)
  if (error) throw error
  return data
}

// ── 8. CAMISOLAS ─────────────────────────────────────────────

/** Camisolas de um clube. */
export async function getCamisolas(clubeId) {
  const { data, error } = await supabase
    .from('camisolas')
    .select('*')
    .eq('clube_id', clubeId)
  if (error) throw error
  return data
}

// ── 9. HISTÓRIAS ─────────────────────────────────────────────

/** Histórias de um clube. */
export async function getHistorias(clubeId) {
  const { data, error } = await supabase
    .from('historias')
    .select('*')
    .eq('clube_id', clubeId)
  if (error) throw error
  return data
}

// ── 10. ESTADO AUTH NO HEADER ────────────────────────────────
/**
 * Atualiza o botão do header consoante o estado de autenticação.
 * Chama esta função em cada página após importar este módulo.
 */
export async function initAuthHeader() {
  const authBtn = document.getElementById('auth-btn')
  const profileBtn = document.getElementById('profile-btn')
  if (!authBtn) return

  const user = await getUser()
  authBtn.onclick = null
  authBtn.classList.remove('logged-in')

  if (profileBtn) {
    profileBtn.textContent = 'Minha área'
    profileBtn.href = 'auth.html'
  }

  if (user) {
    const perfil = await getPerfil()
    authBtn.textContent = perfil?.username || 'Conta'
    authBtn.href = 'perfil.html'
    authBtn.classList.add('logged-in')

    if (profileBtn) {
      profileBtn.href = 'perfil.html'
    }
  } else {
    authBtn.textContent = 'Entrar'
    authBtn.href = 'auth.html'
  }
}

/**
 * Carrega os clubes em destaque para a página inicial.
 */
export async function carregarClubesDestaque() {
  try {
    console.log('🔍 Iniciando carregamento de clubes...')
    
    const clubes = await getClubes()
    console.log('📊 Clubes recebidos:', clubes)
    
    const container = document.getElementById('clubes-container')
    console.log('📦 Container encontrado:', !!container)
    
    if (!container) {
      console.error('❌ Container #clubes-container não encontrado!')
      return
    }
    
    if (!clubes || clubes.length === 0) {
      console.warn('⚠️ Nenhum clube encontrado na base de dados')
      container.innerHTML = '<div class="col-span-3 text-center py-10"><p class="text-white/50">Nenhum clube disponível</p></div>'
      return
    }

    const uniqueClubes = Array.from(new Map(clubes.map(clube => [clube.id, clube])).values())

    const clubsByLiga = new Map()
    const featuredClubs = []

    for (const clube of uniqueClubes) {
      if (!clubsByLiga.has(clube.liga_id)) {
        clubsByLiga.set(clube.liga_id, clube)
        featuredClubs.push(clube)
      }
      if (featuredClubs.length >= 3) break
    }

    while (featuredClubs.length < 3 && featuredClubs.length < uniqueClubes.length) {
      const remaining = uniqueClubes.filter(clube => !featuredClubs.some(fc => fc.id === clube.id))
      featuredClubs.push(...remaining.slice(0, 3 - featuredClubs.length))
    }

    const ticker = document.getElementById('club-ticker')
    if (ticker) {
      const tickerClubs = uniqueClubes
        .slice(0, 8)
        .map(clube => `<span>${clube.nome}</span><span class="dot">●</span>`)
        .join('')
      ticker.innerHTML = tickerClubs
    }

    const lastHeroId = localStorage.getItem('lastHeroClubId')
    const possibleHeroClubs = uniqueClubes.filter(clube => !lastHeroId || clube.id.toString() !== lastHeroId)
    const heroCandidates = possibleHeroClubs.length > 0 ? possibleHeroClubs : uniqueClubes
    const randomIndex = Math.floor(Math.random() * heroCandidates.length)
    const heroClub = heroCandidates[randomIndex] || featuredClubs[0]

    if (heroClub) {
      localStorage.setItem('lastHeroClubId', heroClub.id.toString())

      const heroImage = document.getElementById('hero-featured-image')
      const heroName = document.getElementById('hero-featured-club')
      const heroCountry = document.getElementById('hero-featured-country')
      const heroLeague = document.getElementById('hero-featured-league')

      if (heroImage) {
        heroImage.src = heroClub.escudo_url || heroImage.src
      }
      if (heroName) heroName.textContent = heroClub.nome
      if (heroCountry) heroCountry.textContent = heroClub.ligas?.paises?.nome || heroClub.cidade || 'Futebol Global'
      if (heroLeague) heroLeague.textContent = heroClub.ligas?.nome || 'Todas as ligas'
    }

    console.log(`✅ Renderizando ${Math.min(3, featuredClubs.length)} clubes em destaque...`)
    
    container.innerHTML = featuredClubs
      .map((clube, idx) => {
        console.log(`  Clube ${idx + 1}:`, clube.nome)
        return `
          <div class="club-card">
            <div class="club-img-wrap">
              <img src="${clube.escudo_url || 'https://via.placeholder.com/400x300?text=' + encodeURIComponent(clube.nome)}" alt="${clube.nome}">
              <div class="club-overlay"></div>
              <span class="club-badge">${clube.ligas?.nome || clube.cidade || '—'}</span>
            </div>
            <div class="club-body">
              <h3>${clube.nome}</h3>
              <p>${clube.descricao || 'Clube futebolístico'}</p>
              <a href="#" class="club-link">Ver bilhete de identidade →</a>
            </div>
          </div>
        `
      }).join('')
    
    console.log('✨ Clubes carregados com sucesso!')
  } catch (error) {
    console.error('❌ Erro ao carregar clubes:', error)
    const container = document.getElementById('clubes-container')
    if (container) {
      container.innerHTML = `<div class="col-span-3 text-center py-10"><p class="text-white/50">Erro: ${error.message}</p></div>`
    }
  }
}
