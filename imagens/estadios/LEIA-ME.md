# Fotos dos Estádios

## Convenção de nomes

Cada foto de estádio deve seguir exatamente este formato:

```
Estadio_NomeDoClube.jpg
```

Exemplos reais:
- `Estadio_Sporting.jpg`
- `Estadio_FC_Porto.jpg`
- `Estadio_Boavista.jpg`
- `Estadio_SC_Braga.jpg`
- `Estadio_Vitoria_de_Guimaraes.jpg`

## Regras de nomeação

1. Começa sempre com `Estadio_`
2. O nome do clube **sem acentos** e espaços substituídos por `_`
3. Extensão `.jpg` (recomendado) — o código também aceita `.png` se alterares o caminho

## Como o código funciona

Em `clube.html`, a função `estadioPath(nomeClube)` constrói automaticamente o caminho:

```
imagens/estadios/Estadio_NomeDoClube.jpg
```

O código tenta primeiro carregar a imagem local desta pasta.
Se não existir, usa o campo `estadio_imagem` da base de dados.
Se também não existir, mostra um placeholder.

## Resolução recomendada

- Mínimo: 800 × 500 px
- Ideal: 1200 × 750 px
- Formato: JPG (melhor compressão para fotos)
