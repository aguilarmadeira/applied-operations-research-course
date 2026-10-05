# 5.2 — O problema da mochila (MATLAB/Octave)

- Funções: `MochilaIlimitada.m`, `SolucoesIlimitada.m`, `Mochila01.m`, `ForcaBruta01.m`, `RegraRacio.m`
- Exemplo: `ex05_2_knapsack.m` (camião, mochila ilimitada: tabela f(0..10), ótimo B + C (30) contra 26 pelo rácio; projetos, mochila 0–1: tabela f_5..f_1, leitura da solução, P1, P3, P4 (42) contra 35 pelo rácio, confirmado por força bruta; Exemplos 4–6 da aula (62, 19 e 26)).
- Tradução da versão Python (`code/python/05_dynamic_programming/05_2_knapsack/`), com a mesma saída, exceto uma linha: a confirmação pelo `milp` do scipy (slide «Em Python, e a confirmação por programação linear inteira») fica só em Python, porque o MATLAB base não tem programação linear inteira (`intlinprog` é da Optimization Toolbox); aqui a confirmação é a força bruta (`ForcaBruta01`).

## Como correr

No MATLAB ou no GNU Octave, abrir `ex05_2_knapsack.m` e carregar em Run (ou `run('ex05_2_knapsack.m')`).
O capítulo inteiro corre com `../ex05_capitulo.m`, que é o ficheiro aberto pelo link do MATLAB Online.

A última linha é `confere com os slides: sim`.
