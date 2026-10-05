# 3.1 — Regra de Johnson, 2 máquinas (MATLAB/Octave)

- Funções: `Tempos.m`, `Cmax.m`, `Ocios.m`, `TempoTotal.m`, `Johnson.m`, `ForcaBruta.m` (usadas também em 3.2–3.4). Os tempos vêm numa matriz `P` com uma linha por trabalho e uma coluna por máquina; as sequências são vetores de índices.
- Exemplo: `ex03_1_johnson.m` (gráfica: ordem de chegada 53 h, Johnson D, E, A, F, B, C com 45 h; força bruta nas 720 sequências (mínimo 45, só 2 ótimas, pior 61); Exemplos 1 (61) e 2 (67, os empates não mudam o tempo total) da aula).
- Tradução da versão Python (`code/python/03_scheduling/03_1_johnson/`), com a mesma saída.

## Como correr

No MATLAB ou no GNU Octave, abrir `ex03_1_johnson.m` e carregar em Run (ou `run('ex03_1_johnson.m')`).
O capítulo inteiro corre com `../ex03_capitulo.m`, que é o ficheiro aberto pelo link do MATLAB Online.

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
