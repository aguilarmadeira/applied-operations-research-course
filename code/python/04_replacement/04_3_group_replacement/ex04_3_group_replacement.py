"""Reproduz os exemplos do deck 4.3 (falhas súbitas e substituição de grupo).

Exemplo-guia: 800 luminárias, c_i = 25 €, c_g = 6 € por luminária, P(t) = 0,03 0,08 0,20 0,45 0,75 1 (semestres).
Vida média 4,49 semestres; individual: 800/4,49 = 178,2 falhas e K_ind = 4454,34 € por semestre.
N_t = 24; 40,72; 98,42; 207,87; 262,04; 247,45; 88,29; ...; grupo de 3 em 3 semestres: K(3) = 2959,5 €
(poupança de 1494,8 € por semestre, -34%). Leitura marginal: 25 N_4 = 5197 > K(3), 25 N_3 = 2461 < K(2).
Sensibilidade: c_g = 10, K(3) = 4026 (grupo); c_g = 12, K(3) = 4560 > 4454 (individual).
Simulação de Monte Carlo (4000 corridas, semente 1) dos N_t, comparada com a fórmula com tolerância 1,0.
Para resolver na aula: Exemplo 5 (1000 lâmpadas, c_i = 3, c_g = 1): vida 3,45 semanas, K_ind = 869,57,
grupo de 4 em 4 semanas, K(4) = 863,57 (compensa, por pouco).

Correr (de qualquer pasta):  python ex04_3_group_replacement.py

Complementos de IO — deck 4.3.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

import numpy as np

from grupo import falhas, grupo, simula
from desgaste import melhor


def perto(a, b, tol=1e-9):
    """Verdadeiro se todos os valores de a estão a menos de tol dos de b (tolerância absoluta)."""
    return bool(np.max(np.abs(np.asarray(a, float) - np.asarray(b, float))) <= tol)


def fmt(v, f="%.2f"):
    """Valores separados por espaços, todos com o mesmo formato."""
    return " ".join(f % x for x in v)


ok = True
print("Complementos de IO — deck 4.3: falhas súbitas e substituição de grupo")

# ------------------------------------------------------------ luminárias
Pac = [0.03, 0.08, 0.20, 0.45, 0.75, 1.0]
n, ci, cg = 800, 25, 6
p, vida, ind, G = grupo(n, ci, cg, Pac)
_, _, N = falhas(n, Pac)                       # N_1, ..., N_12
print("\nLuminárias (n = 800, c_i = 25 €, c_g = 6 € por luminária; períodos de um semestre)")
print("  p_t: %s" % fmt(p))
print("  vida média: %.2f semestres" % vida)
print("  individual: n/vida = %.1f falhas por semestre; K_ind = %.2f € por semestre" % (n / vida, ind))
print("  N_t (t = 1, ..., 12): %s" % fmt(N))
print("  política de grupo de t em t semestres:")
print("     t     N_t   soma N  25 soma N    total     K(t)")
for t, Nt, soma, cs, ncg, tot, K in G:
    print("  %4d %7.2f %8.2f %10.1f %8.1f %8.1f" % (t, Nt, soma, cs, tot, K))
b = melhor(G)
print("  melhor: grupo de %d em %d semestres, K = %.1f € por semestre, contra %.1f da individual" % (b[0], b[0], b[6], ind))
print("  poupança: %.1f € por semestre (%.0f%%), %.1f € por ano"
      % (ind - b[6], 100 * (b[6] / ind - 1), 2 * (ind - b[6])))
print("  leitura marginal: 25 x N_3 = %.1f < K(2) = %.1f; 25 x N_4 = %.1f > K(3) = %.1f"
      % (ci * N[2], G[1][6], ci * N[3], G[2][6]))
ok &= (perto(p, [0.03, 0.05, 0.12, 0.25, 0.30, 0.25], 1e-12) and abs(vida - 4.49) < 1e-9
       and abs(n / vida - 178.2) < 0.05 and abs(ind - 4454.34) < 0.005
       and perto(N, [24, 40.72, 98.42, 207.87, 262.04, 247.45, 88.29, 138.14, 190.73, 215.67, 194.40, 162.39],
                       0.005)
       # o slide faz a tabela com os N_t já arredondados (K(6) = 4468,8; sem arredondar, 4468,75):
       and perto([r[6] for r in G], [5400.0, 3209.0, 2959.5, 3518.8, 4125.3, 4468.8], 0.06)
       and perto([r[5] for r in G], [5400.0, 6418.0, 8878.5, 14075.3, 20626.3, 26812.5], 0.06)
       and b[0] == 3 and abs(ind - b[6] - 1494.8) < 0.05 and round(100 * (b[6] / ind - 1)) == -34
       and ci * N[3] > G[2][6] and ci * N[2] < G[1][6])

# ------------------------------------------------------------ sensibilidade a c_g
for cgx, K3_ok in ((10, 4026.2), (12, 4559.5)):
    _, _, _, Gx = grupo(n, ci, cgx, Pac)
    K3 = Gx[2][6]
    print("  sensibilidade: c_g = %d: K(3) = %.1f %s %.1f -> %s"
          % (cgx, K3, "<" if K3 < ind else ">", ind, "grupo" if K3 < ind else "individual"))
    ok &= abs(K3 - K3_ok) < 0.05 and melhor(Gx)[0] == 3

# ------------------------------------------------------------ simulação
T = 8
F = simula(n, Pac, T=T, runs=4000, seed=1)
print("\nSimulação de Monte Carlo (4000 corridas de 800 luminárias, semente 1)")
print("     t  N_t (fórmula)  simulação")
for t in range(T):
    print("  %4d %14.1f %10.1f" % (t + 1, N[t], F[t]))
print("  maior diferença: %s" % ("até 1,0 (dentro da tolerância)" if np.max(np.abs(F - N[:T])) <= 1.0 else "mais de 1,0"))
ok &= np.max(np.abs(F - np.array(N[:T]))) <= 1.0

# ------------------------------------------------------------ Para resolver na aula: Exemplo 5
p5, v5, i5, G5 = grupo(1000, 3, 1, [0.10, 0.25, 0.50, 0.70, 1.00])
b5 = melhor(G5)
print("\nExemplo 5 (1000 lâmpadas, c_i = 3 €, c_g = 1 €; períodos de uma semana)")
print("  p_t: %s" % fmt(p5))
print("  a) vida média: %.2f semanas" % v5)
print("  b) individual: K_ind = %.2f € por semana" % i5)
print("  c) N_t: %s" % fmt([r[1] for r in G5]))
print("     K(t): %s" % fmt([r[6] for r in G5]))
print("     melhor: grupo de %d em %d semanas, K = %.2f %s %.2f -> %s"
      % (b5[0], b5[0], b5[6], "<" if b5[6] < i5 else ">", i5, "compensa" if b5[6] < i5 else "não compensa"))
ok &= (perto(p5, [0.10, 0.15, 0.25, 0.20, 0.30], 1e-12) and abs(v5 - 3.45) < 1e-9 and abs(i5 - 869.57) < 0.005
       and perto([r[1] for r in G5], [100, 160, 281, 277.1, 429.86], 0.005)
       and perto([r[6] for r in G5], [1300, 890, 874.33, 863.57, 948.78], 0.006)
       and b5[0] == 4 and b5[6] < i5)

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
