# 2.2 — Planeamento de projetos: PERT (Python)

- Módulo: `pert.py` — `Phi(z)`, `pert(acts3)` (te, var, duração esperada e caminho crítico), `beta_pert(a, m, b, n, rng)`, `simula_pert(acts3, N, semente)`
- Um projeto PERT é um dicionário `{nome: (precedentes, to, tm, tp)}`. Usa o CPM de 2.1 (`pm.py`).
- Exemplo: `ex02_2_pert.py` (laboratório com três estimativas: 13 semanas, sd 0,745, P(T ≤ 14) = 0,91; caminhos e variâncias; simulação de 200 000 projetos (média 13,2; 41 %, 80 %, 96 %; A–B–F–H o mais longo em 23 %); Exemplo PERT da aula: 17 semanas, P(T ≤ 22) = 0,989).
- O código do slide «No computador: a simulação em Python» corre tal como está (só precisa de `numpy`) e dá os mesmos números que `simula_pert(P, 200_000, 2026)`.
- A versão MATLAB está em `code/matlab/02_project_planning/02_2_pert/`.

## Como correr

Só precisa de `numpy`. Em qualquer pasta:

```bash
python ex02_2_pert.py
```

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.

**Simulação.** A semente é fixa (2026), por isso o Python reproduz exatamente os números do slide.
O MATLAB/Octave usa outro gerador de números aleatórios: os valores da simulação diferem nas casas decimais
e a verificação usa tolerâncias (média ± 0,05; probabilidades ± 0,01; histograma ± 0,01). Com o arredondamento
impresso (média com uma casa, percentagens inteiras) as duas saídas coincidem no Octave 8.4.
