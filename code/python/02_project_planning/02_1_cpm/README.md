# 2.1 — Planeamento de projetos: CPM (Python)

- Módulo: `pm.py` — `topo(acts)`, `sucessores(acts)`, `cpm(acts, dur=None)` (ES, EF, LS, LF, folga e T), `caminhos(acts)`
- Um projeto é um dicionário `{nome: (precedentes, duração, ...)}`; o PERT (2.2) e o *crashing* (2.3) acrescentam campos e usam este CPM.
- Exemplo: `ex02_1_cpm.py` (laboratório: 13 semanas, caminho crítico A, C, D, F, H, folgas e caminhos; B atrasado 2 semanas dá 14; Exemplo 1 (15 semanas) e Exemplo 2 de Hillier & Lieberman (44 semanas, sem multa nem prémio)).
- A versão MATLAB está em `code/matlab/02_project_planning/02_1_cpm/` e dá a mesma saída.

## Como correr

Não precisa de pacotes. Em qualquer pasta:

```bash
python ex02_1_cpm.py
```

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
