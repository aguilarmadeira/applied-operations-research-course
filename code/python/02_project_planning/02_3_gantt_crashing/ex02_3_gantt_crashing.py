"""Reproduz os exemplos do deck 2.3 (diagrama de Gantt e crashing).

Slide «Do plano ao calendário»: Gantt do laboratório (críticas A, C, D, F, H; folga em B, E e G).
Slide «E se o cliente quiser o laboratório mais cedo?»: custo por semana 3, 3, 2, 4, -, 4, 3, 5;
custo normal 63; bónus de 6 por semana antecipada.
Slides «Aceleração semana a semana» e «Custo total»: encurtar C, A, F, H (2, 3, 4, 5);
custo total 63, 59, 56, 54, 53, 54 para T = 13, ..., 8; ótimo T = 9 (53), porque 9 -> 8 custa 7 > 6.
Slide «Complemento»: a programação linear dá o mesmo (T = 9, custo 53).
Para resolver na aula: exame de 26/07/2019, T = 18 dias, crítico A, C, E, custo 3700;
crashing para 16 dias: 4050 (A, B e C menos 1 dia); Gantt do plano final.

Correr (de qualquer pasta):  python ex02_3_gantt_crashing.py

Complementos de IO — deck 2.3.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

from pm import cpm, caminhos
from crashing import gantt, crash, crash_pl


def acelera(titulo, acts, bonus, Tmin):
    """Tabela do crashing, da duração normal até Tmin: o que se encurta, custos e caminhos."""
    slope, b = crash(acts, bonus)
    Tn = max(b)
    cam = caminhos(acts)
    print("\n" + titulo)
    print("  custo por unidade: " + "; ".join("%s %s" % (a, ("%g" % s) if acts[a][1] > acts[a][3] else "-")
                                            for a, s in slope.items()))
    print("  caminhos: " + "  ".join("(%d) %s" % (k + 1, "--".join(p)) for k, p in enumerate(cam)))
    print("   T  encurtada   +custo  direto   bónus   total   duração dos caminhos")
    ant = None
    for T in sorted((T for T in b if T >= Tmin), reverse=True):
        c, d, tot = b[T]
        if ant is None:
            enc, marg = "---", "---"
        else:
            menos = [a for a in acts if d[a] < ant[1][a]]
            mais = [a for a in acts if d[a] > ant[1][a]]
            enc = "+".join(menos) + "".join(" repõe " + a for a in mais)
            marg = "%g" % (c - ant[0])
        print("  %2g  %-10s %6s %7g %7g %7g   %s" % (T, enc, marg, c, -bonus * (Tn - T), tot,
                                                 " ".join("%g" % sum(d[x] for x in p) for p in cam)))
        ant = (c, d)
    return slope, b


ok = True
print("Complementos de IO — deck 2.3: diagrama de Gantt e aceleração de projetos (crashing)")

# ------------------------------------------------------------ o laboratório
LAB = {"A": ([], 3, 6, 2, 9), "B": (["A"], 4, 20, 2, 26), "C": (["A"], 2, 4, 1, 6), "D": (["C"], 3, 8, 2, 12),
       "E": (["C"], 2, 5, 2, 5), "F": (["B", "D", "E"], 3, 10, 1, 18), "G": (["D"], 2, 6, 1, 9),
       "H": (["F", "G"], 2, 4, 1, 9)}
print("\nGantt do laboratório (# crítica, = com folga, - folga)")
g = gantt(LAB)
print("\n".join(g))
ok &= g[1:] == ["  A       ###..........", "  B       ...====-.....", "  C       ...##........",
                "  D       .....###.....", "  E       .....==-.....", "  F       ........###..",
                "  G       ........==-..", "  H       ...........##"]

slope, b = acelera("Crashing do laboratório (bónus 6 por semana antecipada)", LAB, 6, 8)
custo_normal = sum(v[2] for v in LAB.values())
tot = {T: v[2] for T, v in b.items()}
Topt = min(tot, key=lambda T: (tot[T], -T))
print("  custo normal %g; ótimo: T = %g semanas, custo total %g; %g -> %g custaria %g > %g"
      % (custo_normal, Topt, tot[Topt], Topt, Topt - 1, b[Topt - 1][0] - b[Topt][0], 6))
ok &= ([slope[a] for a in LAB] == [3, 3, 2, 4, 0, 4, 3, 5] and custo_normal == 63
       and [b[T][0] for T in range(13, 7, -1)] == [63, 65, 68, 72, 77, 84]
       and [tot[T] for T in range(13, 7, -1)] == [63, 59, 56, 54, 53, 54] and Topt == 9
       and [LAB[a][1] - b[9][1][a] for a in LAB] == [1, 0, 1, 0, 0, 1, 0, 1])

try:
    Tpl, dir_pl, tot_pl, y = crash_pl(LAB, 6)
    print("  programação linear (linprog do scipy): T = %.4g, custo direto %.4g, total %.4g"
          % (Tpl, dir_pl, tot_pl))
    ok &= abs(Tpl - 9) < 1e-6 and abs(tot_pl - 53) < 1e-6
except ImportError:
    print("  programação linear: precisa de scipy (pip install scipy)")

# ------------------------------------------------------------ para resolver na aula
EX = {"A": ([], 4, 700, 2, 1100), "B": ([], 9, 900, 7, 1000), "C": (["A"], 9, 300, 8, 400),
      "D": (["A", "B"], 3, 400, 2, 475), "E": (["C", "D"], 5, 600, 5, 600), "F": (["B", "D"], 4, 800, 3, 950)}
ES, EF, LS, LF, F, T = cpm(EX)
crit = [a for a in EX if abs(F[a]) < 1e-9]
print("\nExercício (exame de 26/07/2019), durações em dias")
print("  folgas: " + "; ".join("%s %g" % (a, F[a]) for a in EX))
print("  duração do projeto: %g dias; caminho crítico: %s; custo normal %g"
      % (T, ", ".join(crit), sum(v[2] for v in EX.values())))
slope2, b2 = acelera("Crashing do exercício até 16 dias", EX, 0, 16)
enc16 = [a for a in EX if b2[16][1][a] < EX[a][1]]
print("  16 dias: custo %g (encurtar %s um dia cada)" % (b2[16][0], ", ".join(enc16)))
print("Gantt do plano final (16 dias)")
g2 = gantt(EX, b2[16][1])
print("\n".join(g2))
ok &= (T == 18 and crit == ["A", "C", "E"] and [F[a] for a in EX] == [0, 1, 0, 1, 0, 2]
       and b2[18][0] == 3700 and b2[17][0] == 3800 and b2[16][0] == 4050 and enc16 == ["A", "B", "C"]
       and [slope2[a] for a in EX] == [200, 50, 100, 75, 0, 150]
       and g2[1:] == ["  A       ###.............", "  B       ########........", "  C       ...########.....",
                      "  D       ........###.....", "  E       ...........#####", "  F       ...........====-"])

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
