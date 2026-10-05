"""Reproduz os exemplos do deck 4.2 (substituição com valor temporal do dinheiro).

Fator de desconto d = 1/(1+r); com r = 10%: d = 0,9091 e 1000 € daqui a 5 anos valem hoje 620,92 €.
Carrinha a gasóleo de 4.1 com r = 10%: W(n) mínimo 10191,0 aos 6 anos (sem desconto eram 5 anos).
Regra: M_6 = 9781,8 < W(5) = 10251,9 (manter), M_7 = 11663,6 > W(6) = 10191,0 (substituir).
Ótimo e taxa (código do slide «Em Python»): 0 5 8760.0 | 0.05 6 9514.6 | 0.1 6 10191.0 | 0.15 6 10846.0.
Para resolver na aula: Exemplo 4 (P = 500, r = 5%): 3 anos, W = 271,61; sem desconto também 3 anos (266,67).

Correr (de qualquer pasta):  python ex04_2_discounting.py

Complementos de IO — deck 4.2.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

import numpy as np

from valor_temporal import custo_equivalente, desconto
from desgaste import custo_medio, custo_mais_um_ano, melhor


def perto(a, b, tol=1e-9):
    """Verdadeiro se todos os valores de a estão a menos de tol dos de b (tolerância absoluta)."""
    return bool(np.max(np.abs(np.asarray(a, float) - np.asarray(b, float))) <= tol)


def fmt(v, f="%.2f"):
    """Valores separados por espaços, todos com o mesmo formato."""
    return " ".join(f % x for x in v)


ok = True
print("Complementos de IO — deck 4.2: com valor temporal do dinheiro")

# ------------------------------------------------------------ fator de desconto
d = 1 / 1.1
print("\nFator de desconto com r = 10%%: d = %.4f; 1000 € daqui a 5 anos valem hoje %.2f €" % (d, 1000 * d ** 5))
ok &= abs(1000 * d ** 5 - 620.92) < 0.005

# ------------------------------------------------------------ carrinha com r = 10%
P = 30000
C = [3000, 3600, 4400, 5400, 6400, 7600, 9800, 12500]
S = [22000, 17000, 13500, 11000, 9000, 7500, 6200, 5000]
W = desconto(P, C, 0.10, S)
print("\nCarrinha a gasóleo com r = 10% (P = 30000)")
print("    n     C_n  d^(n-1)  C_n d^(n-1)  soma C d   S_n d^n  P+soma-S d^n  soma d      W(n)")
for n, c, f, cf, E, num, H, w in W:
    print("  %3d %7d %8.4f %12.1f %9.1f %9.1f %13.1f %7.4f %9.1f" % (n, c, f, cf, E, P + E - num, num, H, w))
b = melhor(W)
print("  substituir ao fim de %d anos: W = %.1f € por ano (sem desconto: 5 anos)" % (b[0], b[7]))
for n in (5, 6):
    M = custo_mais_um_ano(C, S, n, d)
    print("  regra: M_%d = %d + %d - %.4f x %d = %.1f %s W(%d) = %.1f -> %s"
          % (n + 1, C[n], S[n - 1], d, S[n], M, "<" if M < W[n - 1][7] else ">", n, W[n - 1][7],
             "manter" if M < W[n - 1][7] else "substituir"))
ok &= (b[0] == 6 and abs(b[7] - 10191.0) < 0.05
       and perto([r[7] for r in W], [13000, 11640.7, 10881.4, 10454.4, 10251.9, 10191.0, 10346.2, 10679.2], 0.05)
       and perto([P + r[4] - r[5] for r in W], [20000, 14049.6, 10142.7, 7513.1, 5588.3, 4233.6, 3181.6, 2332.5], 0.05)
       and perto([r[6] for r in W], [1, 1.9091, 2.7355, 3.4869, 4.1699, 4.7908, 5.3553, 5.8684], 5e-5)
       and abs(custo_mais_um_ano(C, S, 5, d) - 9781.8) < 0.05 and abs(custo_mais_um_ano(C, S, 6, d) - 11663.6) < 0.05)

# ------------------------------------------------------------ ótimo e taxa (código do slide «Em Python»)
print("\nÓtimo e taxa de desconto (como no slide «Em Python»):")
res = []
for r in (0, 0.05, 0.10, 0.15):
    Wr = custo_equivalente(P, C, S, r)
    n = Wr.index(min(Wr)) + 1
    res.append("%g %d %.1f" % (r, n, min(Wr)))
    ok &= abs(min(Wr) - {0: 8760.0, 0.05: 9514.6, 0.10: 10191.0, 0.15: 10846.0}[r]) < 0.05 and n == (5 if r == 0 else 6)
print("  " + " | ".join(res))

# ------------------------------------------------------------ Para resolver na aula: Exemplo 4
C4 = [0, 100, 200, 300, 400]
W4 = desconto(500, C4, 0.05)
print("\nExemplo 4 (P = 500, r = 5%, sucata 0)")
print("    n  C_n d^(n-1)  soma C d  soma d    W(n)")
for n, c, f, cf, E, num, H, w in W4:
    print("  %3d %11.2f %9.2f %7.4f %7.2f" % (n, cf, E, H, w))
b4 = melhor(W4)
print("  substituir ao fim de %d anos: W = %.2f" % (b4[0], b4[7]))
print("  regra (sem revenda): C_3 = %d <= W(2) = %.2f e C_4 = %d > W(3) = %.2f" % (C4[2], W4[1][7], C4[3], W4[2][7]))
A4 = custo_medio(500, C4)
print("  sem desconto: A(n) = %s -> %d anos" % (fmt(A4), A4.index(min(A4)) + 1))
ok &= (b4[0] == 3 and abs(b4[7] - 271.61) < 0.005
       and perto([r[7] for r in W4], [500, 304.88, 271.61, 278.20, 300.24], 0.005)
       and C4[2] <= W4[1][7] and C4[3] > W4[2][7]
       and A4.index(min(A4)) == 2 and perto(A4, [500, 300, 800 / 3, 275, 300]))

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
