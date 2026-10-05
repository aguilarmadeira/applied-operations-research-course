"""Reproduz os exemplos do deck 4.1 (equipamentos que se desgastam, sem valor temporal do dinheiro).

Exemplo-guia: carrinha a gasóleo, P = 30000, C_n = 3000, ..., 12500, S_n = 22000, ..., 5000.
Custo médio anual mínimo A(5) = 8760: substituir ao fim de 5 anos; fundo achatado (A(4) e A(6) a cerca de 1%).
Regra: M_5 = 8400 < A(4) = 8850 (manter), M_6 = 9100 > A(5) = 8760 (substituir).
Duas máquinas: carrinha elétrica, P = 44000, mínimo 8316,67 aos 6 anos; a gasóleo com 3 anos troca-se
ao fim do 4.º ano (M_4 = 7900 < 8316,67, M_5 = 8400 > 8316,67). Código do slide «Em Python»: 5 8760.0.
Para resolver na aula: Exemplo 1 (7 anos, 1821,43), Exemplo 2 (6 anos, 6333,33) e
Exemplo 3 (duas máquinas: trocar A pela B no fim do ano 2 ou do ano 3; comprar agora a B).

Correr (de qualquer pasta):  python ex04_1_wear.py

Complementos de IO — deck 4.1.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

import numpy as np

from desgaste import custo_medio, custo_mais_um_ano, media, melhor, quando_trocar


def perto(a, b, tol=1e-9):
    """Verdadeiro se todos os valores de a estão a menos de tol dos de b (tolerância absoluta)."""
    return bool(np.max(np.abs(np.asarray(a, float) - np.asarray(b, float))) <= tol)


def fmt(v, f="%.2f"):
    """Valores separados por espaços, todos com o mesmo formato."""
    return " ".join(f % x for x in v)


def tabela(L):
    print("     n     C_n   soma C   P - S_n    total       A(n)")
    for n, c, soma, perda, tot, a in L:
        print("  %4d %7d %8d %9d %8d %10.2f" % (n, c, soma, perda, tot, a))


def mostra_troca(linhas, minimo):
    """Imprime a comparação de quando_trocar, ano a ano."""
    sinais = {"manter": "<", "indiferente": "=", "trocar": ">"}
    for k, M, dec in linhas:
        print("  %d.º ano da antiga: M = %d %s %.2f -> %s" % (k, M, sinais[dec], minimo, dec))


ok = True
print("Complementos de IO — deck 4.1: equipamentos que se desgastam")

# ------------------------------------------------------------ carrinha a gasóleo
P = 30000
C = [3000, 3600, 4400, 5400, 6400, 7600, 9800, 12500]
S = [22000, 17000, 13500, 11000, 9000, 7500, 6200, 5000]
print("\nCarrinha a gasóleo (P = 30000)")
L = media(P, C, S)
tabela(L)
b = melhor(L)
print("  substituir ao fim de %d anos: A = %.2f € por ano" % (b[0], b[5]))
perda = [(P - S[n - 1]) / n for n in range(1, 9)]
func = [L[n - 1][2] / n for n in range(1, 9)]
print("  perda de valor por ano: %s" % fmt(perda, "%.1f"))
print("  funcionamento por ano:  %s" % fmt(func, "%.1f"))
print("  fundo achatado: A(4) %+.2f%% e A(6) %+.2f%% em relação a A(5)"
      % (100 * (L[3][5] / L[4][5] - 1), 100 * (L[5][5] / L[4][5] - 1)))
for n in (4, 5):
    M = custo_mais_um_ano(C, S, n)
    print("  regra: M_%d = %d + %d = %d %s A(%d) = %.2f -> %s"
          % (n + 1, C[n], S[n - 1] - S[n], M, "<" if M < L[n - 1][5] else ">", n, L[n - 1][5],
             "manter" if M < L[n - 1][5] else "substituir"))
ok &= (b[0] == 5 and abs(b[5] - 8760) < 1e-9
       and perto([r[5] for r in L], [11000, 9800, 27500 / 3, 8850, 8760, 52900 / 6, 64000 / 7, 9712.5])
       and perto(perda, [8000, 6500, 5500, 4750, 4200, 3750, 3400, 3125])
       and abs(func[2] - 3666.67) < 0.01 and abs(func[6] - 5742.86) < 0.01
       and custo_mais_um_ano(C, S, 4) == 8400 and custo_mais_um_ano(C, S, 5) == 9100)

# ------------------------------------------------------------ duas máquinas: a elétrica
Pe = 44000
Ce = [1600, 1900, 2400, 3100, 4000, 5400, 7000, 9000]
Se = [32000, 25500, 21000, 17500, 14800, 12500, 10600, 9000]
Le = media(Pe, Ce, Se)
be = melhor(Le)
print("\nCarrinha elétrica (P = 44000)")
print("  A(n): %s" % fmt([r[5] for r in Le]))
print("  mínimo: %.2f € por ano, substituindo ao fim de %d anos" % (be[5], be[0]))
print("Gasóleo com 3 anos: trocar já pela elétrica?")
quando, linhas = quando_trocar(C, S, 3, be[5])
mostra_troca(linhas, be[5])
print("  -> manter a gasóleo e trocar ao fim do %d.º ano" % quando[0])
ok &= (be[0] == 6 and abs(be[5] - 8316.67) < 0.005 and quando == [4]
       and perto([r[5] for r in Le], [13600, 11000, 9633, 8875, 8440, 8317, 8400, 8675], 0.5))

# ------------------------------------------------------------ código do slide «Em Python»
A = custo_medio(P, C, S)
n = A.index(min(A)) + 1
print("\nComo no slide «Em Python»: %d %.1f" % (n, A[n - 1]))
ok &= n == 5 and A[n - 1] == 8760.0

# ------------------------------------------------------------ Para resolver na aula: Exemplos 1 e 2
for nome, Px, Cx, Sx, n_ok, a_ok in (
        ("Exemplo 1 (P = 7100, sucata 100)", 7100, [200, 350, 500, 700, 1000, 1300, 1700, 2100], 100, 7, 1821.43),
        ("Exemplo 2 (P = 24400, sucata 400)", 24400, [400, 1000, 1600, 2400, 3600, 5000, 6400, 8000], 400, 6, 6333.33)):
    Lx = media(Px, Cx, Sx)
    bx = melhor(Lx)
    print("\n%s" % nome)
    print("  A(n): %s" % fmt([r[5] for r in Lx]))
    print("  substituir ao fim de %d anos: A = %.2f" % (bx[0], bx[5]))
    ok &= bx[0] == n_ok and abs(bx[5] - a_ok) < 0.005

# ------------------------------------------------------------ Exemplo 3: duas máquinas, sem revenda
CA = [2000 + 10000 * k for k in range(8)]
CB = [3000 + 4000 * k for k in range(8)]
AA, AB = custo_medio(45000, CA), custo_medio(55000, CB)
bA, bB = melhor(media(45000, CA)), melhor(media(55000, CB))
print("\nExemplo 3 (duas máquinas, sem revenda)")
print("  A: A(n) = %s; mínimo %.2f aos %d anos" % (fmt(AA), bA[5], bA[0]))
print("  B: A(n) = %s; mínimo %.2f aos %d anos" % (fmt(AB), bB[5], bB[0]))
print("a) A em funcionamento (no 1.º ano); mais um ano de A custa C_{n+1}:")
q3, linhas = quando_trocar(CA, 0, 1, bB[5])
mostra_troca(linhas, bB[5])
print("  -> trocar A pela B no fim do ano %s" % " ou do ano ".join(str(k) for k in q3))
print("b) comprar agora: %s (%.2f contra %.2f)" % ("B" if bB[5] < bA[5] else "A", bB[5], bA[5]))
ok &= (bA[0] == 3 and bA[5] == 27000 and bB[0] == 5 and bB[5] == 22000 and q3 == [2, 3]
       and perto(AA[:5], [47000, 29500, 27000, 28250, 31000])
       and perto(AB[:7], [58000, 32500, 76000 / 3, 22750, 22000, 133000 / 6, 160000 / 7]))

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
