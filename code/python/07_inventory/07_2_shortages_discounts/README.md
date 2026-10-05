# 7.2 — Rutura planeada e descontos de quantidade (Python)

- Módulo: `rutura_descontos.py` — `rutura(D, Ce, Cp, Cr, Ca, TR)`, `descontos(D, Ce, I, escaloes)`; usa `qee` de 7.1 (`07_1_abc_eoq/stocks.py`) para a comparação sem rutura.
- Exemplo: `ex07_2_shortages_discounts.py` (tinta premium com rutura (160 latas, ponto de encomenda -16,9, 1200 contra 1385,64 €), descontos no dióxido de titânio (6000 kg, 48 180 €), e os Exemplos 3 (loja AAA, 400 unidades) e 4 (componentes, 6000) da aula).
- A versão MATLAB está em `code/matlab/07_inventory/07_2_shortages_discounts/` e dá a mesma saída.

## Como correr

Só precisa da biblioteca padrão do Python. Em qualquer pasta:

```bash
python ex07_2_shortages_discounts.py
```

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
