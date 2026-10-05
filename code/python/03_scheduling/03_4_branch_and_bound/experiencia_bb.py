"""Experiência numérica do deck 3.4: quantos nós gera o branch and bound com 8 trabalhos?

100 problemas aleatórios (semente 5): 3 máquinas, tempo total (tempos de 1 a 20), e
1 máquina, atraso total (tempos de 1 a 10, prazos entre p_j e a soma dos tempos).
Slides (nós gerados até provar o ótimo): 3 máquinas — mediana 43, 90% 1257, máximo 5773;
1 máquina — mediana 123, 90% 432, máximo 1231.

Só em Python: usa o gerador do módulo random (Mersenne Twister do Python) com semente fixa;
o MATLAB/Octave não gera os mesmos problemas.
Correr (de qualquer pasta):  python experiencia_bb.py

Complementos de IO — deck 3.4.  J. F. A. Madeira — Licença MIT.
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import uc_setup  # noqa: F401,E402  (acrescenta as pastas do código da UC ao caminho)

import random
import statistics

from bb_sequenciamento import bb_fs, bb_atraso

print("Complementos de IO — deck 3.4: nós gerados pelo branch and bound (100 problemas, 8 trabalhos)")
random.seed(5)
nf, na = [], []
for _ in range(100):
    Q = {chr(65 + i): tuple(random.randint(1, 20) for _ in range(3)) for i in range(8)}
    nf.append(len(bb_fs(Q)[1]))
    p = {chr(65 + i): random.randint(1, 10) for i in range(8)}
    S = sum(p.values())
    d = {j: random.randint(p[j], S) for j in p}
    na.append(len(bb_atraso(p, d)[1]))


def quantil(v, q):
    return sorted(v)[int(q * (len(v) - 1))]


res = {}
for nome, v in [("3 máquinas, tempo total", nf), ("1 máquina, atraso total", na)]:
    res[nome] = (statistics.median(v), quantil(v, 0.9), max(v))
    print("  %-24s mediana %5g   90%% %5d   máximo %5d" % ((nome,) + res[nome]))

ok = res["3 máquinas, tempo total"] == (43, 1257, 5773) and res["1 máquina, atraso total"] == (123, 432, 1231)
print("\nconfere com os slides: %s" % ("sim" if ok else "não"))
