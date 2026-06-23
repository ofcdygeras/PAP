# Fotos das Camisolas

## Convenção de nomes

Cada foto de camisola deve seguir exatamente este formato:

```
Camisola_NomeDoClube_Tipo_Epoca.jpg
```

Exemplos reais:
- `Camisola_Sporting_Home_2024.jpg`
- `Camisola_Sporting_Away_2024.jpg`
- `Camisola_FC_Porto_Home_2024.jpg`
- `Camisola_FC_Porto_Away_2024.jpg`
- `Camisola_SL_Benfica_Home_2023.jpg`

## Regras de nomeação

1. Começa sempre com `Camisola_`
2. O nome do clube **sem acentos** e espaços substituídos por `_`
3. Tipo da camisola: `Home`, `Away`, `Third`, `GK` (Guarda-redes), ou outro
4. Época: `2024`, `2023`, `2022_23`, etc.
5. Extensão `.jpg` — o código também aceita `.png` se alterares o caminho

## Como o código funciona

Em `clube.html`, a função `camisolaPath(nomeClube, tipo, epoca)` constrói automaticamente o caminho:

```
imagens/camisolas/Camisola_NomeDoClube_Tipo_Epoca.jpg
```

O código agora também pode carregar camisolas a partir de um manifesto local:

- lê `imagens/camisolas/camisolas-local.json`
- usa todas as camisolas que baterem no clube
- procura primeiro a imagem local em `imagens/camisolas/`
- se não encontrar local, usa `imagem_url` da base de dados
- se nada existir, mostra um placeholder

Isto permite ter camisolas locais sem depender exclusivamente da base de dados.

## Resolução recomendada

- Mínimo: 300 × 400 px
- Ideal: 600 × 800 px
- Formato: JPG (melhor compressão)
