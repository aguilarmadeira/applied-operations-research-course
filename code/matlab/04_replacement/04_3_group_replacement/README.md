# 4.3 — Falhas súbitas e substituição de grupo (MATLAB/Octave)

- Funções: `Falhas.m`, `Grupo.m`, `Simula.m`
- Usa de 4.1 (`04_1_wear/`): `Melhor`.
- Exemplo: `ex04_3_group_replacement.m` (800 luminárias: vida média 4,49 semestres, individual 4454,34 €/semestre, grupo de 3 em 3 semestres 2959,5 €/semestre, leitura marginal e sensibilidade a c_g; simulação com 4000 corridas; e o Exemplo 5 da aula).
- Tradução da versão Python (`code/python/04_replacement/04_3_group_replacement/`), com a mesma saída, **exceto a coluna da simulação**: `Simula` usa uma semente fixa (`rng(1)`), mas os números aleatórios do MATLAB/Octave não são os do numpy, por isso os valores simulados diferem um pouco dos da versão Python e do slide (até 0,3 em Octave 8.4; no MATLAB os valores voltam a ser outros). O exemplo compara a simulação com a fórmula com tolerância 1,0 (cerca de 5 erros-padrão), tal como a versão Python.

## Como correr

No MATLAB ou no GNU Octave, abrir `ex04_3_group_replacement.m` e carregar em Run (ou `run('ex04_3_group_replacement.m')`).
O capítulo inteiro corre com `../ex04_capitulo.m`, que é o ficheiro aberto pelo link do MATLAB Online.

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
