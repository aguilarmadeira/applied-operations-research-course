function [melhor, sols] = SolucoesIlimitada(w, v, W)
%SOLUCOESILIMITADA  Força bruta da mochila ilimitada: valor ótimo e todas as soluções ótimas.
%
%   [melhor, sols] = SolucoesIlimitada(w, v, W)
%   sols tem uma linha por solução ótima, com o número de unidades de cada objeto.
%
%   Complementos de IO — deck 5.2.  J. F. A. Madeira — Licença MIT.
n = numel(w);
maximo = floor(W ./ w);
m = zeros(1, n);
melhor = -Inf;  sols = zeros(0, n);
while true
  if sum(m .* w) <= W
    val = sum(m .* v);
    if val > melhor
      melhor = val;  sols = m;
    elseif val == melhor
      sols(end+1, :) = m; %#ok<AGROW>
    end
  end
  j = n;                                  % próxima carga (o último objeto varia mais depressa)
  while j >= 1 && m(j) == maximo(j)
    m(j) = 0;  j = j - 1;
  end
  if j < 1, break; end
  m(j) = m(j) + 1;
end
end
