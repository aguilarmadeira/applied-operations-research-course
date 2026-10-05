function T = Atraso(seq, p, d)
%ATRASO  Atraso total numa máquina: soma de max(0, C_j - d_j).
%
%   T = Atraso(seq, p, d)
%   p, d: tempos de processamento e prazos; seq: índices dos trabalhos, pela ordem de processamento.
%
%   Complementos de IO — deck 3.4.  J. F. A. Madeira — Licença MIT.
p = p(:)';  d = d(:)';
C = cumsum(p(seq));
T = sum(max(0, C - d(seq)));
end
