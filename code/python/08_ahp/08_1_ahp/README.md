# 8.1 — O AHP: comparações par a par e consistência (Python)

- Módulo: `ahp.py` — `RI` (índice aleatório de Saaty), `matriz(n, juizos)`, `prioridades(A, metodo='colunas')` (devolve `w, lambda_max, IC, RC`; `metodo='vetor'` usa o vetor próprio, `numpy.linalg.eig`)
- Exemplo: `ex08_1_ahp.py` (pesos das carrinhas pelo método das colunas (0,482; 0,272; 0,158; 0,088; RC = 0,005) e pelo vetor próprio, o juízo incoerente a13 = 1/2 (RC = 0,173) e o par que o denuncia, a assistência, e os Exemplos 1 (frutos) e 2 (emprego) da aula).
- A versão MATLAB está em `code/matlab/08_ahp/08_1_ahp/` e dá a mesma saída.

## Como correr

Só precisa de `numpy`. Em qualquer pasta:

```bash
python ex08_1_ahp.py
```

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto. Os índices começam em 0 (critério 1 → índice 0).
