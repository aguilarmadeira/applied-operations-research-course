# 3.4 — Branch and bound (Python)

- Módulo: `bb_sequenciamento.py` — `lb_fs(seq, P)`, `bb_fs(P)` (flow shop, tempo total, limite de Ignall e Schrage), `atraso(seq, p, d)`, `bb_atraso(p, d)` (uma máquina, atraso total, fixando do fim); usa `tempos` de 3.1. Exploração best-first; devolvem a melhor sequência e a lista dos nós gerados com os limites.
- Exemplo: `ex03_4_branch_and_bound.py` (plastificação: nó «3 primeiro» com limite 34, árvore com 10 nós, ótimo 3, 2, 4, 1 com 35 h e o resumo 39 / 39 / 40 / 35; impressora digital: EDD com atraso 9, árvore com 13 nós, ótimo N, M, K, L com atraso 7; tamanho da árvore completa com 8 trabalhos); caderno `ex03_4_branch_and_bound.ipynb`, também no Colab. O TPC não é resolvido.
- Só em Python: `experiencia_bb.py` reproduz o slide «Quanto se poupa?» (100 problemas aleatórios com 8 trabalhos: medianas 43 e 123 nós). Usa o gerador `random` do Python com semente fixa, que o MATLAB/Octave não reproduz.
- A versão MATLAB está em `code/matlab/03_scheduling/03_4_branch_and_bound/` e dá a mesma saída (exceto a experiência aleatória).

## Como correr

Não precisa de pacotes externos. Em qualquer pasta:

```bash
python ex03_4_branch_and_bound.py
python experiencia_bb.py
```

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
