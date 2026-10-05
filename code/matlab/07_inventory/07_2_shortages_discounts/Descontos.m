function [linhas, melhor] = Descontos(D, Ce, I, escaloes)
%DESCONTOS  Descontos de quantidade: QEE por escalão, ajustada, e custo total com a compra.
%
%   [linhas, melhor] = Descontos(D, Ce, I, escaloes)
%   escaloes: uma linha [q_min q_max preço] por escalão; I: taxa de posse (Cp = I x preço).
%   linhas: estrutura (uma por escalão) com lo, hi, Ca (preço), Q (QEE), Qf (Q usado) e K (custo total);
%   melhor: a linha de menor custo total.
%
%   Complementos de IO — deck 7.2.  J. F. A. Madeira — Licença MIT.
linhas = struct('lo', {}, 'hi', {}, 'Ca', {}, 'Q', {}, 'Qf', {}, 'K', {});
for j = 1:size(escaloes, 1)
  lo = escaloes(j, 1);  hi = escaloes(j, 2);  Ca = escaloes(j, 3);
  Cp = I * Ca;
  Q = sqrt(2 * D * Ce / Cp);
  Qf = min(max(Q, lo), hi);
  linhas(j) = struct('lo', lo, 'hi', hi, 'Ca', Ca, 'Q', Q, 'Qf', Qf, 'K', D * Ca + D * Ce / Qf + Qf / 2 * Cp);
end
[~, k] = min([linhas.K]);
melhor = linhas(k);
end
