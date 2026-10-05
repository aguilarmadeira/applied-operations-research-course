# 3.2 — Três ou mais máquinas (Python)

- Módulo: `m_maquinas.py` — `reduz(P)` (máquinas fictícias G e H), `condicao(P)` (condição de Johnson), `johnson_m(P)` (Johnson com m máquinas); usa `johnson` de 3.1
- Exemplo: `ex03_2_m_machines.py` (gráfica com corte: condição verificada, D, E, A, F, B, C com 47 h, ordem de chegada 55 h; plastificação: a condição falha, Johnson dá 39 h e o ótimo 3, 2, 4, 1 dá 35 h; Exemplos 3 (51), 4 (52) e 5 (cinco máquinas, 51) da aula); caderno `ex03_2_m_machines.ipynb`, também no Colab.
- A experiência do slide «E agora?» (500 problemas aleatórios: Johnson ótimo em 49%, 3% acima em média, 21% no pior caso) está em `../03_3_tdm/experiencia_aleatoria.py`, só em Python.
- A versão MATLAB está em `code/matlab/03_scheduling/03_2_m_machines/` e dá a mesma saída.

## Como correr

Só precisa de `numpy` (para imprimir vetores como o `mat2str` do MATLAB). Em qualquer pasta:

```bash
python ex03_2_m_machines.py
```

A última linha é `confere com os slides: sim`. Os slides usam vírgula decimal; o código usa o ponto.
