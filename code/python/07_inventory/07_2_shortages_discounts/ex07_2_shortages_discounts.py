"""Reproduz os exemplos do deck 7.2 (rutura planeada e descontos de quantidade).

Tinta premium com rutura (D = 1200 latas/ano, Ca = 50 €, Ce = 80 €, Cp = 10 €, Cr = 30 €, prazo 1 semana):
rho = 0,75, Q* = 160, S* = 120, rutura máxima 40, ciclo 1,6 meses (6,9 semanas), 5,2 / 1,7 semanas,
Pe = 23,1 - 40 = -16,9, 7,5 encomendas/ano; encomenda 600 + posse 450 + rutura 150 = 1200 €
contra 1385,64 € sem rutura (poupa 185,64 €, 13 %); custo total 61 200 €.
Descontos no dióxido de titânio: 49 697,06, 48 324, 48 180 € -> encomendar 6000 kg
(poupa 1517 € face à QEE sem desconto; só 144 € abaixo de 3000 kg).
Para resolver na aula: Exemplo 3 (loja AAA -> 400 unidades, 3453,19 €) e
Exemplo 4 (componentes -> 6000, 1 419 975 u.m., 2,5 encomendas/ano, ciclo 0,4 anos).

Correr (de qualquer pasta):  python ex07_2_shortages_discounts.py

Complementos de IO — deck 7.2.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

from rutura_descontos import rutura, descontos
from stocks import qee


def mostra_descontos(titulo, D, Ce, I, escaloes):
    linhas, melhor = descontos(D, Ce, I, escaloes)
    print("\n" + titulo + ": D = %g, Ce = %g, posse %g%% do preço" % (D, Ce, 100 * I))
    print("  escalão        preço      QEE  Q usado         compra  encomenda      posse          total")
    for l in linhas:
        esc = "%g+" % l["lo"] if l["hi"] >= 1e9 else "%g-%g" % (l["lo"], l["hi"])
        Cp = I * l["Ca"]
        print("  %-11s %8.4g %8.1f %8.1f %14.2f %10.2f %10.2f %14.2f"
              % (esc, l["Ca"], l["Q"], l["Qf"], D * l["Ca"], D * Ce / l["Qf"], Cp * l["Qf"] / 2, l["K"]))
    print("  -> encomendar %.0f: custo %.2f;  %.2f encomendas por ano;  ciclo T = Q/D = %.4f"
          % (melhor["Qf"], melhor["K"], D / melhor["Qf"], melhor["Qf"] / D))
    return linhas, melhor


ok = True
print("Complementos de IO — deck 7.2: rutura planeada e descontos de quantidade")

# ------------------------------------------------------------ tinta premium com rutura
r = rutura(1200, 80, 10, 30, 50, TR=1 / 52)
print("\nTinta premium com rutura (D = 1200 latas/ano, Ce = 80, Cp = 10, Cr = 30, Ca = 50, prazo 1 semana)")
print("  rho = %.2f;  Q* = %.2f;  S* = %.2f;  rutura máxima %.2f" % (r["rho"], r["Q"], r["S"], r["R"]))
print("  ciclo %.2f meses (%.2f semanas);  com stock %.2f semanas, em rutura %.2f semanas"
      % (r["T"] * 12, r["T"] * 52, r["T1"] * 52, r["T2"] * 52))
print("  ponto de encomenda %.2f - %.2f = %.2f;  %.2f encomendas por ano"
      % (1200 / 52, r["R"], r["Pe"], r["n"]))
s = qee(1200, 80, 10)
gs = s["Kenc"] + s["Kpos"]
gr = r["Kenc"] + r["Kpos"] + r["Krut"]
print("  €/ano         com rutura  sem rutura")
print("  encomenda     %10.2f  %10.2f" % (r["Kenc"], s["Kenc"]))
print("  posse         %10.2f  %10.2f" % (r["Kpos"], s["Kpos"]))
print("  rutura        %10.2f" % r["Krut"])
print("  soma          %10.2f  %10.2f" % (gr, gs))
print("  poupança %.2f €/ano (%.1f%%);  compra %.0f;  custo total %.2f" % (gs - gr, 100 * (1 - gr / gs), r["Kaq"], r["K"]))
ok &= (abs(r["rho"] - 0.75) < 1e-12 and abs(r["Q"] - 160) < 1e-9 and abs(r["S"] - 120) < 1e-9
       and abs(r["R"] - 40) < 1e-9 and abs(r["T"] * 12 - 1.6) < 1e-9 and round(r["T"] * 52, 1) == 6.9
       and round(r["T1"] * 52, 1) == 5.2 and round(r["T2"] * 52, 1) == 1.7 and round(r["Pe"], 1) == -16.9
       and abs(r["n"] - 7.5) < 1e-9 and abs(r["Kenc"] - 600) < 1e-9 and abs(r["Kpos"] - 450) < 1e-9
       and abs(r["Krut"] - 150) < 1e-9 and abs(gs - 1385.64) < 0.005 and abs(gs - gr - 185.64) < 0.005
       and round(100 * (1 - gr / gs)) == 13 and abs(r["K"] - 61200) < 1e-6)

# ------------------------------------------------------------ descontos no dióxido de titânio
L, b = mostra_descontos("Descontos no dióxido de titânio", 12000, 150, 0.2,
                        [(0, 2999, 4), (3000, 5999, 3.88), (6000, 1e9, 3.8)])
print("  poupa %.2f €/ano face à QEE sem desconto;  %.2f abaixo de 3000 kg" % (L[0]["K"] - b["K"], L[1]["K"] - b["K"]))
ok &= ([round(l["Q"]) for l in L] == [2121, 2154, 2176] and [round(l["Qf"]) for l in L] == [2121, 3000, 6000]
       and abs(L[0]["K"] - 49697.06) < 0.005 and abs(L[1]["K"] - 48324) < 1e-6 and abs(L[2]["K"] - 48180) < 1e-6
       and b["Qf"] == 6000 and round(L[0]["K"] - b["K"]) == 1517 and abs(L[1]["K"] - b["K"] - 144) < 1e-6)

# ------------------------------------------------------------ Exemplo 3 (para resolver na aula)
L3, b3 = mostra_descontos("Exemplo 3, loja AAA (D = 21 x 52 por ano)", 21 * 52, 20, 0.25,
                          [(0, 399, 3.2), (400, 899, 3.2 * 0.93), (900, 1999, 3.2 * 0.9), (2000, 1e9, 3.2 * 0.85)])
print("  ciclo %.1f semanas" % (52 * b3["Qf"] / (21 * 52)))
ok &= ([round(l["K"], 2) for l in L3] == [3681.33, 3453.19, 3493.23, 3661.16] and b3["Qf"] == 400
       and [round(l["Q"], 1) for l in L3] == [233.7, 242.3, 246.3, 253.4]
       and round(21 * 52 / b3["Qf"], 2) == 2.73 and round(52 * b3["Qf"] / (21 * 52), 1) == 19.0)

# ------------------------------------------------------------ Exemplo 4 (para resolver na aula)
L4, b4 = mostra_descontos("Exemplo 4, componentes importados", 15000, 150, 0.2,
                          [(0, 999, 100), (1000, 2999, 95), (3000, 5999, 94), (6000, 8999, 91), (9000, 1e9, 90)])
print("  ciclo %.1f anos = %.1f meses" % (b4["Qf"] / 15000, 12 * b4["Qf"] / 15000))
ok &= ([round(l["K"], 2) for l in L4] == [1509486.83, 1436750, 1438950, 1419975, 1431250] and b4["Qf"] == 6000
       and [round(l["Q"], 1) for l in L4] == [474.3, 486.7, 489.2, 497.2, 500.0]
       and abs(15000 / b4["Qf"] - 2.5) < 1e-12 and abs(b4["Qf"] / 15000 - 0.4) < 1e-12)

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
