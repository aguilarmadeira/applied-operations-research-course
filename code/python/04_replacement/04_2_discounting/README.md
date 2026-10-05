# 4.2 — Com valor temporal do dinheiro (Python)

- Módulo: `valor_temporal.py` — `custo_equivalente(P, C, S, r)` (a função do slide «Em Python»), `desconto(P, C, r, S=0)` (tabela completa)
- Usa de 4.1 (`04_1_wear/desgaste.py`): `custo_mais_um_ano` (regra com desconto, `d = 1/(1+r)`), `melhor`, `custo_medio`, `revenda`.
- Exemplo: `ex04_2_discounting.py` (fator de desconto; carrinha com r = 10%: substituir ao fim de 6 anos, 10191,0 €/ano, e a regra com desconto; o ótimo para r = 0, 5, 10 e 15%; e o Exemplo 4 da aula); caderno `ex04_2_discounting.ipynb`, também no Colab.
- Convenção das aulas: compra no instante 0, custo do ano i no início do ano (fator `d^(i-1)`), revenda no fim do ano n (fator `d^n`).
- A versão MATLAB está em `code/matlab/04_replacement/04_2_discounting/` e dá a mesma saída.

## Como correr

Só precisa de `numpy`. Em qualquer pasta:

```bash
python ex04_2_discounting.py
```

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
