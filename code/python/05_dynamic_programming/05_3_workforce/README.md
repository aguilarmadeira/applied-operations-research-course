# 5.3 — Gestão da mão-de-obra (Python)

- Módulo: `mao_de_obra.py` — `mao_obra(b, ce, cf, cv, x0=0, tabelas=False)`, `mao_obra_bruta(b, ce, cf, cv, x0=0)`, `custo_plano(b, ce, cf, cv, xs, x0=0)`
- Exemplo: `ex05_3_workforce.py` (montagem de feiras e congressos: as duas políticas simples (4050 e 6450), as tabelas da semana 5 para a 1, plano ótimo 3, 9, 9, 6, 6 (3450), confirmado nos 336 planos, e a sensibilidade ao custo fixo; Exemplos 7 e 8 da aula (3300 e 2400)); caderno `ex05_3_workforce.ipynb`, também no Colab.
- `mao_obra(b, ce, cf, cv)` devolve `(custo, plano)`, como no slide «Em Python»; com `tabelas=True` devolve também as tabelas `f` e `dec`.
- A versão MATLAB está em `code/matlab/05_dynamic_programming/05_3_workforce/` e dá a mesma saída.

## Como correr

Só precisa de `numpy`. Em qualquer pasta:

```bash
python ex05_3_workforce.py
```

A última linha é `confere com os slides: sim`.
