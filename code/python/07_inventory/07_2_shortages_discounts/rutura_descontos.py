"""Gestão de stocks: rutura planeada e descontos de quantidade (deck 7.2).

rutura(D, Ce, Cp, Cr, Ca=0, TR=None)  -> dict com rho, Q*, S*, rutura máxima, tempos, custos e Pe
descontos(D, Ce, I, escaloes)         -> (uma linha por escalão, a melhor linha)

Rutura planeada (encomendas em atraso, satisfeitas à chegada da encomenda seguinte):
    rho = Cr / (Cp + Cr)  (fração ótima do ciclo com stock positivo, S/Q;
                           nos enunciados das aulas, «nível de serviço»)
    Q* = sqrt(2 D Ce / Cp) / sqrt(rho),  S* = rho Q*,  Pe = D TR - (Q - S)  (pode ser < 0)
Descontos: QEE com o preço de cada escalão, ajustada ao escalão, e custo total com a compra.

Complementos de IO — deck 7.2.  J. F. A. Madeira — Licença MIT.
"""
from math import sqrt


def rutura(D, Ce, Cp, Cr, Ca=0, TR=None):
    """Modelo com rutura planeada.

    D: procura por período; Ce: custo por encomenda; Cp: custo de posse por unidade e período;
    Cr: custo de rutura por unidade em atraso e período; Ca: preço; TR: prazo de entrega.
    Devolve dict com rho, Q, S (stock máximo), R = Q - S (rutura máxima), T, T1 = S/D, T2 = (Q-S)/D,
    n = D/Q, os custos Kenc, Kpos, Krut, Kaq e o total K, e Pe = D TR - (Q - S) (ou None).
    """
    rho = Cr / (Cp + Cr)
    Q = sqrt(2 * D * Ce / (Cp * rho))
    S = Q * rho
    return dict(rho=rho, Q=Q, S=S, R=Q - S, T=Q / D, T1=S / D, T2=(Q - S) / D, n=D / Q,
                Kenc=D * Ce / Q, Kpos=Cp * S * S / (2 * Q), Krut=Cr * (Q - S) ** 2 / (2 * Q), Kaq=D * Ca,
                K=D * Ca + D * Ce / Q + Cp * S * S / (2 * Q) + Cr * (Q - S) ** 2 / (2 * Q),
                Pe=(D * TR - (Q - S) if TR is not None else None))


def descontos(D, Ce, I, escaloes):
    """Descontos de quantidade.

    escaloes: lista [(q_min, q_max, preço)]; I: taxa de posse (Cp = I x preço do escalão).
    Para cada escalão: QEE com esse preço, ajustada a [q_min, q_max], e custo total com a compra.
    Devolve (linhas, melhor), com linhas = [dict(lo, hi, Ca, Q (QEE), Qf (Q usado), K)].
    """
    linhas = []
    for lo, hi, Ca in escaloes:
        Cp = I * Ca
        Q = sqrt(2 * D * Ce / Cp)
        Qf = min(max(Q, lo), hi)
        linhas.append(dict(lo=lo, hi=hi, Ca=Ca, Q=Q, Qf=Qf, K=D * Ca + D * Ce / Qf + Qf / 2 * Cp))
    return linhas, min(linhas, key=lambda l: l['K'])
