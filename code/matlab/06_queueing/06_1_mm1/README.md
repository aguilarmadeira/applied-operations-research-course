# 6.1 — Filas de espera: conceitos, lei de Little e M/M/1 (MATLAB/Octave)

- Funções: `Mm1.m`, `SimulaMms.m`
- Exemplo: `ex06_1_mm1.m` (posto de carregamento rápido: rho = 0.75, L = 3, Lq = 2.25, W = 1 h, Wq = 45 min, P_n e Little; o efeito da utilização (Wq de 15 min a 4 h 45); a cauda (95% esperam menos de 2.71 h) e a simulação; Exemplo 1 da aula, controlo de bagagens: 83.3%, 69.4%, 4.17 passageiros, 30 s).
- Tradução da versão Python (`code/python/06_queueing/06_1_mm1/`), com a mesma saída, exceto nos números simulados.

## Como correr

No MATLAB ou no GNU Octave, abrir `ex06_1_mm1.m` e carregar em Run (ou `run('ex06_1_mm1.m')`).
O capítulo inteiro corre com `../ex06_capitulo.m`, que é o ficheiro aberto pelo link do MATLAB Online.

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.

## Simulação

`SimulaMms` usa `rng(seed)` e tempos exponenciais `-log(rand)/taxa` (sem a Statistics Toolbox; o quantil 95% calcula-se como no `numpy.quantile`). O gerador do MATLAB/Octave não é o do numpy, por isso os números simulados **não são os do slide nem os do Python** (slide e Python: 45.5 min, 0.75, 2.72 h; Octave 8.4: 44.5 min, 0.75, 2.66 h; o MATLAB pode dar outros ainda). O exemplo confere-os com as fórmulas com tolerância: 10% em Wq e no quantil 95%, 0.02 em P(esperar). A simulação (200000 carros) demora cerca de 3 s em Octave.
