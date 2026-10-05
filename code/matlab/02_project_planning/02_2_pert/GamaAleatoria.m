function x = GamaAleatoria(k, n)
%GAMAALEATORIA  n valores de uma distribuição Gama de forma k > 0 e escala 1.
%
%   x = GamaAleatoria(k, n)      (vetor coluna n x 1)
%   Método de Marsaglia e Tsang (2000), só com rand e randn: serve para sortear
%   a Beta sem a Statistics Toolbox (betarnd, randg). Não existe na versão Python,
%   que usa rng.beta do numpy.
%
%   Complementos de IO — deck 2.2.  J. F. A. Madeira — Licença MIT.
if k < 1                                   % Gama(k) = Gama(k + 1) U^(1/k)
  x = GamaAleatoria(k + 1, n) .* rand(n, 1).^(1/k);
  return
end
d = k - 1/3;
c = 1/sqrt(9*d);
x = zeros(n, 1);
falta = (1:n)';
while ~isempty(falta)
  m = numel(falta);
  z = randn(m, 1);
  v = (1 + c*z).^3;
  u = rand(m, 1);
  aceita = v > 0;
  aceita(aceita) = log(u(aceita)) < 0.5*z(aceita).^2 + d - d*v(aceita) + d*log(v(aceita));
  x(falta(aceita)) = d*v(aceita);
  falta = falta(~aceita);
end
end
