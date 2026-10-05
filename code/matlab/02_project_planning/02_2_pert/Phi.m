function p = Phi(z)
%PHI  Função de distribuição da normal reduzida: P(Z <= z), Z ~ N(0, 1).
%
%   p = Phi(z)
%
%   Complementos de IO — deck 2.2.  J. F. A. Madeira — Licença MIT.
p = 0.5*(1 + erf(z/sqrt(2)));
end
