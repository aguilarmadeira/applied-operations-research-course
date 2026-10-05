"""Reproduz os exemplos do deck 3.3 (método do desvio de tempo, TDM).

Gráfica (2 máquinas): iteração 1 com B pela frente e E por trás; construída B, F, C, D, A, E;
TDM E, A, D, C, F, B com T = 46 h (Johnson 45); das 720 sequências, 40 dão 46 h ou menos.
Os três exemplos do capítulo (chegada, TDM, Johnson, ótimo): 53, 46, 45, 45; 55, 49, 47, 47; 39, 40, 39, 35.
Para resolver na aula: Exemplo 6 (= Exemplo 1 de 3.1) T = 63 contra 61 de Johnson;
Exemplo 7 (= Exemplo 5 de 3.2) T = 54 contra 51; Exemplo 8 T = 62 contra 60 (o ótimo).
(A experiência com 500 problemas aleatórios está em experiencia_aleatoria.py, só em Python.)

Correr (de qualquer pasta):  python ex03_3_tdm.py

Complementos de IO — deck 3.3.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

import numpy as np

from sequenciamento import tempos, cmax, ocios, forca_bruta
from m_maquinas import reduz, condicao, johnson_m
from desvio_tempo import desvios, tdm


def mat2str(A):
    """Matriz/vetor no formato do mat2str do MATLAB (para as saídas serem iguais)."""
    A = np.atleast_2d(np.asarray(A, float))
    return "[" + ";".join(" ".join("%.15g" % x for x in linha) for linha in A) + "]"


def mostra(nome, seq, P):
    """Sequência, tempo total, ociosos e a tabela dos instantes de conclusão."""
    C = tempos(seq, P)
    print("  %s: %s  T = %d  ociosos = %s" % (nome, " ".join(seq), cmax(seq, P),
                                             ", ".join("%d" % x for x in ocios(seq, P))))
    for i in range(len(C[0])):
        print("    M%d:%s" % (i + 1, "".join("%4d" % C[k][i] for k in range(len(seq)))))


def tabela(linhas, nomes=None):
    """Dicionário trabalho -> tempos a partir de uma tabela com uma linha por máquina."""
    n = len(linhas[0])
    nomes = nomes or [str(k + 1) for k in range(n)]
    return {nomes[k]: tuple(l[k] for l in linhas) for k in range(n)}


ok = True
print("Complementos de IO — deck 3.3: método do desvio de tempo (TDM)")

# ------------------------------------------------------------ gráfica, passo a passo
P = tabela([[8, 11, 5, 3, 4, 10], [9, 5, 2, 5, 12, 9]], list("ABCDEF"))
a = {j: t[0] for j, t in P.items()}
b = {j: t[1] for j, t in P.items()}
print("\nGráfica (impressão, acabamento); desvios (máquina, trabalho) em cada máquina")
s, constr = tdm(P, log=True)
print("  construída: %s;  TDM (invertida): %s" % (" ".join(constr), " ".join(s)))
mostra("TDM", s, P)
vals = [v for v, _ in forca_bruta(P)]
print("  das %d sequências, %d dão T <= %d" % (len(vals), sum(1 for v in vals if v <= 46), 46))
D1 = desvios(a, b, list(P))
ok &= D1["A"] == ((3, 1), (3, 0)) and D1["B"] == ((0, 0), (7, 6)) and D1["C"] == ((6, 0), (10, 3))
ok &= D1["E"] == ((7, 8), (0, 0)) and desvios(a, b, list("ACDF"))["F"] == ((0, 0), (0, 1))
ok &= constr == list("BFCDAE") and s == list("EADCFB") and cmax(s, P) == 46
ok &= [r[1] for r in tempos(s, P)] == [16, 25, 30, 32, 41, 46] and sum(1 for v in vals if v <= 46) == 40

# ------------------------------------------------------------ os três exemplos do capítulo
print("\nOs três exemplos do capítulo (tempos totais em horas)")
print("  %-36s %8s %5s %8s %6s" % ("", "chegada", "TDM", "Johnson", "ótimo"))
casos = [("Gráfica, 2 máquinas (3.1)", P),
         ("Com corte, 3 máquinas (3.2)",
          tabela([[8, 11, 5, 3, 4, 10], [2, 3, 1, 2, 3, 1], [9, 5, 2, 5, 12, 9]], list("ABCDEF"))),
         ("Plastificação, condição falha (3.2)", tabela([[2, 7, 2, 4], [4, 8, 9, 8], [3, 8, 7, 5]]))]
quadro = []
for nome, Q in casos:
    linha = [cmax(list(Q), Q), cmax(tdm(Q)[0], Q), cmax(johnson_m(Q), Q), forca_bruta(Q)[0][0]]
    quadro.append(linha)
    print("  %-36s %8d %5d %8d %6d" % ((nome,) + tuple(linha)))
sq, cq = tdm(casos[2][1])
print("  plastificação: TDM %s (construída %s)" % (" ".join(sq), " ".join(cq)))
ok &= quadro == [[53, 46, 45, 45], [55, 49, 47, 47], [39, 40, 39, 35]] and sq == list("2341")

# ------------------------------------------------------------ Exemplo 6 (= Exemplo 1 de 3.1)
E1 = tabela([[2, 5, 4, 9, 6, 8, 7, 5, 4], [6, 8, 7, 4, 3, 9, 3, 8, 11]], ["J%d" % k for k in range(1, 10)])
print("\nExemplo 6 (= Exemplo 1 de 3.1)")
s6, c6 = tdm(E1, log=True)
print("  construída: %s" % " ".join(c6))
mostra("TDM", s6, E1)
print("  Johnson: T = %d" % cmax(johnson_m(E1), E1))
ok &= c6 == "J4 J7 J5 J1 J3 J2 J8 J6 J9".split() and cmax(s6, E1) == 63 and ocios(s6, E1) == [13, 4]
ok &= cmax(johnson_m(E1), E1) == 61

# ------------------------------------------------------------ Exemplo 7 (= Exemplo 5 de 3.2)
E5 = tabela([[7, 6, 5, 8], [5, 6, 4, 3], [2, 4, 5, 3], [3, 5, 6, 2], [9, 10, 8, 6]])
G, H = reduz(E5)
print("\nExemplo 7 (= Exemplo 5 de 3.2): G = %s, H = %s" % (mat2str(list(G.values())), mat2str(list(H.values()))))
s7, c7 = tdm(E5, log=True)
print("  construída: %s" % " ".join(c7))
mostra("TDM", s7, E5)
mostra("Johnson", johnson_m(E5), E5)
ok &= c7 == list("4132") and s7 == list("2314") and cmax(s7, E5) == 54 and cmax(johnson_m(E5), E5) == 51

# ------------------------------------------------------------ Exemplo 8
E8 = tabela([[7, 8, 10, 9, 7], [5, 6, 4, 5, 7], [12, 10, 7, 8, 11]])
verif, info = condicao(E8)
G, H = reduz(E8)
print("\nExemplo 8: condição %s (min M1 = %d, min M3 = %d, máx. M2 = %d); G = %s, H = %s"
      % ("verifica-se" if verif else "falha", info[0], info[1], info[2],
         mat2str(list(G.values())), mat2str(list(H.values()))))
s8, c8 = tdm(E8, log=True)
print("  construída: %s" % " ".join(c8))
mostra("TDM", s8, E8)
mostra("Johnson", johnson_m(E8), E8)
print("  força bruta: ótimo = %d" % forca_bruta(E8)[0][0])
ok &= verif and info == (7, 7, 7) and c8 == list("34215") and s8 == list("51243") and cmax(s8, E8) == 62
ok &= johnson_m(E8) == list("12543") and cmax(johnson_m(E8), E8) == 60 and forca_bruta(E8)[0][0] == 60

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
