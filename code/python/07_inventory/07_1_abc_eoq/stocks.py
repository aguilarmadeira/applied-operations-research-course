"""Gestão de stocks: classificação ABC e quantidade económica de encomenda (deck 7.1).

abc(itens, lim=(80, 95))        -> (total, linhas ordenadas pelo valor anual, com a classe)
qee(D, Ce, Cp, Ca=0, TR=None)   -> dict com Q*, n.º de encomendas, ciclo, custos e ponto de encomenda
custo_qee(Q, D, Ce, Cp, Ca=0)   -> custo K(Q) para um lote Q qualquer

Modelo de Wilson: K(Q) = D Ca + (D/Q) Ce + (Q/2) Cp;  Q* = sqrt(2 D Ce / Cp).
Todas as grandezas na mesma unidade de tempo (D por período, Cp por unidade e por período, TR em períodos).

Complementos de IO — deck 7.1.  J. F. A. Madeira — Licença MIT.
"""
from math import sqrt


def abc(itens, lim=(80, 95)):
    """Classificação ABC pelo valor anual (preço x quantidade).

    itens: dict nome -> (valor unitário, quantidade).
    Classe A até lim[0] % do valor acumulado, B até lim[1] %, C o resto.
    Devolve (total, linhas), com linhas = [(nome, valor unitário, quantidade, valor,
    % do total, % acumulada, classe)] por ordem decrescente de valor.
    """
    tot = sum(v * q for v, q in itens.values())
    cum = 0
    out = []
    for k, (v, q) in sorted(itens.items(), key=lambda x: -x[1][0] * x[1][1]):
        cum += v * q
        c = 100 * cum / tot
        classe = 'A' if c <= lim[0] + 1e-9 else 'B' if c <= lim[1] + 1e-9 else 'C'
        out.append((k, v, q, v * q, 100 * v * q / tot, c, classe))
    return tot, out


def qee(D, Ce, Cp, Ca=0, TR=None):
    """Quantidade económica de encomenda (Wilson).

    D: procura por período; Ce: custo por encomenda; Cp: custo de posse por unidade e período;
    Ca: preço unitário (só entra no custo total); TR: prazo de entrega (no mesmo período).
    Devolve dict com Q, n = D/Q, T = Q/D, Kenc, Kpos, K (com a compra) e Pe = D TR (ou None).
    """
    Q = sqrt(2 * D * Ce / Cp)
    return dict(Q=Q, n=D / Q, T=Q / D, Kenc=D * Ce / Q, Kpos=Cp * Q / 2,
                K=D * Ca + D * Ce / Q + Cp * Q / 2,
                Pe=(D * TR if TR is not None else None))


def custo_qee(Q, D, Ce, Cp, Ca=0):
    """Custo por período K(Q) = D Ca + D Ce / Q + Cp Q / 2 para um lote Q qualquer."""
    return D * Ca + D * Ce / Q + Cp * Q / 2
