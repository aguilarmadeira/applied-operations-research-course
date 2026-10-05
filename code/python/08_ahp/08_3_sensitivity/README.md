# 8.3 — Análise de sensibilidade (Python)

- Módulo: `sensibilidade.py` — `pesos_com(w, k, p)`, `sensibilidade(M, w, k, grelha)`, `viragem(M, w, k, i, j)`, `ESCALA`, `perturba(A, rng, degraus)`, `simula_juizos(C, M, qualitativos, N, degraus, seed)`; usa `ahp.py` (8.1) e `atributos.py` (8.2)
- Exemplo: `ex08_3_sensitivity.py` (carrinhas: retas no peso de cada critério, C passa B quando o custo pesa 0,704; o juízo a12 de 1 a 9; a simulação de todos os juízos (B em 100%); Exemplos 6 e 7 da aula (F2 passa F3 a 0,268 no custo da MP e abaixo de 0,426 no transporte; F3 enquanto o rendimento pesar pelo menos 0,484)).
- A versão MATLAB está em `code/matlab/08_ahp/08_3_sensitivity/` e dá a mesma saída, exceto nas linhas das simulações (ver abaixo).

## Como correr

Só precisa de `numpy`. Em qualquer pasta:

```bash
python ex08_3_sensitivity.py
```

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.

## Simulações

`simula_juizos` usa `numpy.random.default_rng(seed)` (semente 1 por omissão, 20 000 repetições). O MATLAB/Octave usa outro gerador (`rng(1)`), por isso as frequências não são iguais às do Python, só próximas (p. ex. 89,9% em Python e 89,8% em Octave no Exemplo 6). Os dois exemplos comparam as frequências com uma tolerância de simulação (±1 ponto percentual, ou ≥ 99,5% quando o slide diz 100%).
