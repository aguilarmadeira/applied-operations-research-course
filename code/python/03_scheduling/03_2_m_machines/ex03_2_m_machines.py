"""Reproduz os exemplos do deck 3.2 (três ou mais máquinas).

Gráfica com corte (impressão, corte, acabamento): min M1 = 3 >= máx. M2 = 3, a condição verifica-se;
G = (10, 14, 6, 5, 7, 11), H = (11, 8, 3, 7, 15, 10); Johnson D, E, A, F, B, C com T = 47 h
(ociosos 6, 35, 5); pela ordem de chegada 55 h; força bruta: mínimo 47 h.
Semana da plastificação: a condição falha (máx. M2 = 9, min M1 = 2, min M3 = 3);
Johnson «à força» 1, 3, 4, 2 com T = 39; ótimo (24 sequências) 3, 2, 4, 1 com T = 35.
Para resolver na aula: Exemplos 3 (T = 51), 4 (T = 52) e 5 (cinco máquinas, T = 51).
(A experiência com 500 problemas aleatórios está em ../03_3_tdm/experiencia_aleatoria.py.)

Correr (de qualquer pasta):  python ex03_2_m_machines.py

Complementos de IO — deck 3.2.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

import numpy as np

from sequenciamento import tempos, cmax, ocios, forca_bruta
from m_maquinas import reduz, condicao, johnson_m


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


def analisa(titulo, linhas, nomes=None):
    """Condição, (G, H) e Johnson para a tabela linhas (uma linha por máquina)."""
    n = len(linhas[0])
    nomes = nomes or [str(k + 1) for k in range(n)]
    P = {nomes[k]: tuple(l[k] for l in linhas) for k in range(n)}
    verif, (m1, mm, meio) = condicao(P)
    G, H = reduz(P)
    print("\n" + titulo)
    print("  condição: min M1 = %d, min M%d = %d, máx. das intermédias = %d -> %s"
          % (m1, len(linhas), mm, meio, "verifica-se" if verif else "falha"))
    print("  G = %s,  H = %s" % (mat2str(list(G.values())), mat2str(list(H.values()))))
    s = johnson_m(P)
    mostra("Johnson", s, P)
    return P, verif, G, H, s


ok = True
print("Complementos de IO — deck 3.2: três ou mais máquinas")

# ------------------------------------------------------------ gráfica com corte
P, verif, G, H, s = analisa("Gráfica com corte (impressão, corte, acabamento)",
                            [[8, 11, 5, 3, 4, 10], [2, 3, 1, 2, 3, 1], [9, 5, 2, 5, 12, 9]], list("ABCDEF"))
mostra("ordem de chegada", list(P), P)
bf = forca_bruta(P)
print("  força bruta: mínimo das %d sequências = %d" % (len(bf), bf[0][0]))
ok &= verif and condicao(P)[1] == (3, 2, 3)
ok &= list(G.values()) == [10, 14, 6, 5, 7, 11] and list(H.values()) == [11, 8, 3, 7, 15, 10]
ok &= s == list("DEAFBC") and cmax(s, P) == 47 and ocios(s, P) == [6, 35, 5]
ok &= cmax(list(P), P) == 55 and bf[0][0] == 47

# ------------------------------------------------------------ plastificação: a condição falha
Q, verif, G, H, s = analisa("Semana da plastificação (impressão, plastificação, acabamento)",
                            [[2, 7, 2, 4], [4, 8, 9, 8], [3, 8, 7, 5]])
bf = forca_bruta(Q)
otimas = [q for v, q in bf if v == bf[0][0]]
print("  força bruta (%d sequências): ótimo %s" % (len(bf), ", ".join(otimas)))
mostra("ótimo", list(otimas[0]), Q)
ok &= not verif and condicao(Q)[1] == (2, 3, 9)
ok &= list(G.values()) == [6, 15, 11, 12] and list(H.values()) == [7, 16, 16, 13]
ok &= s == list("1342") and cmax(s, Q) == 39 and otimas == ["3241"] and bf[0][0] == 35

# ------------------------------------------------------------ para resolver na aula
P3, v3, G3, H3, s3 = analisa("Exemplo 3", [[8, 10, 6, 7, 11], [5, 6, 2, 3, 4], [4, 9, 8, 6, 5]])
P4, v4, G4, H4, s4 = analisa("Exemplo 4", [[6, 7, 9, 10, 6], [5, 6, 4, 3, 4], [11, 10, 6, 7, 8]])
P5, v5, G5, H5, s5 = analisa("Exemplo 5 (cinco máquinas)",
                             [[7, 6, 5, 8], [5, 6, 4, 3], [2, 4, 5, 3], [3, 5, 6, 2], [9, 10, 8, 6]])
ok &= v3 and condicao(P3)[1] == (6, 4, 6) and s3 == list("32145") and cmax(s3, P3) == 51
ok &= ocios(s3, P3) == [9, 31, 19]
ok &= v4 and condicao(P4)[1] == (6, 6, 6) and s4 == list("51234") and cmax(s4, P4) == 52
ok &= ocios(s4, P4) == [14, 30, 10]
ok &= v5 and condicao(P5)[1] == (5, 6, 6) and s5 == list("1324") and cmax(s5, P5) == 51
ok &= list(G5.values()) == [17, 21, 20, 16] and list(H5.values()) == [19, 25, 23, 14]
ok &= ocios(s5, P5) == [25, 33, 37, 35, 18]

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
