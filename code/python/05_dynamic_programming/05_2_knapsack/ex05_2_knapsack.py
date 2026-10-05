"""Reproduz os exemplos do deck 5.2 (o problema da mochila).

Exemplo 1 (camião, 10 t, mochila ilimitada): paletes A (3 t, 7), B (4 t, 13), C (6 t, 17).
Tabela f(0..10) = 0, 0, 0, 7, 13, 13, 17, 20, 26, 26, 30; ótimo uma B e uma C, lucro 30
(única solução por força bruta); pelo rácio, B, B: 26.
Exemplo 2 (projetos, orçamento 10, mochila 0-1): custos 3, 5, 3, 4, 1; benefícios 12, 14, 15, 15, 8.
Tabela f_5..f_1; ótimo P1, P3, P4, benefício 42 (confirmado por milp); pelo rácio P5, P3, P1: 35.
Para resolver na aula: Exemplo 4 (navio): 62, duas unidades do produto 1 (rácio 61);
Exemplo 5: 19, 2A + B (rácio 18); Exemplo 6: 26, A + 2C (rácio 24).

No fim compara com os slides.
Correr (de qualquer pasta):  python ex05_2_knapsack.py

Complementos de IO — deck 5.2.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

import numpy as np

from mochila import mochila_ilimitada, solucoes_ilimitada, mochila_01, forca_bruta_01, regra_racio


def mat2str(A):
    """Matriz/vetor no formato do mat2str do MATLAB (para as saídas serem iguais)."""
    A = np.atleast_2d(np.asarray(A, float))
    return "[" + ";".join(" ".join("%.15g" % x for x in linha) for linha in A) + "]"


def mostra_ilimitada(titulo, w, v, W, nomes):
    """Tabela f(k), leitura da solução, força bruta e regra do rácio."""
    print("\n" + titulo)
    f, esc = mochila_ilimitada(w, v, W)
    for k in range(W + 1):
        cand = ", ".join("%s: %d+f(%d)=%d" % (nomes[i], v[i], k - w[i], v[i] + f[k - w[i]])
                         for i in range(len(w)) if w[i] <= k)
        quem = " (%s)" % " ou ".join(nomes[i] for i in esc[k]) if esc[k] else ""
        print("  k=%2d: %s -> f(%d) = %d%s" % (k, cand or "nada cabe", k, f[k], quem))
    k, leitura = W, []
    while esc[k]:                                     # ler a solução a partir de f(W)
        i = esc[k][0]
        leitura.append("pôr %s, restam %d" % (nomes[i], k - w[i]))
        k -= w[i]
    print("  leitura a partir de f(%d): %s" % (W, "; ".join(leitura)))
    melhor, sols = solucoes_ilimitada(w, v, W)
    print("  ótimo %d; soluções por força bruta (unidades de %s): %s" % (melhor, ", ".join(nomes), mat2str(sols)))
    vr, xr = regra_racio(w, v, W)
    print("  regra do rácio: %s, valor %d" % (mat2str(xr), vr))
    return f, melhor, sols, vr


ok = True
print("Complementos de IO — deck 5.2: o problema da mochila")

# ------------------------------------------------------------ Exemplo 1: camião (ilimitada)
f, melhor, sols, vr = mostra_ilimitada("Exemplo 1: carregar um camião, 10 t (mochila ilimitada)",
                                       [3, 4, 6], [7, 13, 17], 10, ["A", "B", "C"])
ok &= f == [0, 0, 0, 7, 13, 13, 17, 20, 26, 26, 30] and sols == [(0, 1, 1)] and vr == 26

# ------------------------------------------------------------ Exemplo 2: projetos (0-1)
w, v, W = [3, 5, 3, 4, 1], [12, 14, 15, 15, 8], 10
P = ["P1", "P2", "P3", "P4", "P5"]
print("\nExemplo 2: escolher projetos, orçamento 10 (mochila 0-1)")
valor, x, F = mochila_01(w, v, W, tabela=True)
for i in range(len(w) - 1, -1, -1):
    print("  f_%d: %s" % (i + 1, mat2str(F[i])))
k = W
for i in range(len(w)):                               # ler a solução para a frente
    if w[i] <= k:
        print("  %s: não f_%d(%d) = %d, sim %d+f_%d(%d) = %d -> %s"
              % (P[i], i + 2, k, F[i + 1][k], v[i], i + 2, k - w[i], v[i] + F[i + 1][k - w[i]],
                 "sim" if x[i] else "não"))
    else:
        print("  %s: não cabe" % P[i])
    k -= w[i] * x[i]
print("  ótimo %d com x = %s (custo %d)" % (valor, mat2str(x), sum(a * b for a, b in zip(w, x))))
melhor01, sols01 = forca_bruta_01(w, v, W)
print("  força bruta: %d com %s" % (melhor01, mat2str(sols01)))
vr01, xr01 = regra_racio(w, v, W, ilimitada=False)
print("  regra do rácio: %s, valor %d" % (mat2str(xr01), vr01))
try:                                                  # confirmação por programação linear inteira
    from scipy.optimize import milp, LinearConstraint
    r = milp(-np.array(v), constraints=LinearConstraint(np.array(w), 0, W),
             integrality=np.ones(len(w)), bounds=(0, 1))
    xm = np.round(r.x).astype(int)
    print("  milp (scipy): %g com %s" % (-r.fun, mat2str(xm)))
    ok &= abs(-r.fun - 42) < 1e-9 and xm.tolist() == [1, 0, 1, 1, 0]
except ImportError:
    print("  milp (scipy): scipy não está instalado; a força bruta confirma")
ok &= (valor == 42 and x == [1, 0, 1, 1, 0] and melhor01 == 42 and sols01 == [(1, 0, 1, 1, 0)]
       and vr01 == 35 and xr01 == [1, 0, 1, 0, 1]
       and F[4] == [0] + [8] * 10 and F[3] == [0, 8, 8, 8, 15, 23, 23, 23, 23, 23, 23]
       and F[2] == [0, 8, 8, 15, 23, 23, 23, 30, 38, 38, 38] and F[1] == F[2]
       and F[0] == [0, 8, 8, 15, 23, 23, 27, 35, 38, 38, 42])

# ------------------------------------------------------------ Para resolver na aula
_, m4, s4, r4 = mostra_ilimitada("Exemplo 4: o navio, 4 t", [2, 3, 1], [31, 47, 14], 4, ["1", "2", "3"])
_, m5, s5, r5 = mostra_ilimitada("Exemplo 5: mochila de 10 kg", [3, 4, 7], [6, 7, 10], 10, ["A", "B", "C"])
_, m6, s6, r6 = mostra_ilimitada("Exemplo 6: mochila de 13 kg", [3, 4, 5, 6], [6, 7, 10, 12], 13,
                                 ["A", "B", "C", "D"])
ok &= (m4, s4, r4) == (62, [(2, 0, 0)], 61) and (m5, s5, r5) == (19, [(2, 1, 0)], 18) \
    and (m6, s6, r6) == (26, [(1, 0, 2, 0)], 24)

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
