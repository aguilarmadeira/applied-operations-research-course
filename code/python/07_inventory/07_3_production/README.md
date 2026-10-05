# 7.3 — Produção e consumo simultâneos (Python)

- Módulo: `producao_consumo.py` — `producao(D, P, Ce, Cp, Ca, Tprep)`; usa `qee` de 7.1 (`07_1_abc_eoq/stocks.py`) para a comparação com o lote entregue de uma vez.
- Exemplo: `ex07_3_production.py` (tinta de interior (12 000 L, stock máximo 7200 L, 51 600 €) e os Exemplos 5 (resina, 1400 t) e 6 (3487,1 t) da aula, com o ponto de lançamento da produção).
- A versão MATLAB está em `code/matlab/07_inventory/07_3_production/` e dá a mesma saída.

## Como correr

Só precisa da biblioteca padrão do Python. Em qualquer pasta:

```bash
python ex07_3_production.py
```

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
