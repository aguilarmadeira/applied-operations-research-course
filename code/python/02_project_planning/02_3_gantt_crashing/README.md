# 2.3 — Diagrama de Gantt e aceleração de projetos (*crashing*) (Python)

- Módulo: `crashing.py` — `gantt(acts, dur=None)` (diagrama de Gantt em texto), `crash(acts, bonus=0)` (enumeração exata: custo direto mínimo e custo total para cada duração), `crash_pl(acts, bonus, T0=None)` (o mesmo pela programação linear, com `scipy.optimize.linprog`)
- Um projeto com custos é um dicionário `{nome: (precedentes, DN, custo DN, DM, custo DM)}`. Usa o CPM de 2.1 (`pm.py`).
- Exemplo: `ex02_3_gantt_crashing.py` (Gantt do laboratório; custo por semana; aceleração semana a semana com a duração de todos os caminhos; custo total 63, 59, 56, 54, 53, 54 e ótimo em 9 semanas; programação linear com o mesmo ótimo; exercício do exame de 26/07/2019: 18 dias, 3700, *crashing* para 16 dias com custo 4050 e o Gantt do plano final).
- A versão MATLAB está em `code/matlab/02_project_planning/02_3_gantt_crashing/` e dá a mesma saída, menos a linha da programação linear (ver o README de lá).

## Como correr

Precisa de `numpy` e `scipy` (só para `crash_pl`; sem `scipy` o exemplo corre na mesma e avisa). Em qualquer pasta:

```bash
python ex02_3_gantt_crashing.py
```

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.

`crash` testa todas as combinações de durações inteiras entre DM e DN: é exata mas só serve para redes pequenas.
Para redes grandes usa-se a programação linear (`crash_pl`).
