# 2.1 — Planeamento de projetos: CPM (MATLAB/Octave)

- Funções: `Topo.m`, `Sucessores.m`, `Cpm.m`, `Caminhos.m`
- Um projeto é um *cell array* com uma linha por atividade, `{nome, {precedentes}, duração, ...}`; os resultados vêm em vetores pela ordem das linhas. O PERT (2.2) e o *crashing* (2.3) acrescentam colunas e usam este CPM.
- Exemplo: `ex02_1_cpm.m` (laboratório: 13 semanas, caminho crítico A, C, D, F, H, folgas e caminhos; B atrasado 2 semanas dá 14; Exemplo 1 (15 semanas) e Exemplo 2 de Hillier & Lieberman (44 semanas, sem multa nem prémio)).
- Tradução da versão Python (`code/python/02_project_planning/02_1_cpm/`), com a mesma saída.

## Como correr

No MATLAB ou no GNU Octave, abrir `ex02_1_cpm.m` e carregar em Run (ou `run('ex02_1_cpm.m')`).
O capítulo inteiro corre com `../ex02_capitulo.m`, que é o ficheiro aberto pelo link do MATLAB Online.

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
