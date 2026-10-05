# 3.4 — Branch and bound (MATLAB/Octave)

- Funções: `LbFs.m`, `BbFs.m`, `Atraso.m`, `BbAtraso.m` (usam `Tempos` de 3.1). Exploração best-first, com os empates resolvidos como no Python (mesma ordem de nós gerados).
- Exemplo: `ex03_4_branch_and_bound.m` (plastificação: nó «3 primeiro» com limite 34, árvore com 10 nós, ótimo 3, 2, 4, 1 com 35 h e o resumo 39 / 39 / 40 / 35; impressora digital: EDD com atraso 9, árvore com 13 nós, ótimo N, M, K, L com atraso 7; tamanho da árvore completa com 8 trabalhos). O TPC não é resolvido.
- Tradução da versão Python (`code/python/03_scheduling/03_4_branch_and_bound/`), com a mesma saída.
- A experiência com 100 problemas aleatórios (slide «Quanto se poupa?») está só em Python (`experiencia_bb.py`): usa o gerador aleatório do Python, que o MATLAB/Octave não reproduz.

## Como correr

No MATLAB ou no GNU Octave, abrir `ex03_4_branch_and_bound.m` e carregar em Run (ou `run('ex03_4_branch_and_bound.m')`).
O capítulo inteiro corre com `../ex03_capitulo.m`, que é o ficheiro aberto pelo link do MATLAB Online.

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
