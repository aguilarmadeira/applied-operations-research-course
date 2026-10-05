"""Reproduz os exemplos do deck 8.1 (o AHP, comparações par a par e consistência).

Carrinhas elétricas: critérios custo, autonomia, carga e assistência, juízos 2, 3, 5, 2, 3, 2
=> pesos 0.482, 0.272, 0.158, 0.088; lambda_max = 4.015, IC = 0.0048, RC = 0.005 (coerente);
vetor próprio 0.4829, 0.2720, 0.1570, 0.0882.
Slide «Quando os juízos não batem certo»: com a13 = 1/2, RC = 0.173; o par custo–carga é o mais
afastado (0.40 e 2.49); com a13 = 3, RC = 0.005; com a13 = 1, RC = 0.069.
Assistência (A, B, C): 0.261, 0.633, 0.106, RC = 0.033.
Para resolver na aula: Exemplo 1 (frutos: 0.283, 0.643, 0.074, RC = 0.056) e
Exemplo 2 (emprego: pesos 0.094, 0.738, 0.168, RC = 0.012; A com 0.735).

Correr (de qualquer pasta):  python ex08_1_ahp.py

Complementos de IO — deck 8.1.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

import numpy as np

from ahp import matriz, prioridades


def mat2str(A, casas=4):
    """Matriz/vetor arredondado, no formato do mat2str do MATLAB (para as saídas serem iguais)."""
    A = np.atleast_2d(np.round(np.asarray(A, float), casas) + 0.0)
    return "[" + ";".join(" ".join("%.15g" % x for x in linha) for linha in A) + "]"


def perto(x, v, tol):
    """x e v iguais a menos de tol (em todas as componentes)."""
    return bool(np.all(np.abs(np.asarray(x, float) - np.asarray(v, float)) <= tol))


def passo_a_passo(A):
    """Imprime as contas do método das colunas e devolve (w, lambda_max, IC, RC)."""
    A = np.asarray(A, float)
    w, lam, IC, RC = prioridades(A)
    print("  somas das colunas: %s" % mat2str(A.sum(0)))
    print("  matriz normalizada: %s" % mat2str(A / A.sum(0)))
    print("  pesos w: %s" % mat2str(w))
    print("  Aw: %s" % mat2str(A @ w))
    print("  (Aw)_i/w_i: %s" % mat2str(A @ w / w))
    print("  lambda_max = %.4f  IC = %.4f  RC = %.4f -> %s"
          % (lam, IC, RC, "coerente" if RC < 0.1 else "incoerente"))
    return w, lam, IC, RC


ok = True
print("Complementos de IO — deck 8.1: o AHP, comparações par a par e consistência")

# ------------------------------------------------------------ carrinhas: pesos dos critérios
crit = ["custo", "autonomia", "carga", "assistência"]
C = matriz(4, {(0, 1): 2, (0, 2): 3, (0, 3): 5, (1, 2): 2, (1, 3): 3, (2, 3): 2})
print("\nCarrinhas: critérios custo, autonomia, carga, assistência")
w, lam, IC, RC = passo_a_passo(C)
wv, lamv, _, _ = prioridades(C, "vetor")
print("  vetor próprio: w = %s  lambda_max = %.4f" % (mat2str(wv), lamv))
c = [perto(C.sum(0), [2.033, 3.833, 6.5, 11], 5e-4),
     perto(C / C.sum(0), [[0.492, 0.522, 0.462, 0.455], [0.246, 0.261, 0.308, 0.273],
     [0.164, 0.130, 0.154, 0.182], [0.098, 0.087, 0.077, 0.091]], 5e-4),
     perto(w, [0.4824, 0.2718, 0.1575, 0.0883], 5e-5),
     perto(C @ w, [1.940, 1.093, 0.631, 0.354], 5e-4),
     perto(C @ w / w, [4.021, 4.021, 4.005, 4.011], 5e-4),
     perto(lam, 4.0145, 5e-5),
     perto(IC, 0.0048, 5e-5),
     perto(RC, 0.005, 5e-4),
     perto(wv, [0.4829, 0.2720, 0.1570, 0.0882], 5e-5),
     perto(lamv, 4.0145, 5e-5)]
ok &= all(c)

# ------------------------------------------------------------ juízo incoerente a13 = 1/2
Cm = C.copy()
Cm[0, 2], Cm[2, 0] = 1 / 2, 2
wm, lamm, _, RCm = prioridades(Cm)
R = Cm * wm[None, :] / wm[:, None]             # a_ij w_j / w_i (devia ser perto de 1)
pior, ip, jp = 0, 0, 0
for i in range(4):
    for j in range(i + 1, 4):
        if abs(np.log(R[i, j])) > pior:
            pior, ip, jp = abs(np.log(R[i, j])), i, j
print("\nJuízo incoerente a13 = 1/2 (os outros cinco iguais)")
print("  lambda_max = %.4f  RC = %.4f -> %s" % (lamm, RCm, "coerente" if RCm < 0.1 else "incoerente"))
print("  pesos w: %s" % mat2str(wm))
print("  a_ij w_j / w_i: %s" % mat2str(R, 2))
print("  par mais afastado de 1: %s–%s (%.2f e %.2f)" % (crit[ip], crit[jp], R[ip, jp], R[jp, ip]))
RCa = {}
for a in (3, 1):
    Ct = C.copy()
    Ct[0, 2], Ct[2, 0] = a, 1 / a
    RCa[a] = prioridades(Ct)[3]
print("  a13 = 3: RC = %.4f;  a13 = 1: RC = %.4f" % (RCa[3], RCa[1]))
c = [perto(lamm, 4.467, 5e-4),
     perto(RCm, 0.173, 5e-4),
     perto(wm, [0.343, 0.292, 0.276, 0.089], 5e-4),
     perto(R, [[1, 1.70, 0.40, 1.30], [0.59, 1, 1.89, 0.92], [2.49, 0.53, 1, 0.65],
           [0.77, 1.09, 1.54, 1]], 5e-3),
     (ip, jp) == (0, 2),
     perto(RCa[3], 0.005, 5e-4),
     perto(RCa[1], 0.069, 5e-4)]
ok &= all(c)

# ------------------------------------------------------------ assistência (critério qualitativo)
S = matriz(3, {(0, 1): 1 / 3, (0, 2): 3, (1, 2): 5})
ws, lams, ICs, RCs = prioridades(S)
print("\nAssistência (A, B, C): prioridades %s  lambda_max = %.4f  IC = %.4f  RC = %.4f"
      % (mat2str(ws), lams, ICs, RCs))
c = [perto(ws, [0.2605, 0.6333, 0.1062], 5e-5),
     perto(lams, 3.039, 5e-4),
     perto(ICs, 0.019, 5e-4),
     perto(RCs, 0.033, 5e-4)]
ok &= all(c)

# ------------------------------------------------------------ Exemplo 1: três frutos
F = matriz(3, {(0, 1): 1 / 3, (0, 2): 5, (1, 2): 7})   # F2 face a F1: 3; F1 face a F3: 5; F2 face a F3: 7
print("\nExemplo 1 (frutos F1, F2, F3)")
wf, lamf, ICf, RCf = passo_a_passo(F)
ordem = np.argsort(-wf)
print("  ordem: %s;  coerência perfeita pediria F2/F3 = 3 x 5 = 15 (o juízo foi 7)"
      % ", ".join("F%d" % (i + 1) for i in ordem))
c = [perto(F.sum(0), [4.2, 1.476, 13], 5e-4),
     perto(wf, [0.283, 0.643, 0.074], 5e-4),
     perto(F @ wf / wf, [3.062, 3.121, 3.013], 5e-4),
     perto(lamf, 3.066, 5e-4),
     perto(ICf, 0.033, 5e-4),
     perto(RCf, 0.056, 5e-4),
     list(ordem) == [1, 0, 2]]
ok &= all(c)

# ------------------------------------------------------------ Exemplo 2: duas propostas de emprego
E = [[1, 1 / 7, 1 / 2], [7, 1, 5], [2, 1 / 5, 1]]
print("\nExemplo 2 (emprego, propostas A e B)")
we, lame, ICe, RCe = passo_a_passo(E)
# salário como comparação coerente (B paga 2500/2000 = 1.25 vezes mais); critérios 2 e 3: A 3 e 5 vezes
Me = np.column_stack([prioridades(matriz(2, {(0, 1): 2000 / 2500}))[0],
                      prioridades(matriz(2, {(0, 1): 3}))[0],
                      prioridades(matriz(2, {(0, 1): 5}))[0]])
Se = Me @ we
print("  prioridades locais (linhas A, B; colunas salário, critério 2, critério 3): %s" % mat2str(Me))
print("  pontuação: A %.4f  B %.4f -> proposta %s" % (Se[0], Se[1], "AB"[int(np.argmax(Se))]))
print("  implícito c2/c3 = 7 x 1/2 = %.1f; o juízo foi 5" % (E[1][0] * E[0][2]))
c = [perto(np.sum(E, 0), [10, 1.343, 6.5], 5e-4),
     perto(we, [0.094, 0.738, 0.168], 5e-4),
     perto(lame, 3.014, 5e-4),
     perto(ICe, 0.007, 5e-4),
     perto(RCe, 0.012, 5e-4),
     perto(Me, [[0.444, 0.75, 0.833], [0.556, 0.25, 0.167]], 5e-4),
     perto(Se, [0.735, 0.265], 5e-4),
     np.argmax(Se) == 0]
ok &= all(c)

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
