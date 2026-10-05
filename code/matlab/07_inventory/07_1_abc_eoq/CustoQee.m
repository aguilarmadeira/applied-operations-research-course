function K = CustoQee(Q, D, Ce, Cp, Ca)
%CUSTOQEE  Custo por período K(Q) = D Ca + D Ce / Q + Cp Q / 2 para um lote Q qualquer.
%
%   K = CustoQee(Q, D, Ce, Cp)      K = CustoQee(Q, D, Ce, Cp, Ca)   (Ca por omissão 0)
%
%   Complementos de IO — deck 7.1.  J. F. A. Madeira — Licença MIT.
if nargin < 5, Ca = 0; end
K = D * Ca + D * Ce ./ Q + Cp * Q / 2;
end
