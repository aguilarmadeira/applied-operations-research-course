"""Reproduz os exemplos do deck 8.2 (atributos quantitativos e agregação).

Carrinhas: custo indireto (38 000, 44 000, 33 000 €), autonomia direta (220, 300, 160 km), carga direta
(900, 1000, 750 kg) e assistência pelas comparações de 8.1 => prioridades locais 0.332, 0.286, 0.382 no custo, ...;
pontuações A 0.324, B 0.373, C 0.302 -> B. C ganha 0.046 no custo; B recupera 0.056 na autonomia e 0.047
na assistência. A normalização comprime: 0.382 / 0.286 = 44 000 / 33 000 = 1.33.
Filtro «autonomia >= 200 km» (sem C): A 0.471, B 0.529 -> B.
Para resolver na aula: fornecedores (custo da MP, transporte e tempo indiretos; rendimento direto)
Exemplo 3 (exame 11/07/2019): RC = 0.062, F3 com 0.3034, margem 0.035 para F2;
Exemplo 4 (2.º teste 01/06/2018): RC = 0.027, F3 com 0.344, margem 0.108 para F4;
Exemplo 5 (2.º teste 27/06/2019): RC = 0.012, F3 com 0.2649, margem só 0.014 para F1;
no Exemplo 5, os erros frequentes (régua trocada, transporte como direto, soma sem pesos) dão F2.

Correr (de qualquer pasta):  python ex08_2_attributes.py

Complementos de IO — deck 8.2.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

import numpy as np

from ahp import matriz, prioridades
from atributos import direto, indireto, agrega


def mat2str(A, casas=4):
    """Matriz/vetor arredondado, no formato do mat2str do MATLAB (para as saídas serem iguais)."""
    A = np.atleast_2d(np.round(np.asarray(A, float), casas) + 0.0)
    return "[" + ";".join(" ".join("%.15g" % x for x in linha) for linha in A) + "]"


def perto(x, v, tol):
    """x e v iguais a menos de tol (em todas as componentes)."""
    return bool(np.all(np.abs(np.asarray(x, float) - np.asarray(v, float)) <= tol))


ok = True
print("Complementos de IO — deck 8.2: atributos quantitativos e agregação")

# ------------------------------------------------------------ carrinhas
C = matriz(4, {(0, 1): 2, (0, 2): 3, (0, 3): 5, (1, 2): 2, (1, 3): 3, (2, 3): 2})   # de 8.1
S = matriz(3, {(0, 1): 1 / 3, (0, 2): 3, (1, 2): 5})                              # assistência, de 8.1
w = prioridades(C)[0]
custo, autonomia, carga = [38000, 44000, 33000], [220, 300, 160], [900, 1000, 750]
M = np.column_stack([indireto(custo), direto(autonomia), direto(carga), prioridades(S)[0]])
contrib = M * w
s = agrega(M, w)
print("\nCarrinhas A, B, C (colunas: custo ind., autonomia dir., carga dir., assistência)")
print("  custo: 10^5/v = %s (soma %.4f)" % (mat2str(1e5 / np.array(custo)), np.sum(1e5 / np.array(custo))))
print("  prioridades locais: %s" % mat2str(M))
print("  pesos w (8.1): %s" % mat2str(w))
print("  contribuições w_k p_ik: %s" % mat2str(contrib))
print("  pontuação S: %s -> carrinha %s" % (mat2str(s), "ABC"[int(np.argmax(s))]))
ganho_custo = contrib[2, 0] - contrib[1, 0]
ganho_aut = contrib[1, 1] - contrib[2, 1]
ganho_ass = contrib[1, 3] - contrib[2, 3]
print("  C ganha %.4f no custo; B recupera %.4f na autonomia e %.4f na assistência"
      % (ganho_custo, ganho_aut, ganho_ass))
print("  compressão: B custa mais %.0f%% do que C; prioridades no custo C/B = %.4f = 44000/33000"
      % (100 * (custo[1] / custo[2] - 1), M[2, 0] / M[1, 0]))
Mf = np.column_stack([indireto(custo[:2]), direto(autonomia[:2]), direto(carga[:2]),
                      prioridades(matriz(2, {(0, 1): 1 / 3}))[0]])
sf = agrega(Mf, w)
print("  filtro autonomia >= 200 km (sem C): A %.4f  B %.4f -> %s" % (sf[0], sf[1], "AB"[int(np.argmax(sf))]))
c = [perto(1e5 / np.array(custo), [2.632, 2.273, 3.030], 5e-4),
     perto(np.sum(1e5 / np.array(custo)), 7.935, 5e-4),
     perto(M, [[0.3317, 0.3235, 0.3396, 0.2605], [0.2864, 0.4412, 0.3774, 0.6333],
               [0.3819, 0.2353, 0.2830, 0.1062]], 5e-5),
     perto(contrib, [[0.1600, 0.0879, 0.0535, 0.0230], [0.1382, 0.1199, 0.0594, 0.0559],
                     [0.1842, 0.0640, 0.0446, 0.0094]], 5e-5),
     perto(s, [0.324, 0.373, 0.302], 5e-4),
     np.argmax(s) == 1,
     perto([ganho_custo, ganho_aut, ganho_ass], [0.046, 0.056, 0.047], 5e-4),
     perto(M[2, 0] / M[1, 0], 44000 / 33000, 1e-12),
     perto(sf, [0.471, 0.529], 5e-4)]
ok &= all(c)

# ------------------------------------------------------------ Exemplos 3, 4 e 5: fornecedores
# (nome, juízos C1..C4, custo MP, transporte, tempo, rendimento) e o esperado (notas do docente):
# (w, lambda_max, RC, S, índice do escolhido, margem, índice do 2.º)
casos = [
    ("Exemplo 3 (exame, 11/07/2019)",
     {(0, 1): 7, (0, 2): 5, (0, 3): 1 / 3, (1, 2): 1 / 3, (1, 3): 1 / 9, (2, 3): 1 / 7},
     [12000, 6000, 18000, 12000], [400, 600, 200, 800], [15, 10, 20, 5], [2, 1.5, 3, 1],
     ([0.2913, 0.0445, 0.0903, 0.5739], 4.168, 0.062, [0.2406, 0.2684, 0.3034, 0.1876], 2, 0.035, 1)),
    ("Exemplo 4 (2.º teste, 01/06/2018)",
     {(0, 1): 1 / 5, (0, 2): 3, (0, 3): 1, (1, 2): 7, (1, 3): 5, (2, 3): 1 / 3},
     [10000, 6000, 16000, 11000], [400, 700, 200, 300], [12, 10, 20, 15], [2.5, 2, 3, 1],
     ([0.1542, 0.6279, 0.0637, 0.1542], 4.074, 0.027, [0.2278, 0.1918, 0.3440, 0.2364], 2, 0.108, 3)),
    ("Exemplo 5 (2.º teste, 27/06/2019)",
     {(0, 1): 1 / 3, (0, 2): 5, (0, 3): 1, (1, 2): 9, (1, 3): 3, (2, 3): 1 / 5},
     [11000, 7000, 15000, 12000], [1400, 1700, 1200, 1300], [15, 13, 23, 18], [3, 2.5, 3.5, 2],
     ([0.2055, 0.5416, 0.0474, 0.2055], 4.033, 0.012, [0.2509, 0.2479, 0.2649, 0.2362], 2, 0.014, 0)),
]
for nome, juizos, mp, tr, te, re, esp in casos:
    Cf = matriz(4, juizos)
    wf, lamf, ICf, RCf = prioridades(Cf)
    Mf = np.column_stack([indireto(mp), indireto(tr), indireto(te), direto(re)])
    sf = agrega(Mf, wf)
    o = np.argsort(-sf)
    print("\n%s" % nome)
    print("  matriz dos critérios: %s" % mat2str(Cf))
    print("  somas das colunas: %s" % mat2str(Cf.sum(0)))
    print("  pesos w: %s" % mat2str(wf))
    print("  (Aw)_i/w_i: %s" % mat2str(Cf @ wf / wf))
    print("  lambda_max = %.4f  IC = %.4f  RC = %.4f -> %s"
          % (lamf, ICf, RCf, "coerente" if RCf < 0.1 else "incoerente"))
    print("  prioridades locais (linhas F1..F4; colunas MP, transp., tempo, rend.): %s" % mat2str(Mf))
    print("  pontuação S: %s -> F%d, margem %.4f para F%d"
          % (mat2str(sf), o[0] + 1, sf[o[0]] - sf[o[1]], o[1] + 1))
    w_e, lam_e, rc_e, s_e, b_e, m_e, seg_e = esp
    c = [perto(wf, w_e, 5e-5),
         perto(lamf, lam_e, 5e-4),
         perto(RCf, rc_e, 5e-4),
         perto(sf, s_e, 5e-5),
         o[0] == b_e,
         perto(sf[o[0]] - sf[o[1]], m_e, 5e-4),
         o[1] == seg_e]
    ok &= all(c)

# ------------------------------------------------------------ Exemplo 5: os erros frequentes mudam a escolha
nome, juizos, mp, tr, te, re, _ = casos[2]
Cf = matriz(4, juizos)
wf = prioridades(Cf)[0]
Mf = np.column_stack([indireto(mp), indireto(tr), indireto(te), direto(re)])
s_regua = agrega(Mf, prioridades(Cf.T)[0])                    # régua trocada: matriz transposta
Md = Mf.copy()
Md[:, 1] = direto(tr)
s_dir = agrega(Md, wf)                                        # transporte tratado como direto
s_soma = Mf.sum(1)                                            # somar sem ponderar
print("\nExemplo 5, erros frequentes:")
for rot, v in (("régua trocada", s_regua), ("transporte como direto", s_dir), ("soma sem pesos", s_soma)):
    print("  %s: S = %s -> F%d (%.4f)" % (rot, mat2str(v), np.argmax(v) + 1, v.max()))
c = [np.argmax(s_regua) == 1,
     perto(s_regua.max(), 0.305, 5e-4),
     np.argmax(s_dir) == 1,
     perto(s_dir.max(), 0.303, 5e-4),
     np.argmax(s_soma) == 1,
     perto(s_soma.max(), 1.119, 5e-4)]
ok &= all(c)

print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
