# 4.3 — Falhas súbitas e substituição de grupo (Python)

- Módulo: `grupo.py` — `falhas(n, Pacum, T=12)` (p_t, vida média e falhas esperadas N_t), `grupo(n, ci, cg, Pacum, T=None)` (individual contra grupo de t em t períodos), `simula(n, Pacum, T=8, runs=4000, seed=1)` (simulação de Monte Carlo dos N_t; é o código do slide «Confirmar com simulação» como função)
- Usa de 4.1 (`04_1_wear/desgaste.py`): `melhor`.
- Exemplo: `ex04_3_group_replacement.py` (800 luminárias: vida média 4,49 semestres, individual 4454,34 €/semestre, grupo de 3 em 3 semestres 2959,5 €/semestre, leitura marginal e sensibilidade a c_g; simulação com 4000 corridas; e o Exemplo 5 da aula); caderno `ex04_3_group_replacement.ipynb`, também no Colab.
- A simulação usa uma semente fixa (`seed=1`) e reproduz exatamente a tabela do slide; o exemplo compara-a com a fórmula com tolerância 1,0 (cerca de 5 erros-padrão).
- A versão MATLAB está em `code/matlab/04_replacement/04_3_group_replacement/` e dá a mesma saída, exceto a coluna da simulação: os números aleatórios do MATLAB/Octave não são os do numpy, por isso os valores simulados diferem um pouco (até 0,3), sempre dentro da tolerância.

## Como correr

Só precisa de `numpy`. Em qualquer pasta:

```bash
python ex04_3_group_replacement.py
```

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
