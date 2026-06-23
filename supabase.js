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

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY)

// ── 2. AUTENTICAÇÃO ──────────────────────────────────────────

/**
 * Regista um novo utilizador.
 * Cria conta em auth.users e insere perfil em public.utilizadores.
 */
export async function registar({ username, email, password }) {
  // 2a. Criar conta no Supabase Auth
  const { data, error } = await supabase.auth.signUp({ email, password })
  if (error) throw error

  // 2b. Inserir perfil na tabela utilizadores
  const { error: profileError } = await supabase
    .from('utilizadores')
    .insert([{ id: data.user.id, username, email }])

  if (profileError) throw profileError
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
  const { data: { user } } = await supabase.auth.getUser()
  return user
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
  if (error) throw error
  return data
}

// ── 3. PAÍSES ────────────────────────────────────────────────

/** Lista todos os países. */
export async function getPaises() {
  const { data, error } = await supabase
    .from('paises')
    .select('*')
    .order('nome')
  if (error) throw error
  return data
}

// ── 4. LIGAS ─────────────────────────────────────────────────

/** Lista todas as ligas, com info do país. */
export async function getLigas() {
  const { data, error } = await supabase
    .from('ligas')
    .select(`*, paises(nome, codigo, bandeira_url)`)
    .order('nome')
  if (error) throw error
  return data
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
  try {
    console.log('🔄 Buscando clubes da API...')
    const { data, error } = await supabase
      .from('clubes')
      .select(`*, ligas(nome, paises(nome, codigo))`)
      .order('nome')
    
    if (error) {
      console.error('❌ Erro na query:', error)
      throw error
    }
    
    console.log('✅ Clubes recebidos:', data?.length || 0)
    if (data && data.length > 0) {
      console.log('📋 Exemplo de clube:', data[0])
    }
    
    return data
  } catch (error) {
    console.error('💥 Erro ao buscar clubes:', error.message)
    throw error
  }
}

/** Clubes de uma liga específica. */
export async function getClubesPorLiga(ligaId) {
  const { data, error } = await supabase
    .from('clubes')
    .select(`*`)
    .eq('liga_id', ligaId)
    .order('nome')
  if (error) throw error
  return data
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
  const btn = document.getElementById('auth-btn')
  if (!btn) return

  const user = await getUser()
  if (user) {
    const perfil = await getPerfil()
    btn.textContent = perfil?.username || 'Conta'
    btn.href = '#'
    btn.addEventListener('click', async (e) => {
      e.preventDefault()
      if (confirm('Tens a certeza que queres sair?')) {
        await logout()
        window.location.reload()
      }
    })
  }
  // se não autenticado, btn já aponta para auth.html (default no HTML)
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
