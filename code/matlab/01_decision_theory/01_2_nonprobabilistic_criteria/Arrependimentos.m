function R = Arrependimentos(C, custos)
%ARREPENDIMENTOS  Matriz dos arrependimentos (r_ij >= 0).
%
%   R = Arrependimentos(C)        ganhos: r_ij = max_k c_kj - c_ij
%   R = Arrependimentos(C, true)  custos: r_ij = c_ij - min_k c_kj
%
%   Complementos de IO — deck 1.2.  J. F. A. Madeira — Licença MIT.
if nargin < 2, custos = false; end
if custos
  R = C - min(C, [], 1);
else
  R = max(C, [], 1) - C;
end
end
