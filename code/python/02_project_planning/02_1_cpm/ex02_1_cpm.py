"""Reproduz os exemplos do deck 2.1 (planeamento de projetos: CPM).

Exemplo do capítulo: renovar um laboratório (8 atividades, soma das durações 21 semanas).
Slide «Passagem para a frente e para trás»: T = 13 semanas, caminho crítico A, C, D, F, H;
folga 1 em B, E e G.  Slide «Caminho crítico = caminho mais longo»: 12, 13, 12, 12.
Slide «O que fazer com as folgas?»: se B atrasar 2 semanas, o projeto passa a 14.
Para resolver na aula: Exemplo 1 (T = 15, crítico A, C, E, G, H) e
Exemplo 2, construção de uma obra (Hillier & Lieberman): T = 44, sem multa nem prémio.

Correr (de qualquer pasta):  python ex02_1_cpm.py

Complementos de IO — deck 2.1.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

from pm import topo, cpm, caminhos


def tabela(titulo, acts, dur=None):
    """Imprime as quatro datas e a folga de cada atividade, o caminho crítico e os caminhos."""
    ES, EF, LS, LF, F, T = cpm(acts, dur)
    d = dur or {a: v[1] for a, v in acts.items()}
    crit = [a for a in acts if abs(F[a]) < 1e-9]
    print("\n" + titulo)
    print("  ativ.  dur   ES   EF   LS   LF  folga")
    for a in topo(acts):
        print("  %-5s %4g %4g %4g %4g %4g %6g" % (a, d[a], ES[a], EF[a], LS[a], LF[a], F[a]))
    print("  duração do projeto: %g semanas; caminho crítico: %s" % (T, ", ".join(crit)))
    cam = [("--".join(p), sum(d[x] for x in p)) for p in caminhos(acts)]
    print("  caminhos: " + "; ".join("%s %g" % c for c in cam))
    return F, T, crit, cam


ok = True
print("Complementos de IO — deck 2.1: planeamento de projetos (CPM)")

# ------------------------------------------------------------ o laboratório
LAB = {"A": ([], 3), "B": (["A"], 4), "C": (["A"], 2), "D": (["C"], 3),
       "E": (["C"], 2), "F": (["B", "D", "E"], 3), "G": (["D"], 2), "H": (["F", "G"], 2)}
soma = sum(v[1] for v in LAB.values())
F, T, crit, cam = tabela("Laboratório (soma das durações: %g semanas)" % soma, LAB)
ES, EF, LS, LF, _, _ = cpm(LAB)
ok &= (soma == 21 and T == 13 and crit == ["A", "C", "D", "F", "H"]
       and [F[a] for a in LAB] == [0, 1, 0, 0, 1, 0, 1, 0]
       and [ES[a] for a in LAB] == [0, 3, 3, 5, 5, 8, 8, 11]
       and [LF[a] for a in LAB] == [3, 8, 5, 8, 8, 11, 11, 13]
       and cam == [("A--B--F--H", 12), ("A--C--D--F--H", 13), ("A--C--D--G--H", 12), ("A--C--E--F--H", 12)])

# B atrasa 2 semanas
d = {a: v[1] for a, v in LAB.items()}
d["B"] = 6
ES6, EF6, LS6, LF6, F6, T6 = cpm(LAB, d)
crit6 = [a for a in LAB if abs(F6[a]) < 1e-9]
print("\nB atrasa 2 semanas (B = 6): EF_B = %g > LS_F = %g; T = %g semanas; crítico: %s"
      % (EF6["B"], LS["F"], T6, ", ".join(crit6)))
ok &= EF6["B"] == 9 and LS["F"] == 8 and T6 == 14 and crit6 == ["A", "B", "F", "H"]

# ------------------------------------------------------------ Exemplo 1
EX1 = {"A": ([], 2), "B": ([], 3), "C": (["A"], 2), "D": (["A", "B"], 4),
       "E": (["C"], 4), "F": (["C"], 3), "G": (["D", "E"], 5), "H": (["F", "G"], 2)}
F1, T1, crit1, cam1 = tabela("Exemplo 1", EX1)
ok &= (T1 == 15 and crit1 == ["A", "C", "E", "G", "H"]
       and [F1[a] for a in EX1] == [0, 1, 0, 1, 0, 6, 0, 0]
       and cam1 == [("A--C--E--G--H", 15), ("A--C--F--H", 9), ("A--D--G--H", 13), ("B--D--G--H", 14)])

# ------------------------------------------------------------ Exemplo 2 (Hillier & Lieberman)
HL = {"A": ([], 2), "B": (["A"], 4), "C": (["B"], 10), "D": (["C"], 6), "E": (["C"], 4),
      "F": (["E"], 5), "G": (["D"], 7), "H": (["E", "G"], 9), "I": (["C"], 7), "J": (["F", "I"], 8),
      "K": (["J"], 4), "L": (["J"], 5), "M": (["H"], 2), "N": (["K", "L"], 6)}
F2, T2, crit2, cam2 = tabela("Exemplo 2 (construção de uma obra, Hillier & Lieberman)", HL)
simnao = {False: "não", True: "sim"}
print("  multa (T > 47)? %s;  prémio (T < 40)? %s;  para o prémio é preciso retirar %g semanas"
      % (simnao[T2 > 47], simnao[T2 < 40], T2 - 39))
ok &= (T2 == 44 and crit2 == ["A", "B", "C", "E", "F", "J", "L", "N"]
       and [F2[a] for a in "DGHIKM"] == [4, 4, 4, 2, 1, 4] and not T2 > 47 and not T2 < 40)

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
