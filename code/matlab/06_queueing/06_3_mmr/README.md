# 6.3 — Filas de espera: população finita, M/M/R (MATLAB/Octave)

- Função: `MmR.m` (devolve `P` com `P(n+1) = P_n`)
- Exemplo: `ex06_3_mmr.m` (10 empilhadores, 1 a 3 técnicos: L = 2.97, 1.35, 1.14 parados, custo 893, 636, 736 €/dia, logo dois técnicos; o erro do modelo de população infinita (rho = 1.25); Exemplo 3 da aula, a lavandaria: 1.71 máquinas paradas com 3 mecânicos contra 1.16 com o super-mecânico, logo trocar).
- Tradução da versão Python (`code/python/06_queueing/06_3_mmr/`), com a mesma saída.

## Como correr

No MATLAB ou no GNU Octave, abrir `ex06_3_mmr.m` e carregar em Run (ou `run('ex06_3_mmr.m')`).
O capítulo inteiro corre com `../ex06_capitulo.m`, que é o ficheiro aberto pelo link do MATLAB Online.

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
