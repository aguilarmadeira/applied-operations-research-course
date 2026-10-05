"""Reproduz os exemplos do deck 7.3 (produção e consumo simultâneos).

Tinta de interior (D = 24 000 L/ano, P = 60 000 L/ano, Ce = 900 €, custo 2 €/L, Cp = 0,25 x 2 = 0,50 €/L/ano):
Q* = 9295 x sqrt(60/36) = 12 000 L, stock máximo 7200 L, 2,4 meses a produzir, ciclo 6 meses, 2 lotes/ano,
preparação + posse = 1800 + 1800 = 3600 €, custo total 51 600 €.
Comparação: lote de uma vez (QEE) 9295 L e 4648 €/ano; o lote ótimo aumenta 29 %; linha ocupada 40 %.
Para resolver na aula (ano de 300 dias, preparação de 5 dias):
Exemplo 5 (resina): Q* = 1400 t, Smax = 350 t, T = 28 dias, Tp = 21 dias, lançamento a 250 t, K = 302 100 000;
Exemplo 6: Q* = 3487,1 t, Smax = 697,4 t, T = 52,3 dias, Tp = 41,85 dias, lançamento a 333,3 t, K = 100 871 779,8.

Correr (de qualquer pasta):  python ex07_3_production.py

Complementos de IO — deck 7.3.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

from math import sqrt

from producao_consumo import producao
from stocks import qee

ok = True
print("Complementos de IO — deck 7.3: produção e consumo simultâneos")

# ------------------------------------------------------------ tinta de interior
D, P, Ce, Ca = 24000, 60000, 900, 2
Cp = 0.25 * Ca
p = producao(D, P, Ce, Cp, Ca)
qs = qee(D, Ce, Cp)
gs = qs["Kenc"] + qs["Kpos"]
print("\nTinta de interior (D = %d L/ano, P = %d L/ano, Ce = %d, Cp = %.2f)" % (D, P, Ce, Cp))
print("  Q* = %.2f x %.4f = %.2f L;  stock máximo %.2f L" % (qs["Q"], sqrt(P / (P - D)), p["Q"], p["Smax"]))
print("  tempo a produzir %.2f meses;  ciclo %.2f meses;  %.2f lotes por ano" % (p["Tp"] * 12, p["T"] * 12, p["n"]))
print("  preparação %.2f + posse %.2f = %.2f €;  custo total (com produção) %.2f €"
      % (p["Kenc"], p["Kpos"], p["Kenc"] + p["Kpos"], p["K"]))
print("  lote de uma vez (QEE): Q = %.2f L, custo de gestão %.2f €;  lote ótimo +%.1f%%;  linha ocupada %.0f%%"
      % (qs["Q"], gs, 100 * (p["Q"] / qs["Q"] - 1), 100 * D / P))
ok &= (round(qs["Q"]) == 9295 and abs(p["Q"] - 12000) < 1e-6 and abs(p["Smax"] - 7200) < 1e-6
       and abs(p["Tp"] * 12 - 2.4) < 1e-9 and abs(p["T"] * 12 - 6) < 1e-9 and abs(p["n"] - 2) < 1e-9
       and abs(p["Kenc"] - 1800) < 1e-6 and abs(p["Kpos"] - 1800) < 1e-6 and abs(p["K"] - 51600) < 1e-6
       and round(gs) == 4648 and round(100 * (p["Q"] / qs["Q"] - 1)) == 29 and round(sqrt(60 / 36), 2) == 1.29)

# ------------------------------------------------------------ Exemplos 5 e 6 (para resolver na aula)
res = {}
for nome, P_, D_, Ce_, Ca_, I in (("Exemplo 5 (resina)", 20000, 15000, 98000, 20000, 0.3),
                                  ("Exemplo 6", 25000, 20000, 76000, 5000, 0.25)):
    Cp_ = I * Ca_
    r = producao(D_, P_, Ce_, Cp_, Ca_, Tprep=5 / 300)
    res[nome] = r
    print("\n%s: D = %d t/ano, P = %d t/ano, Ce = %d, Cp = %g x %d = %g (ano de 300 dias)"
          % (nome, D_, P_, Ce_, I, Ca_, Cp_))
    print("  Q* = %.2f x %.4f = %.2f t;  stock máximo %.2f t"
          % (sqrt(2 * D_ * Ce_ / Cp_), sqrt(P_ / (P_ - D_)), r["Q"], r["Smax"]))
    print("  ciclo %.2f dias;  a produzir %.2f dias;  sem produção %.2f dias;  %.2f lotes por ano"
          % (r["T"] * 300, r["Tp"] * 300, (r["T"] - r["Tp"]) * 300, r["n"]))
    print("  ponto de lançamento da produção %.2f t (preparação de 5 dias)" % r["Pl"])
    print("  produção %.2f + preparação %.2f + posse %.2f = %.2f por ano"
          % (D_ * Ca_, r["Kenc"], r["Kpos"], r["K"]))
r5, r6 = res["Exemplo 5 (resina)"], res["Exemplo 6"]
ok &= (abs(r5["Q"] - 1400) < 1e-6 and abs(r5["Smax"] - 350) < 1e-6 and abs(r5["T"] * 300 - 28) < 1e-9
       and abs(r5["Tp"] * 300 - 21) < 1e-9 and abs(r5["Pl"] - 250) < 1e-9 and abs(r5["K"] - 302100000) < 1e-3
       and round(r5["n"], 1) == 10.7)
ok &= (round(r6["Q"], 1) == 3487.1 and round(r6["Smax"], 1) == 697.4 and round(r6["T"] * 300, 1) == 52.3
       and abs(r6["Tp"] * 300 - 41.85) < 0.005 and round(r6["Pl"], 1) == 333.3 and round(r6["K"], 1) == 100871779.8
       and round(r6["n"], 1) == 5.7 and round((r6["T"] - r6["Tp"]) * 300, 1) == 10.5)

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
