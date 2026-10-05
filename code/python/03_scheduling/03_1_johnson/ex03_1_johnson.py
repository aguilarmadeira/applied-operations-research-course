"""Reproduz os exemplos do deck 3.1 (regra de Johnson, 2 máquinas).

Gráfica, seis trabalhos (impressão, acabamento): pela ordem de chegada T = 53 h (ociosos 12 e 11);
Johnson D, E, A, F, B, C com T = 45 h (ociosos 4 e 3).
Força bruta: o mínimo das 720 sequências é 45 h (só D E A F B C e D E F A B C), média 53 h, pior 61 h.
Para resolver na aula: Exemplo 1 (nove trabalhos) T = 61, ociosos 11 e 2;
Exemplo 2 (sete trabalhos) T = 67, ociosos 1 e 17, e os empates não mudam o tempo total.

Correr (de qualquer pasta):  python ex03_1_johnson.py

Complementos de IO — deck 3.1.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

from sequenciamento import tempos, cmax, ocios, tempo_total, johnson, forca_bruta


def mostra(nome, seq, P):
    """Sequência, tempo total, ociosos e a tabela dos instantes de conclusão."""
    C = tempos(seq, P)
    print("  %s: %s  T = %d  ociosos = %s" % (nome, " ".join(seq), cmax(seq, P),
                                             ", ".join("%d" % x for x in ocios(seq, P))))
    for i in range(len(C[0])):
        print("    M%d:%s" % (i + 1, "".join("%4d" % C[k][i] for k in range(len(seq)))))


ok = True
print("Complementos de IO — deck 3.1: regra de Johnson (2 máquinas)")

# ------------------------------------------------------------ a gráfica (slide «Em Python»)
a = dict(A=8, B=11, C=5, D=3, E=4, F=10)
b = dict(A=9, B=5, C=2, D=5, E=12, F=9)
P = {j: (a[j], b[j]) for j in a}
print("\nGráfica (impressão, acabamento): somas %d e %d h" % (sum(a.values()), sum(b.values())))
mostra("ordem de chegada", list(P), P)
s = johnson(a, b)
mostra("Johnson", s, P)
print("  tempo_total(Johnson) = %d" % tempo_total(s, a, b))
ok &= cmax(list(P), P) == 53 and ocios(list(P), P) == [12, 11]
ok &= s == list("DEAFBC") and tempo_total(s, a, b) == 45 and ocios(s, P) == [4, 3]
ok &= [r[1] for r in tempos(s, P)] == [8, 20, 29, 38, 43, 45]

# ------------------------------------------------------------ força bruta: as 720 sequências
bf = forca_bruta(P)
vals = [v for v, _ in bf]
otimas = [q for v, q in bf if v == vals[0]]
print("\nForça bruta: %d sequências; mínimo %d (%s); média %.2f; pior %d"
      % (len(bf), vals[0], ", ".join(otimas), sum(vals) / len(vals), max(vals)))
hist = [(T, vals.count(T)) for T in range(min(vals), max(vals) + 1) if T in vals]
print("  n.º de sequências por T: " + ", ".join("%d: %d" % h for h in hist))
ok &= vals[0] == 45 and otimas == ["DEAFBC", "DEFABC"] and max(vals) == 61
ok &= round(sum(vals) / len(vals)) == 53 and hist[1] == (46, 38) and hist[5] == (50, 123)

# ------------------------------------------------------------ Exemplo 1: nove trabalhos
M1 = [2, 5, 4, 9, 6, 8, 7, 5, 4]
M2 = [6, 8, 7, 4, 3, 9, 3, 8, 11]
nomes = ["J%d" % k for k in range(1, 10)]
a1 = dict(zip(nomes, M1)); b1 = dict(zip(nomes, M2))
P1 = {j: (a1[j], b1[j]) for j in nomes}
print("\nExemplo 1 (nove trabalhos): somas %d e %d" % (sum(M1), sum(M2)))
s1 = johnson(a1, b1)
mostra("Johnson", s1, P1)
alt = "J1 J9 J3 J8 J2 J6 J4 J7 J5".split()
print("  com os empates escolhidos ao contrário: %s  T = %d" % (" ".join(alt), cmax(alt, P1)))
ok &= s1 == "J1 J3 J9 J2 J8 J6 J4 J5 J7".split() and cmax(s1, P1) == 61 and ocios(s1, P1) == [11, 2]
ok &= cmax(alt, P1) == 61

# ------------------------------------------------------------ Exemplo 2: sete trabalhos
M1 = [3, 12, 15, 6, 10, 11, 9]
M2 = [8, 10, 10, 6, 12, 1, 3]
nomes = [str(k) for k in range(1, 8)]
a2 = dict(zip(nomes, M1)); b2 = dict(zip(nomes, M2))
P2 = {j: (a2[j], b2[j]) for j in nomes}
print("\nExemplo 2 (sete trabalhos): somas %d e %d" % (sum(M1), sum(M2)))
s2 = johnson(a2, b2)
mostra("Johnson", s2, P2)
print("  empates (o 4 tem a = b = 6; o 2 e o 3 têm b = 10): outras sequências de Johnson")
variantes = ["1 5 4 2 3 7 6", "1 5 3 2 4 7 6", "1 5 2 3 4 7 6", "1 4 5 3 2 7 6"]
for v in variantes:
    print("    %s  T = %d" % (v, cmax(v.split(), P2)))
ok &= s2 == "1 4 5 2 3 7 6".split() and cmax(s2, P2) == 67 and ocios(s2, P2) == [1, 17]
ok &= all(cmax(v.split(), P2) == 67 for v in variantes)

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
