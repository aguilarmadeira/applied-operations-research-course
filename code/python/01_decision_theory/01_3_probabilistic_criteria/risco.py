"""Critérios de decisão probabilísticos (deck 1.3).

risco(C, h, custos=False) -> dict com VE, POE, valor com informação perfeita, VEIP e as escolhas

VE_i  = sum_j h_j c_ij  (escolhe-se o maior; com custos, o menor)
POE_i = sum_j h_j r_ij  (escolhe-se o menor), r = arrependimentos (como em Savage)
VE_i + POE_i é igual para todas as ações; VEIP = min POE.

Complementos de IO — deck 1.3.  J. F. A. Madeira — Licença MIT.
"""
import numpy as np

from criterios import arrependimentos


def risco(C, h, custos=False):
    C, h = np.asarray(C, float), np.asarray(h, float)
    if np.any(h < 0) or abs(h.sum() - 1) > 1e-9:
        raise ValueError("as probabilidades têm de ser >= 0 e somar 1")
    ve = C @ h
    poe = arrependimentos(C, custos) @ h
    melhor_col = C.min(axis=0) if custos else C.max(axis=0)
    info = melhor_col @ h                      # valor esperado com informação perfeita
    alvo_ve = ve.min() if custos else ve.max()
    return {"VE": ve, "POE": poe, "info_perfeita": info, "VEIP": poe.min(),
            "soma": ve + poe if not custos else ve - poe,
            "escolha_VE": [i for i in range(len(ve)) if abs(ve[i] - alvo_ve) < 1e-9],
            "escolha_POE": [i for i in range(len(poe)) if abs(poe[i] - poe.min()) < 1e-9]}
