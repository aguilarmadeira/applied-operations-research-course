"""Reproduz os exemplos do deck 3.4 (branch and bound).

Plastificação (3 máquinas, tempo total): nó «3 primeiro» com C = (2, 11, 18) e LB = max(22, 34, 34) = 34;
raiz 32; árvore com 10 nós e ótimo 3, 2, 4, 1 com T = 35. Resumo: chegada 39, Johnson 39, TDM 40, B&B 35.
Impressora digital (1 máquina, atraso total): EDD N, M, L, K com atraso 9; limites ...K 4, ...L 7,
...LK 9, ...KL 7; árvore com 13 nós e ótimo N, M, K, L com atraso 7 (C = 3, 6, 8, 15; atrasos 0, 0, 0, 7).
Com 8 trabalhos: 8! = 40320 sequências e 109600 nós na árvore completa.
(A experiência com 100 problemas aleatórios está em experiencia_bb.py, só em Python.)
O TPC da Lista 3 não é resolvido aqui.

Correr (de qualquer pasta):  python ex03_4_branch_and_bound.py

Complementos de IO — deck 3.4.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

import math

from sequenciamento import tempos, cmax, forca_bruta
from m_maquinas import johnson_m
from desvio_tempo import tdm
from bb_sequenciamento import lb_fs, bb_fs, atraso, bb_atraso

ok = True
print("Complementos de IO — deck 3.4: branch and bound")

# ------------------------------------------------------------ parte 1: plastificação
Q = {"1": (2, 4, 3), "2": (7, 8, 8), "3": (2, 9, 7), "4": (4, 8, 5)}
print("\nParte 1 — plastificação (3 máquinas, tempo total)")
c3 = tempos(["3"], Q)[-1]
U = ["1", "2", "4"]
lbs = [c3[i] + sum(Q[j][i] for j in U) + min(sum(Q[j][i + 1:]) for j in U) for i in range(3)]
print("  nó «3 primeiro»: C = (%s), LB1, LB2, LB3 = %s -> LB = %d"
      % (", ".join("%d" % x for x in c3), ", ".join("%d" % x for x in lbs), lb_fs(["3"], Q)))
print("  raiz: LB = %d" % lb_fs([], Q))
(v, s), nos = bb_fs(Q)
print("  nós gerados (%d): %s" % (len(nos), ", ".join("%s: %d" % n for n in nos)))
print("  ótimo: %s com T = %d (força bruta: %d sequências, mínimo %d)"
      % (", ".join(s), v, len(forca_bruta(Q)), forca_bruta(Q)[0][0]))
ok &= c3 == [2, 11, 18] and lbs == [22, 34, 34] and lb_fs(["3"], Q) == 34 and lb_fs([], Q) == 32
ok &= (v, s) == (35, "3241") and len(nos) == 10
ok &= nos == [("1", 36), ("2", 39), ("3", 34), ("4", 36), ("31", 36), ("32", 35), ("34", 35),
              ("321", 36), ("324", 35), ("3241", 35)]

print("  resumo da semana da plastificação:")
resumo = [("ordem de chegada", list(Q)), ("Johnson sobre (G, H)", johnson_m(Q)),
          ("TDM sobre (G, H)", tdm(Q)[0]), ("branch and bound", list(s))]
for nome, seq in resumo:
    print("    %-22s %s  T = %d" % (nome, ", ".join(seq), cmax(seq, Q)))
ok &= [cmax(q, Q) for _, q in resumo] == [39, 39, 40, 35]
ok &= johnson_m(Q) == list("1342") and tdm(Q)[0] == list("2341")

# ------------------------------------------------------------ parte 2: impressora digital
p = {"K": 2, "L": 7, "M": 3, "N": 3}
d = {"K": 11, "L": 8, "M": 6, "N": 4}
print("\nParte 2 — impressora digital (1 máquina, atraso total); soma dos tempos = %d" % sum(p.values()))
edd = sorted(p, key=lambda j: d[j])
print("  EDD (prazo mais cedo primeiro): %s, atraso total = %d" % (", ".join(edd), atraso(edd, p, d)))
(v, s), nos = bb_atraso(p, d)
print("  nós gerados (%d): %s" % (len(nos), ", ".join("...%s: %d" % n for n in nos)))
Cj = [r[0] for r in tempos(list(s), {j: (p[j],) for j in p})]
print("  ótimo: %s com atraso %d;  C = (%s), atrasos %s"
      % (", ".join(s), v, ", ".join("%d" % x for x in Cj),
         ", ".join("%d" % max(0, c - d[j]) for c, j in zip(Cj, s))))
bfa = forca_bruta(p, lambda q: atraso(q, p, d))
print("  força bruta: %d sequências, mínimo %d" % (len(bfa), bfa[0][0]))
ok &= edd == list("NMLK") and atraso(edd, p, d) == 9 and (v, s) == (7, "NMKL") and len(nos) == 13
ok &= nos[:4] == [("K", 4), ("L", 7), ("M", 9), ("N", 11)]
ok &= dict(nos)["LK"] == 9 and dict(nos)["KL"] == 7 and dict(nos)["MKL"] == 7 and dict(nos)["NKL"] == 9
ok &= Cj == [3, 6, 8, 15] and bfa[0] == (7, "NMKL")

# ------------------------------------------------------------ tamanho da árvore completa
n = 8
print("\nCom %d trabalhos: %d sequências; a árvore completa tem %d nós"
      % (n, math.factorial(n), sum(math.perm(n, k) for k in range(1, n + 1))))
ok &= math.factorial(8) == 40320 and sum(math.perm(8, k) for k in range(1, 9)) == 109600

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
