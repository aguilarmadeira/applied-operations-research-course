function [melhor, sols] = ForcaBruta01(w, v, W)
%FORCABRUTA01  Força bruta da mochila 0-1: valor ótimo e todas as soluções ótimas.
%
%   [melhor, sols] = ForcaBruta01(w, v, W)
%   sols tem uma linha de 0 e 1 por solução ótima.
%
%   Complementos de IO — deck 5.2.  J. F. A. Madeira — Licença MIT.
n = numel(w);
melhor = -Inf;  sols = zeros(0, n);
for c = 0:2^n - 1
  m = dec2bin(c, n) - '0';                % todas as combinações, pela ordem lexicográfica
  if sum(m .* w) <= W
    val = sum(m .* v);
    if val > melhor
      melhor = val;  sols = m;
    elseif val == melhor
      sols(end+1, :) = m; %#ok<AGROW>
    end
  end
end
end
