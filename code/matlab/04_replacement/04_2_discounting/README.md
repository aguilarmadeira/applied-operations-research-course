# 4.2 — Com valor temporal do dinheiro (MATLAB/Octave)

- Funções: `CustoEquivalente.m`, `Desconto.m`
- Usa de 4.1 (`04_1_wear/`): `CustoMaisUmAno` (regra com desconto, `d = 1/(1+r)`), `Melhor`, `CustoMedio`, `Revenda`.
- Exemplo: `ex04_2_discounting.m` (fator de desconto; carrinha com r = 10%: substituir ao fim de 6 anos, 10191,0 €/ano, e a regra com desconto; o ótimo para r = 0, 5, 10 e 15%; e o Exemplo 4 da aula).
- Tradução da versão Python (`code/python/04_replacement/04_2_discounting/`), com a mesma saída.

## Como correr

No MATLAB ou no GNU Octave, abrir `ex04_2_discounting.m` e carregar em Run (ou `run('ex04_2_discounting.m')`).
O capítulo inteiro corre com `../ex04_capitulo.m`, que é o ficheiro aberto pelo link do MATLAB Online.

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
