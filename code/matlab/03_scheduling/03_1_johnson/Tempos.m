function C = Tempos(seq, P)
%TEMPOS  Instantes de conclusão de uma sequência em máquinas em série.
%
%   C = Tempos(seq, P)
%   P: matriz n x m (linha j = tempos do trabalho j nas máquinas 1..m);
%   seq: vetor com os índices dos trabalhos, pela ordem de processamento.
%   C(k, i) = instante em que o k-ésimo trabalho de seq sai da máquina i.
%   Cada trabalho entra numa máquina quando sai da anterior e a máquina fica livre:
%   C_i <- max(C_i, C_(i-1)) + tempo do trabalho na máquina i.
%
%   Complementos de IO — deck 3.1.  J. F. A. Madeira — Licença MIT.
m = size(P, 2);
f = zeros(1, m);                 % instante em que cada máquina fica livre
C = zeros(numel(seq), m);
for k = 1:numel(seq)
  j = seq(k);
  for i = 1:m
    if i > 1, antes = f(i-1); else, antes = 0; end
    f(i) = max(f(i), antes) + P(j, i);
  end
  C(k, :) = f;
end
end
