function s = Revenda(S, n)
%REVENDA  Valor de revenda no fim do ano n.
%
%   s = Revenda(S, n)
%   S: vetor com a revenda no fim de cada ano (s = S(n)) ou um valor de sucata fixo (s = S).
%
%   Complementos de IO — deck 4.1.  J. F. A. Madeira — Licença MIT.
if isscalar(S)
  s = S;
else
  s = S(n);
end
end
