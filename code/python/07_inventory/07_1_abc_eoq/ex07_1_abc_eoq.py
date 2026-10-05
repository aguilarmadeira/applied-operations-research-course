"""Reproduz os exemplos do deck 7.1 (classificação ABC e QEE).

Fábrica de tintas, ABC: total 120 300 €/ano; A: P1, P2, P3 (78,8 %); B: P4, P5; C: P6–P10.
Dióxido de titânio (D = 12 000 kg/ano, Ce = 150 €, Cp = 0,2 x 4 = 0,80 €/kg/ano, prazo 2 semanas):
Q* = 2121 kg, 5,66 encomendas/ano, ciclo 9,2 semanas, encomenda + posse 1697,06 €, K = 49 697,06 €,
ponto de encomenda 461,5 kg.
Robustez: Q = 1500, 2000, 2500, 3000 -> 1800, 1700, 1720, 1800 €; com D = 14 400 e Q = 2121:
1866,76 € contra 1859,03 € do ótimo (+0,4 %).
Para resolver na aula: Exemplo 1 (ABC, total 62 498; A: A1, A8, A3; B: A2, A5) e
Exemplo 2 (transístores: Cp = 5,50, Q* = 988, K = 198 094, 4 semanas, Pe = 494, 13 encomendas).

Correr (de qualquer pasta):  python ex07_1_abc_eoq.py

Complementos de IO — deck 7.1.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

from stocks import abc, qee, custo_qee


def mostra_abc(titulo, itens):
    tot, linhas = abc(itens)
    print("\n" + titulo + ": total %.2f" % tot)
    print("  artigo  valor/un.  quantidade      valor      %  acum.  classe")
    for k, v, q, val, p, c, cl in linhas:
        print("  %-6s %10.2f %11.0f %10.2f %6.1f %6.1f  %s" % (k, v, q, val, p, c, cl))
    classes = {c: [l[0] for l in linhas if l[6] == c] for c in "ABC"}
    print("  " + ";  ".join("%s: %s" % (c, ", ".join(classes[c])) for c in "ABC"))
    return tot, linhas, classes


ok = True
print("Complementos de IO — deck 7.1: classificação ABC e quantidade económica de encomenda")

# ------------------------------------------------------------ ABC da fábrica de tintas
tinta = {"P1": (4, 12000), "P2": (3.2, 9000), "P3": (0.9, 20000), "P4": (25, 400), "P5": (1.1, 6000),
         "P6": (12, 300), "P7": (0.15, 18000), "P8": (0.03, 40000), "P9": (0.05, 22000), "P10": (3, 100)}
tot, L, cl = mostra_abc("ABC da fábrica de tintas (€/ano)", tinta)
ok &= (abs(tot - 120300) < 1e-6 and cl["A"] == ["P1", "P2", "P3"] and cl["B"] == ["P4", "P5"]
       and cl["C"] == ["P6", "P7", "P8", "P9", "P10"] and abs(L[2][5] - 78.8) < 0.05
       and abs(L[4][5] - 92.6) < 0.05 and abs(L[5][5] - 95.6) < 0.05)

# ------------------------------------------------------------ QEE do dióxido de titânio
D, Ce, Ca = 12000, 150, 4
Cp = 0.2 * Ca
q = qee(D, Ce, Cp, Ca, TR=2 / 52)
g = q["Kenc"] + q["Kpos"]
print("\nQEE do dióxido de titânio (D = %d kg/ano, Ce = %d €, Cp = %.2f €/kg/ano, prazo 2 semanas)" % (D, Ce, Cp))
print("  Q* = %.2f kg;  encomendas por ano %.2f;  ciclo %.1f semanas" % (q["Q"], q["n"], q["T"] * 52))
print("  encomenda %.2f + posse %.2f = %.2f €;  custo total (com compra) %.2f €" % (q["Kenc"], q["Kpos"], g, q["K"]))
print("  ponto de encomenda %.1f kg" % q["Pe"])
ok &= (abs(q["Q"] - 2121.32) < 0.01 and abs(q["n"] - 5.66) < 0.005 and abs(q["T"] * 52 - 9.2) < 0.05
       and abs(g - 1697.06) < 0.005 and abs(q["K"] - 49697.06) < 0.005 and abs(q["Pe"] - 461.5) < 0.05)

# ------------------------------------------------------------ robustez
print("\nRobustez (encomenda + posse)")
esperado = {1500: 1800, 2000: 1700, 2500: 1720, 3000: 1800}
for Q in (1500, 2000, 2500, 3000):
    gQ = custo_qee(Q, D, Ce, Cp)
    print("  Q = %4d: %.2f €  (+%.2f%%)" % (Q, gQ, 100 * (gQ / g - 1)))
    ok &= abs(gQ - esperado[Q]) < 1e-6
g14 = custo_qee(q["Q"], 14400, Ce, Cp)
q14 = qee(14400, Ce, Cp)
o14 = q14["Kenc"] + q14["Kpos"]
print("  D = 14400 com Q = %.0f: %.2f €;  ótimo (Q = %.0f): %.2f €  (+%.1f%%)"
      % (q["Q"], g14, q14["Q"], o14, 100 * (g14 / o14 - 1)))
ok &= abs(g14 - 1866.76) < 0.005 and abs(o14 - 1859.03) < 0.005 and round(100 * (g14 / o14 - 1), 1) == 0.4

# ------------------------------------------------------------ Exemplo 1 (para resolver na aula)
ex1 = {"A1": (1, 22000), "A2": (12, 410), "A3": (4.25, 1468), "A4": (0.25, 3500), "A5": (2.25, 1600),
       "A6": (26, 10), "A7": (8.5, 124), "A8": (0.5, 40000), "A9": (1.25, 440), "A10": (0.12, 25000)}
tot1, L1, cl1 = mostra_abc("Exemplo 1 (ABC)", ex1)
ok &= (abs(tot1 - 62498) < 1e-6 and cl1["A"] == ["A1", "A8", "A3"] and cl1["B"] == ["A2", "A5"]
       and cl1["C"] == ["A10", "A7", "A4", "A9", "A6"] and abs(L1[5][5] - 95.6) < 0.05)

# ------------------------------------------------------------ Exemplo 2 (para resolver na aula)
Cp2 = 3.25 + 0.15 * 15
q2 = qee(12844, 209, Cp2, 15, TR=2 / 52)
print("\nExemplo 2 (caixa de transístores): Cp = 3.25 + 0.15 x 15 = %.2f" % Cp2)
print("  a) Q* = %.2f;  b) custo anual %.2f (compra %.0f + encomenda %.2f + posse %.2f)"
      % (q2["Q"], q2["K"], 12844 * 15, q2["Kenc"], q2["Kpos"]))
print("  c) ciclo %.2f semanas;  d) ponto de encomenda %.2f;  e) %.2f encomendas por ano"
      % (q2["T"] * 52, q2["Pe"], q2["n"]))
print("  f) posse / encomenda = %.4f" % (q2["Kpos"] / q2["Kenc"]))
ok &= (round(q2["Q"]) == 988 and round(q2["K"]) == 198094 and round(q2["T"] * 52) == 4
       and round(q2["Pe"]) == 494 and round(q2["n"]) == 13 and round(q2["Kenc"]) == 2717
       and abs(q2["Kpos"] / q2["Kenc"] - 1) < 1e-12)

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
