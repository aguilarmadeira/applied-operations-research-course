# 3.1 — Regra de Johnson, 2 máquinas (Python)

- Módulo: `sequenciamento.py` — `tempos(seq, P)`, `cmax(seq, P)`, `ocios(seq, P)`, `tempo_total(seq, a, b)`, `johnson(a, b)`, `forca_bruta(P, f=None)` (usados também em 3.2–3.4)
- Exemplo: `ex03_1_johnson.py` (gráfica: ordem de chegada 53 h, Johnson D, E, A, F, B, C com 45 h; força bruta nas 720 sequências (mínimo 45, só 2 ótimas, pior 61); Exemplos 1 (61) e 2 (67, os empates não mudam o tempo total) da aula); caderno `ex03_1_johnson.ipynb`, também no Colab.
- O código do slide «Em Python» corre com este módulo: `from sequenciamento import johnson, tempo_total`.
- A versão MATLAB está em `code/matlab/03_scheduling/03_1_johnson/` e dá a mesma saída.

## Como correr

Não precisa de pacotes externos. Em qualquer pasta:

```bash
python ex03_1_johnson.py
```

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
