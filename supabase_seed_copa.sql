-- ============================================================
-- FORA DO RADAR — Seed Data: Países da Copa do Mundo
-- Execute este ficheiro depois do setup inicial
-- ============================================================

-- ──────────────────────────────────────────────────────────
-- PAÍSES
-- ──────────────────────────────────────────────────────────

INSERT INTO paises (nome, codigo, bandeira_url) VALUES

-- Portugal (já existe, mas se precisar de recriar)
-- ('Portugal', 'PT', 'https://flagcdn.com/w320/pt.png'),

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

-- ──────────────────────────────────────────────────────────
-- LIGAS (Assumindo IDs: Portugal=1, Brasil=2, Argentina=3, México=4, etc.)
-- NOTA: Ajusta os pais_id conforme os IDs gerados na tua BD
-- ──────────────────────────────────────────────────────────

-- BRASIL — Brasileirão Série A (pais_id = 2)
INSERT INTO ligas (nome, divisao, logo_url, pais_id) VALUES
('Brasileirão Série A', '1ª Divisão', 'https://upload.wikimedia.org/wikipedia/pt/7/75/Brasileirao_2024_logo.png', 2);

-- ARGENTINA — Liga Profissional (pais_id = 3)
INSERT INTO ligas (nome, divisao, logo_url, pais_id) VALUES
('Liga Profissional Argentina', '1ª Divisão', 'https://upload.wikimedia.org/wikipedia/commons/4/47/Liga_Profesional_de_Fútbol_logo.svg', 3);

-- MÉXICO — Liga MX (pais_id = 4)
INSERT INTO ligas (nome, divisao, logo_url, pais_id) VALUES
('Liga MX', '1ª Divisão', 'https://upload.wikimedia.org/wikipedia/en/7/71/Liga_MX_logo.svg', 4);

-- ESPANHA — La Liga (pais_id = 5)
INSERT INTO ligas (nome, divisao, logo_url, pais_id) VALUES
('La Liga', '1ª Divisão', 'https://upload.wikimedia.org/wikipedia/commons/5/54/LaLiga_EA_Sports_2023_Vertical_Logo.svg', 5);

-- FRANÇA — Ligue 1 (pais_id = 6)
INSERT INTO ligas (nome, divisao, logo_url, pais_id) VALUES
('Ligue 1', '1ª Divisão', 'https://upload.wikimedia.org/wikipedia/en/9/94/Ligue_1_Uber_Eats_logo.png', 6);

-- ALEMANHA — Bundesliga (pais_id = 7)
INSERT INTO ligas (nome, divisao, logo_url, pais_id) VALUES
('Bundesliga', '1ª Divisão', 'https://upload.wikimedia.org/wikipedia/en/d/df/Bundesliga_logo_%282017%29.svg', 7);

-- INGLATERRA — Premier League (pais_id = 8)
INSERT INTO ligas (nome, divisao, logo_url, pais_id) VALUES
('Premier League', '1ª Divisão', 'https://upload.wikimedia.org/wikipedia/en/f/f2/Premier_League_Logo.svg', 8);

-- ESTADOS UNIDOS — MLS (pais_id = 9)
INSERT INTO ligas (nome, divisao, logo_url, pais_id) VALUES
('Major League Soccer', '1ª Divisão', 'https://upload.wikimedia.org/wikipedia/en/6/67/Major_League_Soccer_logo.svg', 9);

-- JAPÃO — J-League (pais_id = 10)
INSERT INTO ligas (nome, divisao, logo_url, pais_id) VALUES
('J1 League', '1ª Divisão', 'https://upload.wikimedia.org/wikipedia/en/7/73/J.League_logo.svg', 10);

-- COREIA DO SUL — K-League (pais_id = 11)
INSERT INTO ligas (nome, divisao, logo_url, pais_id) VALUES
('K League 1', '1ª Divisão', 'https://upload.wikimedia.org/wikipedia/en/d/d8/K_League_1_logo.svg', 11);

-- INDONÉSIA — Liga 1 (pais_id = 12)
INSERT INTO ligas (nome, divisao, logo_url, pais_id) VALUES
('Liga 1 Indonésia', '1ª Divisão', 'https://upload.wikimedia.org/wikipedia/en/4/47/Liga_1_Indonesia_logo.svg', 12);

-- FINLÂNDIA — Veikkausliiga (pais_id = 13)
INSERT INTO ligas (nome, divisao, logo_url, pais_id) VALUES
('Veikkausliiga', '1ª Divisão', 'https://upload.wikimedia.org/wikipedia/en/2/2e/Veikkausliiga_logo.svg', 13);

-- ──────────────────────────────────────────────────────────
-- CLUBES BRASIL (liga_id = 2 - Brasileirão)
-- ──────────────────────────────────────────────────────────

INSERT INTO clubes (nome, cidade, ano_fundacao, descricao, escudo_url, cores, treinador, estadio_nome, estadio_imagem, liga_id) VALUES

('Flamengo', 'Rio de Janeiro', 1895,
 'Um dos clubes mais populares do Brasil e das Américas.',
 'https://upload.wikimedia.org/wikipedia/en/2/2e/Flamengo_bancecs.svg',
 'Vermelho e Preto',
 'Tite',
 'Maracanã',
 'https://upload.wikimedia.org/wikipedia/commons/1/18/Maracanã_stadium_2013.jpg',
 2),

('Palmeiras', 'São Paulo', 1914,
 'Clube brasileiro com grande história internacional.',
 'https://upload.wikimedia.org/wikipedia/commons/1/10/Palmeiras_logo.svg',
 'Verde e Branco',
 'Abel Ferreira',
 'Allianz Parque',
 'https://upload.wikimedia.org/wikipedia/commons/0/0b/Allianz_Parque_-_Palmeiras.jpg',
 2),

('São Paulo FC', 'São Paulo', 1930,
 'Tradicional clube brasileiro com 3 títulos mundiais.',
 'https://upload.wikimedia.org/wikipedia/en/8/8a/Sao_Paulo_FC_logo.svg',
 'Vermelho, Preto e Branco',
 'Dorival Júnior',
 'Morumbi',
 'https://upload.wikimedia.org/wikipedia/commons/5/53/Estádio_do_Morumbi.jpg',
 2),

('Corinthians', 'São Paulo', 1910,
 'Clube popular brasileiro com milhões de torcedores.',
 'https://upload.wikimedia.org/wikipedia/en/9/96/SC_Corinthians_Paulista_logo.svg',
 'Preto e Branco',
 'Ramón Díaz',
 'Neo Química Arena',
 'https://upload.wikimedia.org/wikipedia/commons/1/12/Arena_Corinthians.jpg',
 2),

('Santos FC', 'Santos', 1912,
 'Clube que revelou Pelé e Neymar.',
 'https://upload.wikimedia.org/wikipedia/en/9/9f/Santos_Logo.svg',
 'Preto e Branco',
 'Fábio Carille',
 'Vila Belmiro',
 'https://upload.wikimedia.org/wikipedia/commons/a/a5/Estádio_Vila_Belmiro.jpg',
 2);

-- ──────────────────────────────────────────────────────────
-- CLUBES ARGENTINA (liga_id = 3 - Liga Profissional)
-- ──────────────────────────────────────────────────────────

INSERT INTO clubes (nome, cidade, ano_fundacao, descricao, escudo_url, cores, treinador, estadio_nome, estadio_imagem, liga_id) VALUES

('Boca Juniors', 'Buenos Aires', 1905,
 'Um dos clubes mais populares da Argentina.',
 'https://upload.wikimedia.org/wikipedia/en/4/41/Boca_Juniors_logo.svg',
 'Azul e Amarelo',
 'Diego Martínez',
 'La Bombonera',
 'https://upload.wikimedia.org/wikipedia/commons/4/41/Boca_Juniors_stadium_La_Bombonera.jpg',
 3),

('River Plate', 'Buenos Aires', 1901,
 'Rival histórico do Boca Juniors.',
 'https://upload.wikimedia.org/wikipedia/commons/a/a1/River_Plate_logo.svg',
 'Vermelho e Branco',
 'Martín Demichelis',
 'Monumental de Núñez',
 'https://upload.wikimedia.org/wikipedia/commons/1/17/Estadio_Monumental_Buenos_Aires.jpg',
 3),

('Racing Club', 'Avellaneda', 1903,
 'Clube tradicional argentino.',
 'https://upload.wikimedia.org/wikipedia/en/8/86/Racing_Club_logo.svg',
 'Azul e Branco',
 'Gustavo Costas',
 'Estadio Presidente Perón',
 'https://upload.wikimedia.org/wikipedia/commons/5/59/Estadio_Presidente_Perón.jpg',
 3),

('Independiente', 'Avellaneda', 1905,
 'O "Rei de Copas" sul-americano.',
 'https://upload.wikimedia.org/wikipedia/en/9/9e/Club_Atlético_Independiente_logo.svg',
 'Vermelho',
 'Carlos Tevez',
 'Estadio Libertadores de América',
 'https://upload.wikimedia.org/wikipedia/commons/d/d9/Estadio_Libertadores_de_America.jpg',
 3),

('Estudiantes', 'La Plata', 1905,
 'Clube universitário com tradição.',
 'https://upload.wikimedia.org/wikipedia/en/e/e9/Estudiantes_de_La_Plata_logo.svg',
 'Branco e Vermelho',
 'Eduardo Domínguez',
 'Estadio Jorge Luis Hirschi',
 'https://upload.wikimedia.org/wikipedia/commons/b/b5/Estadio_Jorge_Luis_Hirschi.jpg',
 3);

-- ──────────────────────────────────────────────────────────
-- CLUBES MÉXICO (liga_id = 4 - Liga MX)
-- ──────────────────────────────────────────────────────────

INSERT INTO clubes (nome, cidade, ano_fundacao, descricao, escudo_url, cores, treinador, estadio_nome, estadio_imagem, liga_id) VALUES

('Club América', 'Cidade do México', 1916,
 'O clube mais popular do México.',
 'https://upload.wikimedia.org/wikipedia/en/a/a2/Club_America_logo.svg',
 'Amarelo e Azul',
 'André Jardine',
 'Estadio Azteca',
 'https://upload.wikimedia.org/wikipedia/commons/0/05/Estadio_Azteca_02.jpg',
 4),

('Chivas Guadalajara', 'Guadalajara', 1906,
 'Clube mexicano que só joga com jogadores mexicanos.',
 'https://upload.wikimedia.org/wikipedia/en/6/69/Chivas_de_Guadalajara_logo.svg',
 'Vermelho e Branco',
 'Fernando Gago',
 'Estadio Akron',
 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Estadio_Akron.jpg',
 4),

('Cruz Azul', 'Cidade do México', 1927,
 'Clube tradicional da capital mexicana.',
 'https://upload.wikimedia.org/wikipedia/en/5/57/Club_Deportivo_Cruz_Azul_logo.svg',
 'Azul',
 'Martín Anselmi',
 'Estadio Azteca',
 'https://upload.wikimedia.org/wikipedia/commons/0/05/Estadio_Azteca_02.jpg',
 4),

('Pumas UNAM', 'Cidade do México', 1954,
 'Clube universitário do México.',
 'https://upload.wikimedia.org/wikipedia/en/a/a0/Club_Universidad_Nacional_logo.svg',
 'Azul e Amarelo',
 'Gustavo Lema',
 'Estadio Olímpico Universitario',
 'https://upload.wikimedia.org/wikipedia/commons/7/7f/Estadio_Ol%C3%ADmpico_Universitario_-_Mexico_city.jpg',
 4),

('Monterrey', 'Monterrey', 1945,
 'Clube do norte do México.',
 'https://upload.wikimedia.org/wikipedia/en/b/bb/CF_Monterrey_logo.svg',
 'Azul e Branco',
 'Fernando Ortiz',
 'Estadio BBVA',
 'https://upload.wikimedia.org/wikipedia/commons/0/0a/Estadio_BBVA_Bancomer_Monterrey.jpg',
 4);

-- ──────────────────────────────────────────────────────────
-- CLUBES ESPANHA (liga_id = 5 - La Liga)
-- ──────────────────────────────────────────────────────────

INSERT INTO clubes (nome, cidade, ano_fundacao, descricao, escudo_url, cores, treinador, estadio_nome, estadio_imagem, liga_id) VALUES

('Real Madrid', 'Madrid', 1902,
 'Um dos maiores clubes do mundo.',
 'https://upload.wikimedia.org/wikipedia/en/5/56/Real_Madrid_CF.svg',
 'Branco',
 'Carlo Ancelotti',
 'Santiago Bernabéu',
 'https://upload.wikimedia.org/wikipedia/commons/9/98/Santiago_Bernabeu_stadium_%28Madrid%29.jpg',
 5),

('FC Barcelona', 'Barcelona', 1899,
 'Clube catalão de renome mundial.',
 'https://upload.wikimedia.org/wikipedia/en/4/47/FC_Barcelona_%28crest%29.svg',
 'Azul e Vermelho',
 'Hansi Flick',
 'Spotify Camp Nou',
 'https://upload.wikimedia.org/wikipedia/commons/0/09/Camp_Nou_2015.jpg',
 5),

('Atlético Madrid', 'Madrid', 1903,
 'Clube da capital espanhola.',
 'https://upload.wikimedia.org/wikipedia/en/f/f4/Atletico_Madrid_2017_logo.svg',
 'Vermelho e Branco',
 'Diego Simeone',
 'Estadio Metropolitano',
 'https://upload.wikimedia.org/wikipedia/commons/0/04/Wanda_Metropolitano_aerial_view.jpg',
 5),

('Athletic Bilbao', 'Bilbao', 1898,
 'Clube basco que só joga com jogadores locais.',
 'https://upload.wikimedia.org/wikipedia/en/9/98/Club_Athletic_Bilbao_logo.svg',
 'Vermelho e Branco',
 'Ernesto Valverde',
 'San Mamés',
 'https://upload.wikimedia.org/wikipedia/commons/4/49/San_Mames_Bilbao.jpg',
 5),

('Real Sociedad', 'San Sebastián', 1909,
 'Clube basco com grande academia.',
 'https://upload.wikimedia.org/wikipedia/en/f/f1/Real_Sociedad_logo.svg',
 'Azul e Branco',
 'Imanol Alguacil',
 'Reale Arena',
 'https://upload.wikimedia.org/wikipedia/commons/c/c5/Estadio_Anoeta.jpg',
 5);

-- ──────────────────────────────────────────────────────────
-- CLUBES FRANÇA (liga_id = 6 - Ligue 1)
-- ──────────────────────────────────────────────────────────

INSERT INTO clubes (nome, cidade, ano_fundacao, descricao, escudo_url, cores, treinador, estadio_nome, estadio_imagem, liga_id) VALUES

('Paris Saint-Germain', 'Paris', 1970,
 'Clube francês dominante.',
 'https://upload.wikimedia.org/wikipedia/en/a/a7/Paris_Saint-Germain_F.C..svg',
 'Azul e Vermelho',
 'Luis Enrique',
 'Parc des Princes',
 'https://upload.wikimedia.org/wikipedia/commons/0/0c/Parc_des_Princes_-_Paris_-_20140613.jpg',
 6),

('Olympique Marseille', 'Marseille', 1899,
 'Clube francês com grande torcida.',
 'https://upload.wikimedia.org/wikipedia/commons/d/d8/Olympique_Marseille_logo.svg',
 'Azul e Branco',
 'Roberto De Zerbi',
 'Orange Vélodrome',
 'https://upload.wikimedia.org/wikipedia/commons/d/d9/Le_Stade_V%c3%a9lodrome_de_Marseille.jpg',
 6),

('AS Monaco', 'Mônaco', 1924,
 'Clube do principado de Mônaco.',
 'https://upload.wikimedia.org/wikipedia/en/e/e2/AS_Monaco_FC.svg',
 'Vermelho e Branco',
 'Adi Hütter',
 'Stade Louis-II',
 'https://upload.wikimedia.org/wikipedia/commons/f/f2/Stade_Louis-II_-_Monaco_04.jpg',
 6),

('Olympique Lyon', 'Lyon', 1950,
 'Clube tradicional francês.',
 'https://upload.wikimedia.org/wikipedia/en/a/a0/Olympique_Lyonnais.svg',
 'Branco, Azul e Vermelho',
 'Pierre Sage',
 'Groupama Stadium',
 'https://upload.wikimedia.org/wikipedia/commons/3/31/Groupama_Stadium_2016.jpg',
 6),

('LOSC Lille', 'Lille', 1944,
 'Clube do norte de França.',
 'https://upload.wikimedia.org/wikipedia/en/3/3f/LOSC_Lille_M%C3%A9tropole_2018_logo.svg',
 'Vermelho e Azul',
 'Paulo Fonseca',
 'Stade Pierre-Mauroy',
 'https://upload.wikimedia.org/wikipedia/commons/4/49/Pierre-Mauroy_2012.jpg',
 6);

-- ──────────────────────────────────────────────────────────
-- CLUBES ALEMANHA (liga_id = 7 - Bundesliga)
-- ──────────────────────────────────────────────────────────

INSERT INTO clubes (nome, cidade, ano_fundacao, descricao, escudo_url, cores, treinador, estadio_nome, estadio_imagem, liga_id) VALUES

('Bayern Munique', 'Munique', 1900,
 'O gigante do futebol alemão.',
 'https://upload.wikimedia.org/wikipedia/commons/1/1b/FC_Bayern_M%C3%BCnchen_logo_%282017%29.svg',
 'Vermelho e Branco',
 'Vincent Kompany',
 'Allianz Arena',
 'https://upload.wikimedia.org/wikipedia/commons/1/1e/Allianz_Arena_aerial_view.jpg',
 7),

('Borussia Dortmund', 'Dortmund', 1909,
 'Clube alemão com a maior média de público.',
 'https://upload.wikimedia.org/wikipedia/commons/6/67/Borussia_Dortmund_logo.svg',
 'Amarelo e Preto',
 'Nuri Şahin',
 'Signal Iduna Park',
 'https://upload.wikimedia.org/wikipedia/commons/c/c4/Signal_Iduna_Park_2010.jpg',
 7),

('RB Leipzig', 'Leipzig', 2009,
 'Clube moderno da Alemanha.',
 'https://upload.wikimedia.org/wikipedia/en/0/04/RB_Leipzig_2014_logo.svg',
 'Vermelho e Branco',
 'Marco Rose',
 'Red Bull Arena',
 'https://upload.wikimedia.org/wikipedia/commons/5/5d/Red_Bull_Arena_Leipzig.jpg',
 7),

('Bayer Leverkusen', 'Leverkusen', 1904,
 'Clube alemão com grande tradição.',
 'https://upload.wikimedia.org/wikipedia/en/5/5e/Bayer_04_Leverkusen_logo.svg',
 'Vermelho e Preto',
 'Xabi Alonso',
 'BayArena',
 'https://upload.wikimedia.org/wikipedia/commons/8/86/BayArena_2011.jpg',
 7),

('VfB Stuttgart', 'Stuttgart', 1893,
 'Clube tradicional alemão.',
 'https://upload.wikimedia.org/wikipedia/en/0/01/VfB_Stuttgart_1893_logo.svg',
 'Vermelho e Branco',
 'Sebastian Hoeneß',
 'MHPArena',
 'https://upload.wikimedia.org/wikipedia/commons/2/2f/Mercedes-Benz_Arena_Stuttgart.jpg',
 7);

-- ──────────────────────────────────────────────────────────
-- CLUBES INGLATERRA (liga_id = 8 - Premier League)
-- ──────────────────────────────────────────────────────────

INSERT INTO clubes (nome, cidade, ano_fundacao, descricao, escudo_url, cores, treinador, estadio_nome, estadio_imagem, liga_id) VALUES

('Manchester City', 'Manchester', 1880,
 'Clube inglês dominante nos últimos anos.',
 'https://upload.wikimedia.org/wikipedia/en/e/eb/Manchester_City_FC_badge.svg',
 'Azul celeste',
 'Pep Guardiola',
 'Etihad Stadium',
 'https://upload.wikimedia.org/wikipedia/commons/4/4e/Etihad_Stadium.jpg',
 8),

('Liverpool', 'Liverpool', 1892,
 'Clube inglês com história europeia.',
 'https://upload.wikimedia.org/wikipedia/en/0/0c/Liverpool_FC.svg',
 'Vermelho',
 'Arne Slot',
 'Anfield',
 'https://upload.wikimedia.org/wikipedia/commons/f/f8/Anfield_stadium.jpg',
 8),

('Arsenal', 'Londres', 1886,
 'Clube londrino tradicional.',
 'https://upload.wikimedia.org/wikipedia/en/5/53/Arsenal_FC.svg',
 'Vermelho e Branco',
 'Mikel Arteta',
 'Emirates Stadium',
 'https://upload.wikimedia.org/wikipedia/commons/2/2c/Emirates_Stadium_20080729.jpg',
 8),

('Manchester United', 'Manchester', 1878,
 'Um dos clubes mais populares do mundo.',
 'https://upload.wikimedia.org/wikipedia/en/7/7a/Manchester_United_FC_crest.svg',
 'Vermelho',
 'Ruben Amorim',
 'Old Trafford',
 'https://upload.wikimedia.org/wikipedia/commons/5/5d/Old_Trafford_2022.jpg',
 8),

('Chelsea', 'Londres', 1905,
 'Clube londrino com sucesso europeu.',
 'https://upload.wikimedia.org/wikipedia/en/c/cc/Chelsea_FC.svg',
 'Azul',
 'Enzo Maresca',
 'Stamford Bridge',
 'https://upload.wikimedia.org/wikipedia/commons/b/b9/Stamford_Bridge_North_Stand.jpg',
 8);

-- ──────────────────────────────────────────────────────────
-- CLUBES ESTADOS UNIDOS (liga_id = 9 - MLS)
-- ──────────────────────────────────────────────────────────

INSERT INTO clubes (nome, cidade, ano_fundacao, descricao, escudo_url, cores, treinador, estadio_nome, estadio_imagem, liga_id) VALUES

('LA Galaxy', 'Los Angeles', 1994,
 'Clube mais vitorioso da MLS.',
 'https://upload.wikimedia.org/wikipedia/en/a/a5/LA_Galaxy_logo.svg',
 'Azul e Amarelo',
 'Greg Vanney',
 'Dignity Health Sports Park',
 'https://upload.wikimedia.org/wikipedia/commons/8/86/Dignity_Health_Sports_Park_soccer.jpg',
 9),

('Inter Miami CF', 'Miami', 2018,
 'Clube de Miami com Lionel Messi.',
 'https://upload.wikimedia.org/wikipedia/en/9/9b/Inter_Miami_CF_logo.svg',
 'Rosa, Preto e Branco',
 'Javier Mascherano',
 'Chase Stadium',
 'https://upload.wikimedia.org/wikipedia/commons/6/6a/Inter_Miami_CF_Stadium.jpg',
 9),

('Atlanta United', 'Atlanta', 2014,
 'Clube com grande torcida nos EUA.',
 'https://upload.wikimedia.org/wikipedia/en/4/46/Atlanta_United_FC_logo.svg',
 'Vermelho, Preto e Dourado',
 'Rob Valentino',
 'Mercedes-Benz Stadium',
 'https://upload.wikimedia.org/wikipedia/commons/6/6f/Mercedes-Benz_Stadium_seating.jpg',
 9),

('Seattle Sounders', 'Seattle', 2007,
 'Clube do noroeste dos EUA.',
 'https://upload.wikimedia.org/wikipedia/en/1/17/Seattle_Sounders_FC_logo.svg',
 'Verde e Azul',
 'Brian Schmetzer',
 'Lumen Field',
 'https://upload.wikimedia.org/wikipedia/commons/7/7b/Lumen_Field_Seattle.jpg',
 9),

('New York City FC', 'Nova Iorque', 2013,
 'Clube da cidade de Nova Iorque.',
 'https://upload.wikimedia.org/wikipedia/en/9/99/New_York_City_FC_logo.svg',
 'Azul e Branco',
 'Nick Cushing',
 'Yankee Stadium',
 'https://upload.wikimedia.org/wikipedia/commons/6/62/Yankee_Stadium_2011.jpg',
 9);

-- ──────────────────────────────────────────────────────────
-- CLUBES JAPÃO (liga_id = 10 - J1 League)
-- ──────────────────────────────────────────────────────────

INSERT INTO clubes (nome, cidade, ano_fundacao, descricao, escudo_url, cores, treinador, estadio_nome, estadio_imagem, liga_id) VALUES

('Urawa Red Diamonds', 'Saitama', 1950,
 'Clube japonês com grande torcida.',
 'https://upload.wikimedia.org/wikipedia/en/7/70/Urawa_Red_Diamonds.svg',
 'Vermelho',
 'Maco Skvarce',
 'Saitama Stadium',
 'https://upload.wikimedia.org/wikipedia/commons/9/97/Saitama_Stadium_2002.jpg',
 10),

('Kashima Antlers', 'Kashima', 1947,
 'Clube mais vitorioso do Japão.',
 'https://upload.wikimedia.org/wikipedia/en/a/a9/Kashima_Antlers.svg',
 'Vermelho e Azul',
 'Masatada Ishii',
 'Kashima Soccer Stadium',
 'https://upload.wikimedia.org/wikipedia/commons/5/5b/Kashima_Soccer_Stadium_2008.jpg',
 10),

('Yokohama F. Marinos', 'Yokohama', 1972,
 'Clube do porto de Yokohama.',
 'https://upload.wikimedia.org/wikipedia/en/4/46/Yokohama_F._Marinos_logo.svg',
 'Azul e Branco',
 'Harry Kewell',
 'Nissan Stadium',
 'https://upload.wikimedia.org/wikipedia/commons/3/33/Yokohama_International_Stadium_2005.jpg',
 10),

('Shimizu S-Pulse', 'Shizuoka', 1991,
 'Clube da região de Shizuoka.',
 'https://upload.wikimedia.org/wikipedia/en/3/36/Shimizu_S-Pulse_logo.svg',
 'Laranja',
 'Hiroaki Hiraoka',
 'IAI Stadium Nihondaira',
 'https://upload.wikimedia.org/wikipedia/commons/d/d8/Nihondaira_Stadium_2012.jpg',
 10),

('Gamba Osaka', 'Osaka', 1980,
 'Clube da região de Kansai.',
 'https://upload.wikimedia.org/wikipedia/en/8/84/Gamba_Osaka_logo.svg',
 'Preto e Azul',
 'Dani Poyatos',
 'Panasonic Stadium Suita',
 'https://upload.wikimedia.org/wikipedia/commons/4/40/Panasonic_Stadium_Suita_20150904.jpg',
 10);

-- ──────────────────────────────────────────────────────────
-- CLUBES COREIA DO SUL (liga_id = 11 - K League 1)
-- ──────────────────────────────────────────────────────────

INSERT INTO clubes (nome, cidade, ano_fundacao, descricao, escudo_url, cores, treinador, estadio_nome, estadio_imagem, liga_id) VALUES

('Jeonbuk Hyundai Motors', 'Jeonju', 1994,
 'Clube mais vitorioso da Coreia.',
 'https://upload.wikimedia.org/wikipedia/en/c/c6/Jeonbuk_Hyundai_Motors_FC_logo.svg',
 'Verde',
 'Kim Sang-sik',
 'Jeonju World Cup Stadium',
 'https://upload.wikimedia.org/wikipedia/commons/6/67/Jeonju_World_Cup_Stadium_2006.jpg',
 11),

('Ulsan Hyundai', 'Ulsan', 1983,
 'Clube do porto de Ulsan.',
 'https://upload.wikimedia.org/wikipedia/en/3/3e/Ulsan_Hyundai_FC_logo.svg',
 'Azul e Laranja',
 'Hong Myung-bo',
 'Ulsan Munsu Football Stadium',
 'https://upload.wikimedia.org/wikipedia/commons/3/3a/Ulsan_Munsu_Football_Stadium_2018.jpg',
 11),

('FC Seoul', 'Seul', 1983,
 'Clube da capital sul-coreana.',
 'https://upload.wikimedia.org/wikipedia/en/9/9b/FC_Seoul_logo.svg',
 'Vermelho e Preto',
 'Kim Ki-dong',
 'Seoul World Cup Stadium',
 'https://upload.wikimedia.org/wikipedia/commons/5/5c/Seoul_World_Cup_Stadium_2009.jpg',
 11),

('Pohang Steelers', 'Pohang', 1973,
 'Clube tradicional coreano.',
 'https://upload.wikimedia.org/wikipedia/en/d/d0/Pohang_Steelers_FC_logo.svg',
 'Vermelho e Preto',
 'Park Tae-ha',
 'Pohang Steel Yard',
 'https://upload.wikimedia.org/wikipedia/commons/6/68/Pohang_Steel_Yard_2006.jpg',
 11),

('Suwon Samsung Bluewings', 'Suwon', 1995,
 'Clube da região metropolitana.',
 'https://upload.wikimedia.org/wikipedia/en/4/49/Suwon_Samsung_Bluewings_logo.svg',
 'Azul',
 'Kim Byung-soo',
 'Suwon World Cup Stadium',
 'https://upload.wikimedia.org/wikipedia/commons/1/16/Suwon_World_Cup_Stadium_2006.jpg',
 11);

-- ──────────────────────────────────────────────────────────
-- ──────────────────────────────────────────────────────────
-- ✅ SEED COMPLETO: 13 países, 14 ligas, 65+ clubes
-- ──────────────────────────────────────────────────────────
-- Depois de executar, as estatísticas do site serão:
-- - 13 países
-- - 14 ligas
-- - 65+ clubes
-- ──────────────────────────────────────────────────────────
