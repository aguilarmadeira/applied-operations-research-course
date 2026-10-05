"""Substituição com valor temporal do dinheiro: custo anual equivalente descontado (deck 4.2).

custo_equivalente(P, C, S, r)  -> lista W com W[n-1] = W(n)
desconto(P, C, r, S=0)         -> tabela: uma linha
                                  (n, C_n, d^(n-1), C_n d^(n-1), soma C_i d^(i-1), P + soma - S_n d^n, soma d^(i-1), W(n))

Convenção das aulas: d = 1/(1+r); a compra P paga-se no instante 0; o custo C_i do ano i paga-se no
início desse ano (fator d^(i-1)); a revenda S_n recebe-se no fim do ano n (fator d^n).
    W(n) = (P + soma_{i<=n} C_i d^(i-1) - S_n d^n) / soma_{i<=n} d^(i-1);  com r = 0, W(n) = A(n) de 4.1.
S é uma lista por ano ou um valor de sucata fixo (como em 4.1).
A regra «mais um ano» com desconto é custo_mais_um_ano(C, S, n, d) (deck 4.1).

Complementos de IO — deck 4.2.  J. F. A. Madeira — Licença MIT.
"""
from desgaste import revenda


def custo_equivalente(P, C, S, r):
    """Custo anual equivalente descontado W(n), para n = 1, ..., len(C), com taxa de desconto r.

    Devolve uma lista (W[n-1] = W(n)); é a função do slide «Em Python».
    """
    d = 1 / (1 + r)
    W, soma_c, soma_d = [], 0, 0
    for n, c in enumerate(C, start=1):
        soma_c += c * d ** (n - 1)            # pago no início do ano n
        soma_d += d ** (n - 1)
        W.append((P + soma_c - revenda(S, n) * d ** n) / soma_d)
    return W


def desconto(P, C, r, S=0):
    """Tabela do custo anual equivalente descontado, uma linha por ano:
    (n, C_n, d^(n-1), C_n d^(n-1), soma C_i d^(i-1), P + soma - S_n d^n, soma d^(i-1), W(n))."""
    d = 1 / (1 + r)
    L, E, H = [], 0, 0
    for n, c in enumerate(C, start=1):
        f = d ** (n - 1)
        E += c * f
        H += f
        num = P + E - revenda(S, n) * d ** n
        L.append((n, c, f, c * f, E, num, H, num / H))
    return L
