# 2.2 — Planeamento de projetos: PERT (MATLAB/Octave)

- Funções: `Phi.m`, `Pert.m`, `BetaPert.m`, `SimulaPert.m` e `GamaAleatoria.m` (só nesta versão)
- Um projeto PERT é um *cell array* `{nome, {precedentes}, to, tm, tp}`. Usa o CPM de 2.1 (`Cpm.m`).
- Exemplo: `ex02_2_pert.m` (laboratório com três estimativas: 13 semanas, sd 0,745, P(T ≤ 14) = 0,91; caminhos e variâncias; simulação de 200 000 projetos; Exemplo PERT da aula: 17 semanas, P(T ≤ 22) = 0,989).
- Tradução da versão Python (`code/python/02_project_planning/02_2_pert/`).

## Como correr

No MATLAB ou no GNU Octave, abrir `ex02_2_pert.m` e carregar em Run (ou `run('ex02_2_pert.m')`).
O capítulo inteiro corre com `../ex02_capitulo.m`, que é o ficheiro aberto pelo link do MATLAB Online.

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.

**Simulação.** Não usa a Statistics Toolbox: a Beta sorteia-se como G1/(G1 + G2), com G1 e G2 Gama
(`GamaAleatoria.m`, método de Marsaglia e Tsang, só com `rand` e `randn`). A semente é fixa (`rng(2026)`),
mas o gerador não é o do numpy, por isso os números da simulação **não são os mesmos do Python nem do slide**:
diferem nas casas decimais (no Octave 8.4: média 13,246; P(T ≤ 13, 14, 15) = 0,413, 0,801, 0,958; A–B–F–H em 22,9 %;
no Python: 13,245; 0,414, 0,801, 0,958; 22,8 %). A verificação usa tolerâncias (média ± 0,05; probabilidades ± 0,01;
histograma ± 0,01). Com o arredondamento impresso (média com uma casa, percentagens inteiras) a saída coincide
com a do Python no Octave 8.4; no MATLAB pode, raramente, mudar o último algarismo.
