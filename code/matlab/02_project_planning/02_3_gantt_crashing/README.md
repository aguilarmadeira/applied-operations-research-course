# 2.3 — Diagrama de Gantt e aceleração de projetos (*crashing*) (MATLAB/Octave)

- Funções: `Gantt.m` (diagrama de Gantt em texto), `Crash.m` (enumeração exata: custo direto mínimo e custo total para cada duração)
- Um projeto com custos é um *cell array* `{nome, {precedentes}, DN, custo DN, DM, custo DM}`. Usa o CPM de 2.1 (`Cpm.m`).
- Exemplo: `ex02_3_gantt_crashing.m` (Gantt do laboratório; custo por semana; aceleração semana a semana com a duração de todos os caminhos; custo total 63, 59, 56, 54, 53, 54 e ótimo em 9 semanas; exercício do exame de 26/07/2019: 18 dias, 3700, *crashing* para 16 dias com custo 4050 e o Gantt do plano final).
- Tradução da versão Python (`code/python/02_project_planning/02_3_gantt_crashing/`), com a mesma saída menos uma linha.

**Programação linear: só em Python.** O slide «Complemento» resolve o *crashing* como programação linear;
em Python isso faz-se com `scipy.optimize.linprog` (`crash_pl`). O MATLAB base não tem `linprog` (é da
Optimization Toolbox), por isso aqui não há `CrashPl`: a linha correspondente da saída diz isso e o ótimo
(T = 9, custo 53) confere-se com a enumeração exata de `Crash.m`, que testa todas as combinações de durações.

## Como correr

No MATLAB ou no GNU Octave, abrir `ex02_3_gantt_crashing.m` e carregar em Run (ou `run('ex02_3_gantt_crashing.m')`).
O capítulo inteiro corre com `../ex02_capitulo.m`, que é o ficheiro aberto pelo link do MATLAB Online.

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
