# 6.2 — Filas de espera: capacidade limitada e vários servidores (Python)

- Módulo: `filas_mms.py` — `mm1k(lam, mu, K)`, `mms(lam, mu, s)`, `custo_caixas(lam, mu, c_serv, c_esp, smax=10, base='Lq')`, `simula_mm1k(lam, mu, K, n=200000, seed=1)`
- Usa `mm1` e `simula_mms` de `06_1_mm1/filas.py`.
- Exemplo: `ex06_2_mmk_mms.py` (M/M/1/K no posto, K = 2..6: com K = 4 desistem 10.4% e quem fica está 32 min; M/M/s com lambda = 6/h: P(esperar) 0.643, 0.237, 0.075, 0.020; fila única (19.3 min) contra filas separadas (45 min); custo 12 s + 20 Lq: 3 carregadores (40.74 €/h), nível de serviço 4 carregadores (+8.16 €/h); `simula_mms(6, 4, 3)`; Exemplo 2 da aula, restaurante com K = 300: Lq = 4/3, P(fila) = 44.4%, W = 18 s, igual ao M/M/1).
- `mms` e `custo_caixas` devolvem mais medidas do que a versão curta do slide «Em Python» (que devolve o tuplo `(Pw, Lq, Wq)`): aqui `mms` devolve um dicionário (`m['Pw']`, `m['Lq']`, `m['Wq']`, ...).
- A versão MATLAB está em `code/matlab/06_queueing/06_2_mmk_mms/` e dá a mesma saída, exceto nos números simulados (ver abaixo).

## Como correr

Só precisa de `numpy`. Em qualquer pasta:

```bash
python ex06_2_mmk_mms.py
```

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.

## Simulação

As simulações conferem-se com as fórmulas com tolerância: 10% em W e Wq, 0.02 nas probabilidades. `simula_mm1k(3, 4, 4)` dá 10.1% de desistências e 32 min (o slide diz 10,2%); `simula_mms(6, 4, 3)` dá Wq = 2.38 min e 23.7% a esperar. O MATLAB/Octave tem outro gerador de números aleatórios, por isso os seus números simulados não são os do Python (em Octave 8.4: 10.2%, 32 min; 2.34 min, 23.6%) — mas ficam dentro da mesma tolerância.
