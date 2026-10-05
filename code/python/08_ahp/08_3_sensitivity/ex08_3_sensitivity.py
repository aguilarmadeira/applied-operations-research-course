"""Reproduz os exemplos do deck 8.3 (análise de sensibilidade).

Carrinhas (8.1 e 8.2): fazendo variar o peso do custo, S(0) = (0.318, 0.455, 0.228) e S(1) = (0.332, 0.286, 0.382);
C passa A a p = 0.641 e passa B a p = 0.704 (d0 = 0.2267, d1 = -0.0955); com a autonomia, a carga ou a
assistência B fica em 1.º para qualquer peso.
Um juízo (a12 = 1, 2, 5, 9): B ganha sempre; com custo 7/9/9 face aos outros, C empata com B (0.3364 e 0.3365).
Todos os juízos (20 000 repetições, cada juízo sobe/desce um degrau ou fica): B em 100%; RC > 0.1 em 1.1%.
Para resolver na aula: Exemplo 6 (= Exemplo 5): margem 0.014 para F1; F2 passa F3 com o custo da MP acima
de 0.268 e com o transporte abaixo de 0.426; F3 em 89.9% das simulações.
Exemplo 7 (= Exemplo 3): F3 enquanto o rendimento pesar pelo menos 0.484; F3 em 100% das simulações.
As simulações usam semente fixa; a versão MATLAB usa outro gerador e dá frequências próximas, não iguais.

Correr (de qualquer pasta):  python ex08_3_sensitivity.py

Complementos de IO — deck 8.3.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

import numpy as np

from ahp import matriz, prioridades
from atributos import direto, indireto, agrega
from sensibilidade import pesos_com, sensibilidade, viragem, simula_juizos


def mat2str(A, casas=4):
    """Matriz/vetor arredondado, no formato do mat2str do MATLAB (para as saídas serem iguais)."""
    A = np.atleast_2d(np.round(np.asarray(A, float), casas) + 0.0)
    return "[" + ";".join(" ".join("%.15g" % x for x in linha) for linha in A) + "]"


def perto(x, v, tol):
    """x e v iguais a menos de tol (em todas as componentes)."""
    return bool(np.all(np.abs(np.asarray(x, float) - np.asarray(v, float)) <= tol))


def retas(M, w, k, nomes, ncrit):
    """Imprime S(0), S(1), as viragens do vencedor atual e o intervalo de p em que ele se mantém.
    Devolve (limite inferior, quem passa abaixo, limite superior, quem passa acima, {j: viragem})."""
    M = np.asarray(M, float)
    b = int(np.argmax(agrega(M, w)))
    s0 = agrega(M, pesos_com(w, k, 0))
    print("  %s (peso atual %.4f): S(0) = %s  S(1) = %s" % (ncrit, w[k], mat2str(s0), mat2str(M[:, k])))
    lo, qlo, hi, qhi, vir = 0.0, -1, 1.0, -1, {}
    for j in range(len(M)):
        if j == b:
            continue
        p = viragem(M, w, k, b, j)
        if p is None:
            continue
        vir[j] = p
        print("    %s–%s: d0 = %.4f  d1 = %.4f  p* = %.4f"
              % (nomes[b], nomes[j], s0[b] - s0[j], M[b, k] - M[j, k], p))
        if w[k] < p < hi:
            hi, qhi = p, j
        if lo < p < w[k]:
            lo, qlo = p, j
    if qlo < 0 and qhi < 0:
        print("    %s em 1.º para qualquer p em [0, 1]" % nomes[b])
    else:
        txt = "    %s em 1.º para p em [%.4f, %.4f]" % (nomes[b], lo, hi)
        if qlo >= 0:
            txt += "; abaixo passa %s" % nomes[qlo]
        if qhi >= 0:
            txt += "; acima passa %s" % nomes[qhi]
        print(txt)
    return lo, qlo, hi, qhi, vir


ok = True
print("Complementos de IO — deck 8.3: análise de sensibilidade")

# ------------------------------------------------------------ carrinhas: fazer variar um peso
C = matriz(4, {(0, 1): 2, (0, 2): 3, (0, 3): 5, (1, 2): 2, (1, 3): 3, (2, 3): 2})
S = matriz(3, {(0, 1): 1 / 3, (0, 2): 3, (1, 2): 5})
w = prioridades(C)[0]
M = np.column_stack([indireto([38000, 44000, 33000]), direto([220, 300, 160]), direto([900, 1000, 750]),
                     prioridades(S)[0]])
crit = ["custo", "autonomia", "carga", "assistência"]
print("\nCarrinhas: pontuação S = %s; pesos w = %s" % (mat2str(agrega(M, w)), mat2str(w)))
res = [retas(M, w, k, "ABC", crit[k]) for k in range(4)]
pBC, pCA = viragem(M, w, 0, 1, 2), viragem(M, w, 0, 2, 0)
print("  no custo: C passa A a p = %.4f (S = %s) e passa B a p = %.4f (S = %s)"
      % (pCA, mat2str(agrega(M, pesos_com(w, 0, pCA))), pBC, mat2str(agrega(M, pesos_com(w, 0, pBC)))))
grelha = np.linspace(0, 1, 11)
T = sensibilidade(M, w, 0, grelha)
print("  sensibilidade no peso do custo (o gráfico do slide):")
for p, linha in zip(grelha, T):
    print("    p = %.1f: A %.4f  B %.4f  C %.4f" % (p, linha[0], linha[1], linha[2]))
gfina = np.linspace(0, 1, 1001)
Bgrelha = gfina[sensibilidade(M, w, 0, gfina).argmax(1) == 1]
c = [perto(agrega(M, pesos_com(w, 0, 0)), [0.3177, 0.4545, 0.2278], 5e-5),
     perto(M[:, 0], [0.3317, 0.2864, 0.3819], 5e-5),
     perto(pBC, 0.704, 5e-4),
     perto(pCA, 0.641, 5e-4),
     res[0][2:4] == (pBC, 2) and res[0][1] == -1,
     all(r[1] == -1 and r[3] == -1 for r in res[1:]),
     perto(agrega(M, pesos_com(w, 0, pBC))[1:], [0.336, 0.336], 5e-4),
     perto(agrega(M, pesos_com(w, 0, pCA))[[0, 2]], [0.3266, 0.3266], 5e-5),
     perto(T[[0, -1]], [[0.3177, 0.4545, 0.2278], [0.3317, 0.2864, 0.3819]], 5e-5),
     Bgrelha.min() == 0 and perto(Bgrelha.max(), 0.703, 1e-9)]
ok &= all(c)

# ------------------------------------------------------------ um juízo: custo face a autonomia
print("\nUm juízo: a12 (custo face a autonomia; era 2)")
tab = []
for a in (1, 2, 5, 9):
    Ct = C.copy()
    Ct[0, 1], Ct[1, 0] = a, 1 / a
    wt, _, _, rct = prioridades(Ct)
    st = agrega(M, wt)
    tab.append([a, wt[0], rct, st[0], st[1], st[2]])
    print("  a12 = %d: w_custo = %.4f  RC = %.4f  S = %s -> %s" % (a, wt[0], rct, mat2str(st), "ABC"[int(np.argmax(st))]))
C7 = matriz(4, {(0, 1): 7, (0, 2): 9, (0, 3): 9, (1, 2): 2, (1, 3): 3, (2, 3): 2})
s7 = agrega(M, prioridades(C7)[0])
print("  custo 7, 9 e 9 vezes mais importante do que autonomia, carga e assistência: S = %s" % mat2str(s7))
tab = np.array(tab)
c = [perto(tab[:, 1:], [[0.4159, 0.0126, 0.3238, 0.3840, 0.2922], [0.4824, 0.0054, 0.3244, 0.3734, 0.3021],
                        [0.5562, 0.0665, 0.3252, 0.3615, 0.3133], [0.5887, 0.1583, 0.3256, 0.3561, 0.3182]], 5e-5),
     np.all(tab[:, 4] > tab[:, [3, 5]].max(1)),
     perto(s7[1:], [0.3364, 0.3365], 5e-5)]
ok &= all(c)

# ------------------------------------------------------------ todos os juízos: simulação
vit, inc = simula_juizos(C, M, {3: S})
print("\nTodos os juízos (20000 repetições, ±1 degrau na escala de Saaty, semente 1):")
print("  1.º lugar: A %.1f%%  B %.1f%%  C %.1f%%;  RC > 0.1 em %.1f%% das matrizes"
      % (100 * vit[0], 100 * vit[1], 100 * vit[2], 100 * inc))
c = [vit[1] >= 0.995, perto(inc, 0.011, 0.004)]       # frequências: tolerância de simulação
ok &= all(c)

# ------------------------------------------------------------ Exemplos 6 e 7: fornecedores
F4 = ["F1", "F2", "F3", "F4"]
critf = ["custo MP", "transporte", "tempo", "rendimento"]
J5 = {(0, 1): 1 / 3, (0, 2): 5, (0, 3): 1, (1, 2): 9, (1, 3): 3, (2, 3): 1 / 5}         # Exemplo 5 de 8.2
C5 = matriz(4, J5)
w5 = prioridades(C5)[0]
M5 = np.column_stack([indireto([11000, 7000, 15000, 12000]), indireto([1400, 1700, 1200, 1300]),
                      indireto([15, 13, 23, 18]), direto([3, 2.5, 3.5, 2])])
s5 = agrega(M5, w5)
o5 = np.argsort(-s5)
print("\nExemplo 6 (= Exemplo 5; 2.º teste, 27/06/2019): S = %s" % mat2str(s5))
print("  a) %s em 1.º, margem %.4f para %s" % (F4[o5[0]], s5[o5[0]] - s5[o5[1]], F4[o5[1]]))
r6 = [retas(M5, w5, k, F4, critf[k]) for k in range(3)]
vit6, _ = simula_juizos(C5, M5)
print("  simulação (±1 degrau): F3 em 1.º em %.1f%% das repetições" % (100 * vit6[2]))
c = [o5[0] == 2 and o5[1] == 0,
     perto(s5[2] - s5[0], 0.014, 5e-4),
     perto(agrega(M5, pesos_com(w5, 0, 0)), [0.2545, 0.2157, 0.2885, 0.2412], 5e-5),
     perto([r6[0][4][j] for j in (1, 0, 3)], [0.268, 0.350, 0.522], 5e-4),
     r6[0][2:4] == (r6[0][4][1], 1),
     perto(agrega(M5, pesos_com(w5, 1, 0)), [0.2569, 0.3015, 0.2391, 0.2025], 5e-5),
     perto([r6[1][4][j] for j in (1, 0)], [0.426, 0.303], 5e-4),
     r6[1][:2] == (r6[1][4][1], 1),
     perto(r6[2][2], 0.152, 5e-4) and r6[2][3] == 1,
     perto(vit6[2], 0.899, 0.01)]
ok &= all(c)

J3 = {(0, 1): 7, (0, 2): 5, (0, 3): 1 / 3, (1, 2): 1 / 3, (1, 3): 1 / 9, (2, 3): 1 / 7}  # Exemplo 3 de 8.2
C3 = matriz(4, J3)
w3 = prioridades(C3)[0]
M3 = np.column_stack([indireto([12000, 6000, 18000, 12000]), indireto([400, 600, 200, 800]),
                      indireto([15, 10, 20, 5]), direto([2, 1.5, 3, 1])])
s3 = agrega(M3, w3)
o3 = np.argsort(-s3)
print("\nExemplo 7 (= Exemplo 3; exame, 11/07/2019): S = %s; %s em 1.º, margem %.4f para %s"
      % (mat2str(s3), F4[o3[0]], s3[o3[0]] - s3[o3[1]], F4[o3[1]]))
r7 = [retas(M3, w3, k, F4, critf[k]) for k in (3, 0)]
vit7, _ = simula_juizos(C3, M3)
print("  simulação (±1 degrau): F3 em 1.º em %.1f%% das repetições" % (100 * vit7[2]))
c = [o3[0] == 2 and perto(s3[2] - s3[1], 0.035, 5e-4),
     perto(agrega(M3, pesos_com(w3, 3, 0)), [0.2055, 0.3606, 0.1732, 0.2607], 5e-5),
     perto([r7[0][4][j] for j in (1, 3, 0)], [0.484, 0.247, 0.195], 5e-4),
     r7[0][:2] == (r7[0][4][1], 1) and r7[0][3] == -1,
     perto(r7[1][2], 0.369, 5e-4) and r7[1][3] == 1,
     vit7[2] >= 0.995]
ok &= all(c)

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
