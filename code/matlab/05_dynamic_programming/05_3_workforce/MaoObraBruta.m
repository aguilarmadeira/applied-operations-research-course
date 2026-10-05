function [melhor, planos] = MaoObraBruta(b, ce, cf, cv, x0)
%MAOOBRABRUTA  Força bruta da gestão da mão-de-obra: percorre todos os planos com b_t <= x_t <= max(b).
%
%   [melhor, planos] = MaoObraBruta(b, ce, cf, cv, x0)
%   melhor: custo mínimo; planos: uma linha por plano ótimo. x0 por omissão 0.
%
%   Complementos de IO — deck 5.3.  J. F. A. Madeira — Licença MIT.
if nargin < 5, x0 = 0; end
n = numel(b);  M = max(b);
xs = b;                                   % primeiro plano
melhor = Inf;  planos = zeros(0, n);
while true
  c = CustoPlano(b, ce, cf, cv, xs, x0);
  if c < melhor
    melhor = c;  planos = xs;
  elseif c == melhor
    planos(end+1, :) = xs; %#ok<AGROW>
  end
  j = n;                                  % próximo plano (a última semana varia mais depressa)
  while j >= 1 && xs(j) == M
    xs(j) = b(j);  j = j - 1;
  end
  if j < 1, break; end
  xs(j) = xs(j) + 1;
end
end
