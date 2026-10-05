# 5.2 — O problema da mochila (Python)

- Módulo: `mochila.py` — `mochila_ilimitada(w, v, W)`, `solucoes_ilimitada(w, v, W)`, `mochila_01(w, v, W, tabela=False)`, `forca_bruta_01(w, v, W)`, `regra_racio(w, v, W, ilimitada=True)`
- Exemplo: `ex05_2_knapsack.py` (camião, mochila ilimitada: tabela f(0..10), ótimo B + C (30) contra 26 pelo rácio; projetos, mochila 0–1: tabela f_5..f_1, leitura da solução, P1, P3, P4 (42) contra 35 pelo rácio, confirmado por força bruta e pelo `milp` do scipy; Exemplos 4–6 da aula (62, 19 e 26)); caderno `ex05_2_knapsack.ipynb`, também no Colab.
- `mochila_01(w, v, W)` devolve `(valor, x)`, como no slide «Em Python»; com `tabela=True` devolve também a tabela `F`.
- A versão MATLAB está em `code/matlab/05_dynamic_programming/05_2_knapsack/` e dá a mesma saída, exceto a linha do `milp` (no MATLAB a confirmação é a força bruta).

## Como correr

Só precisa de `numpy`; a confirmação por programação linear inteira usa `scipy` (se não estiver instalado, o exemplo diz-o e fica a força bruta). Em qualquer pasta:

```bash
python ex05_2_knapsack.py
```

A última linha é `confere com os slides: sim`.
