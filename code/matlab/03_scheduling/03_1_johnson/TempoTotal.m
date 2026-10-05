function c2 = TempoTotal(seq, a, b)
%TEMPOTOTAL  Tempo total com duas máquinas.
%
%   T = TempoTotal(seq, a, b)
%   a, b: vetores com os tempos nas máquinas 1 e 2; seq: índices dos trabalhos.
%   C1 <- C1 + a_j,  C2 <- max(C2, C1) + b_j.
%
%   Complementos de IO — deck 3.1.  J. F. A. Madeira — Licença MIT.
c1 = 0;  c2 = 0;
for j = seq
  c1 = c1 + a(j);
  c2 = max(c2, c1) + b(j);
end
end
