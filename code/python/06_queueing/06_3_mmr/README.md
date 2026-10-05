# 6.3 — Filas de espera: população finita, M/M/R (Python)

- Módulo: `filas_mmr.py` — `mmR(K, R, lam, mu)`
- Exemplo: `ex06_3_mmr.py` (10 empilhadores, 1 a 3 técnicos: L = 2.97, 1.35, 1.14 parados, custo 893, 636, 736 €/dia, logo dois técnicos; o erro do modelo de população infinita (rho = 1.25); Exemplo 3 da aula, a lavandaria: 1.71 máquinas paradas com 3 mecânicos contra 1.16 com o super-mecânico, logo trocar).
- `mmR` devolve um dicionário (`e['L']`, `e['Lq']`, `e['W']`, ...); a versão curta do slide «Em Python» devolve o tuplo `(L, Lq, W)`.
- A versão MATLAB está em `code/matlab/06_queueing/06_3_mmr/` e dá a mesma saída.

## Como correr

Em qualquer pasta:

```bash
python ex06_3_mmr.py
```

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
