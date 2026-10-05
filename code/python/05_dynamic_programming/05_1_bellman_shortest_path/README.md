# 5.1 — Programação dinâmica: princípio de Bellman e caminho mais curto (Python)

- Módulo: `caminho.py` — `caminho_etapas(arcos, fim)`, `caminhos_otimos(dec, ini, fim)`, `todos_caminhos(arcos, ini, fim)`, `guloso(arcos, ini, fim)`
- Exemplo: `ex05_1_bellman_shortest_path.py` (transportadora de A a J: regra gulosa (21), recursão para trás nó a nó e percurso ótimo A-B-G-I-J (17), 45 somas a enumerar contra 19 da PD; Exemplos 1–3 da aula (26, 23 e 17)); caderno `ex05_1_bellman_shortest_path.ipynb`, também no Colab.
- A versão MATLAB está em `code/matlab/05_dynamic_programming/05_1_bellman_shortest_path/` e dá a mesma saída.

## Como correr

Não precisa de pacotes externos. Em qualquer pasta:

```bash
python ex05_1_bellman_shortest_path.py
```

A última linha é `confere com os slides: sim`. A rede é um dicionário `arcos[nó] = {sucessor: custo}`.
