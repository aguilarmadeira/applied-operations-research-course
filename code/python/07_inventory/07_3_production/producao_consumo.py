"""Gestão de stocks: produção e consumo simultâneos (deck 7.3).

producao(D, P, Ce, Cp, Ca=0, Tprep=None) -> dict com Q*, stock máximo, tempos, custos e ponto de lançamento

Produz-se à taxa P > D: o stock sobe a P - D enquanto se produz e depois desce a D.
    Smax = Q (1 - D/P),  K(Q) = D Ca + (D/Q) Ce + (Smax/2) Cp,
    Q* = sqrt(2 D Ce / Cp) sqrt(P / (P - D)),  Tp = Q/P,  T = Q/D.
Ponto de lançamento da produção: D Tprep (supõe Tprep <= T - Tp).

Complementos de IO — deck 7.3.  J. F. A. Madeira — Licença MIT.
"""
from math import sqrt


def producao(D, P, Ce, Cp, Ca=0, Tprep=None):
    """Modelo de produção e consumo.

    D: procura por período; P: capacidade de produção por período (P > D); Ce: custo de preparação
    de um lote; Cp: custo de posse por unidade e período; Ca: custo de produção unitário;
    Tprep: tempo de preparação do lote (no mesmo período).
    Devolve dict com Q, Smax, T, Tp, n = D/Q, Kenc (preparação), Kpos, K e Pl = D Tprep (ou None).
    """
    Q = sqrt(2 * D * Ce / Cp) * sqrt(P / (P - D))
    Smax = Q * (P - D) / P
    return dict(Q=Q, Smax=Smax, T=Q / D, Tp=Q / P, n=D / Q, Kenc=D * Ce / Q, Kpos=Cp * Smax / 2,
                K=D * Ca + D * Ce / Q + Cp * Smax / 2,
                Pl=(D * Tprep if Tprep is not None else None))
