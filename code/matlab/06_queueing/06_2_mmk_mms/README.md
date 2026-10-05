# 6.2 — Filas de espera: capacidade limitada e vários servidores (MATLAB/Octave)

- Funções: `Mm1k.m`, `Mms.m`, `CustoCaixas.m`, `SimulaMm1k.m`; usa `Mm1` e `SimulaMms` de `06_1_mm1/`.
- `Mm1k` devolve `P` com `P(n+1) = P_n`; `CustoCaixas` devolve uma matriz com uma linha `[s Pw Lq L custo]` por número de servidores.
- Exemplo: `ex06_2_mmk_mms.m` (M/M/1/K no posto, K = 2..6: com K = 4 desistem 10.4% e quem fica está 32 min; M/M/s com lambda = 6/h: P(esperar) 0.643, 0.237, 0.075, 0.020; fila única (19.3 min) contra filas separadas (45 min); custo 12 s + 20 Lq: 3 carregadores (40.74 €/h), nível de serviço 4 carregadores (+8.16 €/h); `SimulaMms(6, 4, 3)`; Exemplo 2 da aula, restaurante com K = 300: Lq = 4/3, P(fila) = 44.4%, W = 18 s, igual ao M/M/1).
- Tradução da versão Python (`code/python/06_queueing/06_2_mmk_mms/`), com a mesma saída, exceto nos números simulados.

## Como correr

No MATLAB ou no GNU Octave, abrir `ex06_2_mmk_mms.m` e carregar em Run (ou `run('ex06_2_mmk_mms.m')`).
O capítulo inteiro corre com `../ex06_capitulo.m`, que é o ficheiro aberto pelo link do MATLAB Online.

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.

## Simulação

O gerador do MATLAB/Octave não é o do numpy, por isso os números simulados **não são os do Python** (Python: 10.1% de desistências e 32 min; Wq = 2.38 min e 23.7% a esperar. Octave 8.4: 10.2%, 32 min; 2.34 min, 23.6%; o MATLAB pode dar outros ainda). O exemplo confere-os com as fórmulas com tolerância: 10% em W e Wq, 0.02 nas probabilidades. As duas simulações (200000 clientes cada) demoram alguns segundos em Octave.
