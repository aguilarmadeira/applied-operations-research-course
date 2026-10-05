# 4.1 — Equipamentos que se desgastam (MATLAB/Octave)

- Funções: `CustoMedio.m`, `Media.m`, `Melhor.m`, `CustoMaisUmAno.m`, `QuandoTrocar.m`, `Revenda.m`
- Exemplo: `ex04_1_wear.m` (carrinha a gasóleo: substituir ao fim de 5 anos, 8760 €/ano, e a regra «mais um ano contra a média»; duas máquinas: com a elétrica (8316,67 €/ano), a gasóleo com 3 anos troca-se ao fim do 4.º ano; e os Exemplos 1, 2 e 3 da aula).
- `S` pode ser um vetor (revenda no fim de cada ano) ou um número (sucata igual em todos os anos). `Melhor` e `CustoMaisUmAno` também são usados em 4.2 e 4.3.
- Tradução da versão Python (`code/python/04_replacement/04_1_wear/`), com a mesma saída.

## Como correr

No MATLAB ou no GNU Octave, abrir `ex04_1_wear.m` e carregar em Run (ou `run('ex04_1_wear.m')`).
O capítulo inteiro corre com `../ex04_capitulo.m`, que é o ficheiro aberto pelo link do MATLAB Online.

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
