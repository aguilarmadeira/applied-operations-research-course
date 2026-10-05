"""AHP: atributos quantitativos e agregação (deck 8.2).

direto(v)    -> prioridades locais de um atributo em que mais é melhor: v_i / soma(v)
indireto(v)  -> prioridades locais de um atributo em que menos é melhor: (1/v_i) / soma(1/v)
agrega(M, w) -> pontuações finais S = M w (M: alternativas x critérios; w: pesos dos critérios)

Os pesos w e as prioridades dos critérios qualitativos vêm de prioridades (deck 8.1, ahp.py).

Complementos de IO — deck 8.2.  J. F. A. Madeira — Licença MIT.
"""
import numpy as np


def direto(v):
    """Atributo em que mais é melhor (autonomia, carga, rendimento): v_i / soma."""
    v = np.asarray(v, float)
    return v / v.sum()


def indireto(v):
    """Atributo em que menos é melhor (custos, tempos, distâncias): (1/v_i) / soma(1/v)."""
    v = 1 / np.asarray(v, float)
    return v / v.sum()


def agrega(M, w):
    """Soma ponderada S_i = sum_k w_k p_ik.

    M: matriz alternativas x critérios (prioridades locais, cada coluna soma 1); w: pesos dos critérios.
    """
    return np.asarray(M, float) @ np.asarray(w, float)
