function x = BetaPert(a, m, b, n)
%BETAPERT  n durações sorteadas de uma Beta-PERT com média (a + 4m + b)/6.
%
%   x = BetaPert(a, m, b, n)     (vetor coluna n x 1; por omissão n = 200000)
%   x = a + (b - a) X, X ~ Beta(1 + 4(m-a)/(b-a), 1 + 4(b-m)/(b-a)).
%   A Beta sorteia-se como G1/(G1 + G2), com G1, G2 Gama (GamaAleatoria.m), para não
%   precisar da Statistics Toolbox. Os números aleatórios não são os do numpy.
%
%   Complementos de IO — deck 2.2.  J. F. A. Madeira — Licença MIT.
if nargin < 4, n = 200000; end
if b == a                                  % duração certa
  x = a*ones(n, 1);
  return
end
al = 1 + 4*(m - a)/(b - a);
be = 1 + 4*(b - m)/(b - a);
g1 = GamaAleatoria(al, n);
g2 = GamaAleatoria(be, n);
x = a + (b - a)*g1./(g1 + g2);
end
