# 6.1 — Filas de espera: conceitos, lei de Little e M/M/1 (Python)

- Módulo: `filas.py` — `mm1(lam, mu)`, `simula_mms(lam, mu, s, n=200000, seed=1, aquecimento=10000)`
- Exemplo: `ex06_1_mm1.py` (posto de carregamento rápido: rho = 0.75, L = 3, Lq = 2.25, W = 1 h, Wq = 45 min, P_n e Little; o efeito da utilização (Wq de 15 min a 4 h 45); a cauda (95% esperam menos de 2.71 h) e a simulação do slide; Exemplo 1 da aula, controlo de bagagens: 83.3%, 69.4%, 4.17 passageiros, 30 s).
- `simula_mms` com `s = 1` é o código do slide «Confirmar com simulação» (mesmo gerador `numpy.random.default_rng(1)` e mesma ordem dos sorteios), por isso dá os números do slide: 45.5 min, 0.75 e 2.72 h. Com `s > 1` é usada em 6.2.
- A versão MATLAB está em `code/matlab/06_queueing/06_1_mm1/` e dá a mesma saída, exceto nos números simulados (ver abaixo).

## Como correr

Só precisa de `numpy`. Em qualquer pasta:

```bash
python ex06_1_mm1.py
```

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.

## Simulação

O exemplo confere a simulação com as fórmulas com tolerância: 10% em Wq e no quantil 95%, 0.02 em P(esperar). O MATLAB/Octave tem outro gerador de números aleatórios, por isso os seus números simulados não são os do Python nem os do slide (em Octave 8.4: 44.5 min, 0.75, 2.66 h) — mas ficam dentro da mesma tolerância.
