"""Reproduz os exemplos do deck 2.2 (planeamento de projetos: PERT).

Slide «Quando as durações são incertas»: B com (2, 3, 10) => te = 4, var = 1.78.
Laboratório com três estimativas: T = 13, crítico A, C, D, F, H, var = 0.556, sd = 0.745;
P(T <= 14) = P(Z <= 1.34) = 0.91; A--B--F--H tem var 2.111 e P(A--B--F--H <= 14) = 0.92.
Slide «Simulação: 200 000 projetos» (Beta-PERT, semente 2026): média 13.2;
P(T <= 13, 14, 15) = 41%, 80%, 96% (PERT: 50%, 91%, 99.6%); A--B--F--H é o mais longo em 23%.
Para resolver na aula: Exemplo PERT, T = 17, crítico C, F, H, J, P(T <= 22) = 0.989.

A simulação dá números diferentes noutro gerador (MATLAB/Octave): compara-se com tolerância.

Correr (de qualquer pasta):  python ex02_2_pert.py

Complementos de IO — deck 2.2.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

import numpy as np

from pm import caminhos
from pert import Phi, pert, simula_pert


def mostra(titulo, P, alvos, xcam):
    """Tabela de te e var, caminho crítico, P(T <= x) para x em alvos e, por caminho, P(<= xcam)."""
    te, var, T, crit = pert(P)
    s2 = sum(var[a] for a in crit)
    print("\n" + titulo)
    print("  ativ.  to  tm  tp     te    var")
    for a, v in P.items():
        print("  %-5s %3g %3g %3g %6.4g %6.3f" % (a, v[1], v[2], v[3], te[a], var[a]))
    print("  duração esperada: %g semanas; caminho crítico: %s" % (T, ", ".join(crit)))
    print("  var = %.3f; sd = %.3f" % (s2, s2 ** 0.5))
    prob = []
    for x in alvos:
        z = (x - T) / s2 ** 0.5
        prob.append(Phi(z))
        print("  P(T <= %g) = Phi(%.3f) = %.4f" % (x, z, Phi(z)))
    cam = []
    for p in caminhos({a: (v[0], te[a]) for a, v in P.items()}):
        mu, v = sum(te[x] for x in p), sum(var[x] for x in p)
        cam.append(("--".join(p), mu, v))
        print("  caminho %-14s mu = %-3g var = %.3f  P(<= %g) = %.4f"
              % ("--".join(p), mu, v, xcam, Phi((xcam - mu) / v ** 0.5)))
    return te, var, T, crit, s2, prob, cam


ok = True
print("Complementos de IO — deck 2.2: planeamento de projetos (PERT)")

# ------------------------------------------------------------ uma atividade
teB, vB = (2 + 4 * 3 + 10) / 6, ((10 - 2) / 6) ** 2
print("\nEncomenda do equipamento (B): to = 2, tm = 3, tp = 10 -> te = %g, var = %.3f" % (teB, vB))
ok &= teB == 4 and abs(vB - 1.778) < 1e-3

# ------------------------------------------------------------ o laboratório
LAB = {"A": ([], 2, 3, 4), "B": (["A"], 2, 3, 10), "C": (["A"], 1, 2, 3), "D": (["C"], 2, 3, 4),
       "E": (["C"], 1, 2, 3), "F": (["B", "D", "E"], 2, 3, 4), "G": (["D"], 1, 2, 3), "H": (["F", "G"], 1, 2, 3)}
te, var, T, crit, s2, prob, cam = mostra("Laboratório com três estimativas", LAB, [13, 14, 15], 14)
ok &= (np.allclose([te[a] for a in LAB], [3, 4, 2, 3, 2, 3, 2, 2]) and abs(T - 13) < 1e-9
       and crit == ["A", "C", "D", "F", "H"] and abs(s2 - 0.556) < 1e-3 and abs(s2 ** 0.5 - 0.745) < 1e-3
       and round(1 / s2 ** 0.5, 2) == 1.34 and round(prob[1], 2) == 0.91
       and round(prob[0], 3) == 0.5 and round(prob[2], 3) == 0.996)
abfh = [c for c in cam if c[0] == "A--B--F--H"][0]
ok &= abs(abfh[1] - 12) < 1e-9 and abs(abfh[2] - 2.111) < 1e-3 and round(Phi(2 / abfh[2] ** 0.5), 2) == 0.92

# ------------------------------------------------------------ simulação
N = 200_000
Tsim, D = simula_pert(LAB, N, 2026)
psim = [(Tsim <= x).mean() for x in (13, 14, 15)]
print("\nSimulação: %d projetos, durações Beta-PERT, semente 2026" % N)
print("                 PERT    simulação")
print("  duração média  %.1f    %.1f" % (T, Tsim.mean()))
for x, pp, ps in zip((13, 14, 15), prob, psim):
    print("  P(T <= %g)     %.1f%%   %.0f%%" % (x, 100 * pp, 100 * ps))
paths = caminhos(LAB)
L = np.vstack([sum(D[x] for x in p) for p in paths])
freq = [(L.argmax(0) == i).mean() for i in range(len(paths))]
print("  caminho mais longo nos sorteios: "
      + "; ".join("%s %.0f%%" % ("--".join(p), 100 * f) for p, f in zip(paths, freq)))
# histograma do slide (densidade por intervalo de meia semana, de 10 a 18)
hist_slide = [0.001, 0.008, 0.0404, 0.1248, 0.2606, 0.3938, 0.427, 0.3468,
              0.2122, 0.1014, 0.046, 0.0212, 0.0098, 0.0044, 0.0018, 0.0004]
dens = [((Tsim >= x) & (Tsim < x + 0.5)).mean() / 0.5 for x in np.arange(10, 18, 0.5)]
hist_ok = max(abs(h - s) for h, s in zip(dens, hist_slide)) < 0.01
print("  histograma igual ao do slide (tolerância 0.01): %s" % ("sim" if hist_ok else "não"))
ok &= (abs(Tsim.mean() - 13.2) < 0.05 and all(abs(p - s) < 0.01 for p, s in zip(psim, (0.41, 0.80, 0.96)))
       and abs(freq[0] - 0.23) < 0.01 and hist_ok)

# ------------------------------------------------------------ para resolver na aula
PEX = {"A": ([], 5, 6, 7), "B": ([], 1, 3, 5), "C": ([], 1, 4, 7), "D": (["A"], 1, 2, 3),
       "E": (["B"], 1, 2, 9), "F": (["C"], 1, 5, 9), "G": (["C"], 2, 2, 8), "H": (["E", "F"], 4, 4, 10),
       "I": (["D"], 2, 5, 8), "J": (["H", "G"], 2, 2, 8)}
te2, var2, T2, crit2, s22, prob2, cam2 = mostra("Exemplo PERT (para resolver na aula)", PEX, [22], 22)
ok &= (abs(T2 - 17) < 1e-9 and crit2 == ["C", "F", "H", "J"] and abs(s22 - 4.778) < 1e-3
       and round(prob2[0], 3) == 0.989
       and [(c[0], round(c[1], 6), round(c[2], 3)) for c in cam2]
       == [("A--D--I", 13, 1.222), ("B--E--H--J", 14, 4.222), ("C--F--H--J", 17, 4.778), ("C--G--J", 10, 3)])

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
