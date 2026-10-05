function [P, verificacao] = ProbRazoes(m, razoes)
%PROBRAZOES  Probabilidades subjetivas pelo método direto (vantagens relativas).
%
%   [P, verificacao] = ProbRazoes(m, razoes)
%   razoes: uma linha [i k r] por resposta, com P(theta_i) / P(theta_k) = r (índices a partir de 1).
%   As primeiras m - 1 razões, mais sum P = 1, determinam P (têm de ligar os m estados).
%   As razões a mais verificam a coerência: verificacao tem uma linha
%   [i k r_dada r_implicita coerente] por cada uma.
%
%   Complementos de IO — deck 1.4.  J. F. A. Madeira — Licença MIT.
if size(razoes, 1) < m - 1
  error('são precisas pelo menos m - 1 razões');
end
A = zeros(m);  y = zeros(m, 1);
for l = 1:m-1
  A(l, razoes(l,1)) = 1;  A(l, razoes(l,2)) = -razoes(l,3);     % P_i - r P_k = 0
end
A(m, :) = 1;  y(m) = 1;                                          % sum P = 1
P = (A \ y)';
verificacao = zeros(0, 5);
for l = m:size(razoes, 1)
  i = razoes(l,1);  k = razoes(l,2);  r = razoes(l,3);
  ri = P(i)/P(k);
  verificacao(end+1, :) = [i k r ri abs(ri - r) < 1e-9*max(1, r)]; %#ok<AGROW>
end
end
