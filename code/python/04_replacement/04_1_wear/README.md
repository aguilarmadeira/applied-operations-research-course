# 4.1 — Equipamentos que se desgastam (Python)

- Módulo: `desgaste.py` — `custo_medio(P, C, S)` (a função do slide «Em Python»), `media(P, C, S=0)` (tabela completa), `melhor(L, k=-1)`, `custo_mais_um_ano(C, S, n, d=1.0)`, `quando_trocar(C, S, idade, minimo, d=1.0)`, `revenda(S, n)`
- Exemplo: `ex04_1_wear.py` (carrinha a gasóleo: substituir ao fim de 5 anos, 8760 €/ano, e a regra «mais um ano contra a média»; duas máquinas: com a elétrica (8316,67 €/ano), a gasóleo com 3 anos troca-se ao fim do 4.º ano; e os Exemplos 1, 2 e 3 da aula); caderno `ex04_1_wear.ipynb`, também no Colab.
- `S` pode ser uma lista (revenda no fim de cada ano) ou um número (sucata igual em todos os anos). `melhor` e `custo_mais_um_ano` também são usados em 4.2 e 4.3.
- A versão MATLAB está em `code/matlab/04_replacement/04_1_wear/` e dá a mesma saída.

## Como correr

Só precisa de `numpy`. Em qualquer pasta:

```bash
python ex04_1_wear.py
```

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
