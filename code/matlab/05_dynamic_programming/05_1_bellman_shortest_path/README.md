# 5.1 — Programação dinâmica: princípio de Bellman e caminho mais curto (MATLAB/Octave)

- Funções: `CaminhoEtapas.m`, `CaminhosOtimos.m`, `TodosCaminhos.m`, `Guloso.m`
- Exemplo: `ex05_1_bellman_shortest_path.m` (transportadora de A a J: regra gulosa (21), recursão para trás nó a nó e percurso ótimo A-B-G-I-J (17), 45 somas a enumerar contra 19 da PD; Exemplos 1–3 da aula (26, 23 e 17)).
- Tradução da versão Python (`code/python/05_dynamic_programming/05_1_bellman_shortest_path/`), com a mesma saída.
  Em vez do dicionário de arcos do Python, a rede é a matriz `C(i,j)` dos custos dos arcos (`Inf` se não há arco); o exemplo constrói-a a partir da lista dos arcos.

## Como correr

No MATLAB ou no GNU Octave, abrir `ex05_1_bellman_shortest_path.m` e carregar em Run (ou `run('ex05_1_bellman_shortest_path.m')`).
O capítulo inteiro corre com `../ex05_capitulo.m`, que é o ficheiro aberto pelo link do MATLAB Online.

A última linha é `confere com os slides: sim`.
