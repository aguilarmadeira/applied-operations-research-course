"""Probabilidades subjetivas pelo método direto (deck 1.4).

prob_razoes(m, razoes) -> (P, verificacao)

razoes: lista de (i, k, r) com o significado P(theta_i) / P(theta_k) = r (índices a partir de 0).
As primeiras m - 1 razões, mais a condição sum P = 1, determinam P (têm de ligar os m estados).
As razões a mais servem para verificar a coerência: verificacao é uma lista de
(i, k, r dada, r implícita, coerente?) para essas razões.

Complementos de IO — deck 1.4.  J. F. A. Madeira — Licença MIT.
"""
import numpy as np


def prob_razoes(m, razoes):
    if len(razoes) < m - 1:
        raise ValueError("são precisas pelo menos m - 1 razões")
    A = np.zeros((m, m)); y = np.zeros(m)
    for linha, (i, k, r) in enumerate(razoes[:m - 1]):
        A[linha, i], A[linha, k] = 1.0, -r          # P_i - r P_k = 0
    A[m - 1, :], y[m - 1] = 1.0, 1.0                 # sum P = 1
    P = np.linalg.solve(A, y)
    verificacao = [(i, k, r, P[i] / P[k], abs(P[i] / P[k] - r) < 1e-9 * max(1, r))
                   for i, k, r in razoes[m - 1:]]
    return P, verificacao
