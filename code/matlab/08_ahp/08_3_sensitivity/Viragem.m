function p = Viragem(M, w, k, i, j)
%VIRAGEM  Peso do critério k em que as alternativas i e j empatam.
%
%   p = Viragem(M, w, k, i, j)
%   As pontuações são retas em p: S(p) = S(0) + p (M(:, k) - S(0)); com d0 = S_i(0) - S_j(0)
%   e d1 = M(i, k) - M(j, k), o empate é em p* = d0 / (d0 - d1).
%   Devolve [] se não houver empate em [0, 1].
%
%   Complementos de IO — deck 8.3.  J. F. A. Madeira — Licença MIT.
s0 = Agrega(M, PesosCom(w, k, 0));
d0 = s0(i) - s0(j);
d1 = M(i, k) - M(j, k);
p = [];
if abs(d1 - d0) < 1e-15, return; end
q = d0 / (d0 - d1);
if q >= 0 && q <= 1, p = q; end
end
