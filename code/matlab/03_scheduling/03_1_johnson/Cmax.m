function T = Cmax(seq, P)
%CMAX  Tempo total (makespan) de uma sequência.
%
%   T = Cmax(seq, P)
%   Instante em que o último trabalho de seq sai da última máquina (0 se seq for vazia).
%   P: matriz n x m de tempos (linha = trabalho, coluna = máquina).
%
%   Complementos de IO — deck 3.1.  J. F. A. Madeira — Licença MIT.
if isempty(seq)
  T = 0;
else
  C = Tempos(seq, P);
  T = C(end, end);
end
end
