"""Matriz de decisão e dominância (deck 1.1).

matriz(f, acoes, estados)  -> matriz C com C[i, j] = f(acoes[i], estados[j])
dominadas(C, custos=False) -> lista de pares (i, k): a ação i é dominada pela ação k

Complementos de IO — deck 1.1.  J. F. A. Madeira — Licença MIT.
"""
import numpy as np


def matriz(f, acoes, estados):
    """Matriz de decisão: linhas = ações, colunas = estados da natureza."""
    return np.array([[f(a, s) for s in estados] for a in acoes], dtype=float)


def dominadas(C, custos=False):
    """Pares (i, k) em que a ação i é dominada pela ação k.

    Com ganhos: c_ij <= c_kj em todos os estados e < em pelo menos um.
    Com custos (custos=True), os sentidos invertem-se.
    """
    C = np.asarray(C, dtype=float)
    G = -C if custos else C                 # trabalhar sempre com "mais é melhor"
    pares = []
    for i in range(len(G)):
        for k in range(len(G)):
            if i != k and np.all(G[i] <= G[k]) and np.any(G[i] < G[k]):
                pares.append((i, k))
    return pares
