#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

function toSlug(str) {
  return str
    .toString()
    .toLowerCase()
    .normalize('NFD')
    .replace(/\p{Diacritic}/gu, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
}

function normalizeClubName(nome) {
  const slug = toSlug(nome)
  const base = slug
    .replace(/-(?:fc|cf|sc|ac|cd|cp|club|clube|clube-do|clube-de|club-de|club-do|team)$/g, '')
    .replace(/--+/g, '-')
    .replace(/^-+|-+$/g, '')

  const tokens = slug.split('-').filter(Boolean)
  return { slug, base, tokens }
}

const GENERIC_TOKENS = new Set(['fc', 'cf', 'sc', 'ac', 'cd', 'cp', 'club', 'clube', 'team', 'de', 'do', 'da', 'dos', 'das', 'the', 'of', 'new', 'a', 'e', 'o', 'em'])

const logoSlugOverrides = {
  'bayern-munchen': 1041,
  'cd-guadalajara': 1025,
  'urawa-reds': 1061,
  'ulsan-hd-fc': 1072,
  'suwon-fc': 1075,
}

function normalizeLogoSlug(slug) {
  return slug
    .replace(/\bmunchen\b/g, 'munique')
    .replace(/\bhd\b/g, 'hyundai')
    .replace(/\bcd\b/g, 'club-deportivo')
    .replace(/\breds\b/g, 'red-diamonds')
    .replace(/\bnew-york\b/g, 'new-york')
}

function normalizeTokens(text) {
  return text
    .toString()
    .toLowerCase()
    .normalize('NFD')
    .replace(/\p{Diacritic}/gu, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .split('-')
    .filter(Boolean)
    .filter(token => !GENERIC_TOKENS.has(token))
}

function scoreMatch(clube, logoSlug) {
  const normalizedLogoSlug = normalizeLogoSlug(logoSlug)
  const logoTokens = new Set(normalizeTokens(normalizedLogoSlug))
  const clubTokens = new Set(normalizeTokens(clube.nome))
  const clubSlug = normalizeTokens(clube.nome).join('-')
  const clubBase = normalizeTokens(clube.nome.replace(/\b(fc|cf|sc|ac|cd|cp|club|clube|team)\b/g, '')).join('-')

  let score = 0
  if (logoSlug === clubSlug || logoSlug === clubBase) score += 200
  if (normalizedLogoSlug.includes(clubSlug) || clubSlug.includes(normalizedLogoSlug)) score += 120
  if (normalizedLogoSlug.includes(clubBase) || clubBase.includes(normalizedLogoSlug)) score += 100

  const sharedTokens = [...clubTokens].filter(token => logoTokens.has(token))
  score += sharedTokens.length * 30

  if (sharedTokens.length > 0 && [...logoTokens].every(t => clubTokens.has(t) || GENERIC_TOKENS.has(t))) {
    score += 40
  }

  if (normalizedLogoSlug === 'bayern-munchen' && club.nome.toLowerCase().includes('munique')) score += 80
  if (normalizedLogoSlug === 'cd-guadalajara' && club.nome.toLowerCase().includes('guadalajara')) score += 80
  if (normalizedLogoSlug === 'urawa-reds' && club.nome.toLowerCase().includes('urawa')) score += 80
  if (normalizedLogoSlug === 'ulsan-hd-fc' && club.nome.toLowerCase().includes('ulsan')) score += 80
  if (normalizedLogoSlug === 'suwon-fc' && club.nome.toLowerCase().includes('suwon')) score += 80

  return score
}

function findBestClubMatch(clubeList, logoSlug) {
  if (logoSlugOverrides[logoSlug]) {
    return clubeList.find(clube => clube.id === logoSlugOverrides[logoSlug]) || null
  }

  const scored = clubeList.map(clube => ({ clube, score: scoreMatch(clube, logoSlug) }))
  if (scored.length === 0) return null
  scored.sort((a, b) => b.score - a.score)

  if (scored[0].score >= 80) {
    return scored[0].clube
  }

  return null
}

const ligaNomeParaId = {
  'Liga Portugal': 1,
  'Liga Brasil': 2,
  'Liga Argentina': 3,
  'Liga Mexico': 4,
  'Liga Espanha': 5,
  'Liga França': 6,
  'Liga Alemanha': 7,
  'Liga englaterra': 8,
  'Liga USA': 9,
  'Liga Japão': 10,
  'Liga Korea': 11,
  'Liga Indonésia': 12,
  'Liga Filandia': 13,
}

const clubesPath = path.join(__dirname, 'supabase/seed/clubes.json');
const clubes = JSON.parse(fs.readFileSync(clubesPath, 'utf-8'));
const clubesMap = {}
clubes.forEach(c => {
  if (!clubesMap[c.liga_id]) clubesMap[c.liga_id] = []
  clubesMap[c.liga_id].push({ ...c, normalized: normalizeClubName(c.nome) })
})

const idCounts = clubes.reduce((acc, clube) => {
  acc[clube.id] = (acc[clube.id] || 0) + 1
  return acc
}, {})

const mapeamento = {
  clubes: {},
  clubesPorNome: {},
  clubesPorLigaNome: {},
}
const logosPath = path.join(__dirname, 'Ligas')
const ligaPastas = fs.readdirSync(logosPath).filter(f => fs.statSync(path.join(logosPath, f)).isDirectory())

function clubNameKey(nome) {
  return toSlug(nome)
}

ligaPastas.forEach(ligaNome => {
  const ligaId = ligaNomeParaId[ligaNome]
  if (!ligaId) {
    console.warn(`⚠️  Aviso: Não encontrado id de liga para pasta "${ligaNome}"`)
    return
  }

  const ligaPath = path.join(logosPath, ligaNome)
  const logos = fs.readdirSync(ligaPath).filter(f => /\.(png|jpe?g)$/i.test(f))
  console.log(`\n📁 Processando ${ligaNome} (${logos.length} logos)`)

  const clubesDaLiga = clubesMap[ligaId] || []

  logos.forEach(logo => {
    const match = logo.match(/^[^_]+_(.+?)_512x512/i)
    if (!match) {
      console.log(`  ⚠️  Ignorado arquivo sem padrão: ${logo}`)
      return
    }

    const logoSlug = toSlug(match[1])
    if (!logoSlug) return

    const clubeEncontrado = findBestClubMatch(clubesDaLiga, logoSlug)
    if (clubeEncontrado) {
      const relativePath = `./Ligas/${ligaNome}/${logo}`
      const nomeKey = clubNameKey(clubeEncontrado.nome)
      const ligaNomeKey = `${ligaId}:${nomeKey}`

      if (idCounts[clubeEncontrado.id] === 1) {
        mapeamento.clubes[clubeEncontrado.id] = relativePath
      } else {
        console.log(`  ⚠️  Clube id duplicado ${clubeEncontrado.id}, skip id map`)      }
      if (!mapeamento.clubesPorNome[nomeKey]) {
        mapeamento.clubesPorNome[nomeKey] = relativePath
      }
      mapeamento.clubesPorLigaNome[ligaNomeKey] = relativePath
      console.log(`  ✅ ${clubeEncontrado.nome} → ${logo}`)
    } else {
      console.log(`  ⚠️  Não encontrado clube para: ${logo}`)
    }
  })
})

const output = {
  comentario: 'Mapeamento de clubes para logos locais. Gerado automaticamente.',
  estrutura: 'clubes: { [club_id]: "caminho/relativo/logo.png" }, clubesPorNome: { [nome_slug]: "caminho/relativo/logo.png" }, clubesPorLigaNome: { ["ligaId:nome_slug"]: "caminho/relativo/logo.png" }',
  timestamp: new Date().toISOString(),
  clubes: mapeamento.clubes,
  clubesPorNome: mapeamento.clubesPorNome,
  clubesPorLigaNome: mapeamento.clubesPorLigaNome,
}

const outputPathJson = path.join(__dirname, 'imagens/logos-mapping.json');
const outputPathJs = path.join(__dirname, 'imagens/logos-mapping.js');
fs.writeFileSync(outputPathJson, JSON.stringify(output, null, 2))
fs.writeFileSync(outputPathJs, `export default ${JSON.stringify(output, null, 2)};\n`)

console.log(`\n✨ Mapeamento salvo em: ${outputPathJson}`)
console.log(`✨ Mapeamento JS salvo em: ${outputPathJs}`)
console.log(`📊 Total de clubes mapeados por id: ${Object.keys(output.clubes).length}`)
console.log(`📊 Total de entradas por nome: ${Object.keys(output.clubesPorNome).length}`)
console.log(`📊 Total de entradas por liga+nome: ${Object.keys(output.clubesPorLigaNome).length}`)
