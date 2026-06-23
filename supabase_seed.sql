-- =========================================
-- PORTUGAL
-- LIGA PORTUGAL BETCLIC
-- =========================================

-- PAIS

INSERT INTO paises (
    nome,
    codigo,
    bandeira_url
)

VALUES

(
    'Portugal',
    'PT',
    'https://flagcdn.com/w320/pt.png'
);

-- LIGA

INSERT INTO ligas (

    nome,
    divisao,
    logo_url,
    pais_id

)

VALUES

(
    'Liga Portugal Betclic',
    '1ª Divisão',
    'https://upload.wikimedia.org/wikipedia/commons/5/5c/Liga_Portugal_Betclic.png',
    1
);

-- CLUBES

INSERT INTO clubes (

    nome,
    cidade,
    ano_fundacao,
    descricao,
    escudo_url,
    cores,
    treinador,
    estadio_nome,
    estadio_imagem,
    liga_id

)

VALUES

(
    'Sporting CP',
    'Lisboa',
    1906,
    'Clube histórico português conhecido pela formação.',
    'https://upload.wikimedia.org/wikipedia/en/e/e1/Sporting_CP_logo.svg',
    'Verde e Branco',
    'Rúben Amorim',
    'Estádio José Alvalade',
    'https://upload.wikimedia.org/wikipedia/commons/5/5d/Estadio_Jose_Alvalade.jpg',
    1
),

(
    'FC Porto',
    'Porto',
    1893,
    'Clube português de enorme tradição europeia.',
    'https://upload.wikimedia.org/wikipedia/en/f/f1/FC_Porto.svg',
    'Azul e Branco',
    'Sérgio Conceição',
    'Estádio do Dragão',
    'https://upload.wikimedia.org/wikipedia/commons/0/08/Estadio_do_Dragao.jpg',
    1
),

(
    'SL Benfica',
    'Lisboa',
    1904,
    'Um dos maiores clubes portugueses.',
    'https://upload.wikimedia.org/wikipedia/en/a/a2/SL_Benfica_logo.svg',
    'Vermelho e Branco',
    'Roger Schmidt',
    'Estádio da Luz',
    'https://upload.wikimedia.org/wikipedia/commons/1/1b/Estadio_da_Luz.jpg',
    1
),

(
    'SC Braga',
    'Braga',
    1921,
    'Clube competitivo do futebol português.',
    'https://upload.wikimedia.org/wikipedia/en/8/89/Sporting_Clube_de_Braga_logo.svg',
    'Vermelho e Branco',
    'Artur Jorge',
    'Estádio Municipal de Braga',
    'https://upload.wikimedia.org/wikipedia/commons/5/50/Estadio_Municipal_de_Braga.jpg',
    1
),

(
    'Vitória SC',
    'Guimarães',
    1922,
    'Clube histórico português com adeptos apaixonados.',
    'https://upload.wikimedia.org/wikipedia/en/3/3f/Vit%C3%B3ria_Guimar%C3%A3es_logo.png',
    'Branco e Preto',
    'Álvaro Pacheco',
    'Estádio D. Afonso Henriques',
    'https://upload.wikimedia.org/wikipedia/commons/9/9b/Estadio_D_Afonso_Henriques.jpg',
    1
);
