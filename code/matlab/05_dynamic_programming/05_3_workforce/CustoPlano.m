function [total, custos] = CustoPlano(b, ce, cf, cv, xs, x0)
%CUSTOPLANO  Custo de um plano de mão-de-obra dado.
%
%   [total, custos] = CustoPlano(b, ce, cf, cv, xs, x0)
%   xs: operários em cada semana; x0: operários antes da semana 1 (por omissão 0).
%   custos(t) = ce (x_t - b_t) + [x_t > x_{t-1}] (cf + cv (x_t - x_{t-1})); total = soma.
%
%   Complementos de IO — deck 5.3.  J. F. A. Madeira — Licença MIT.
if nargin < 6, x0 = 0; end
custos = zeros(1, numel(xs));  s = x0;
for t = 1:numel(xs)
  x = xs(t);
  custos(t) = ce*(x - b(t)) + (x > s)*(cf + cv*(x - s));
  s = x;
end
total = sum(custos);
end
