function m = Mm1(lam, mu)
%MM1  Medidas do M/M/1 em regime estacionário (exige rho = lam/mu < 1).
%
%   m = Mm1(lam, mu)
%   lam: taxa média de chegadas; mu: taxa média de serviço (mesma unidade de tempo).
%   m.rho, m.P0, m.L, m.Lq, m.W, m.Wq e m.Pn (função de n: m.Pn(n) = (1 - rho) rho^n).
%   P0 = 1 - rho, L = rho/(1 - rho), Lq = rho^2/(1 - rho), W = 1/(mu - lam), Wq = lam/(mu (mu - lam)).
%
%   Complementos de IO — deck 6.1.  J. F. A. Madeira — Licença MIT.
r = lam / mu;
if r >= 1, error('instável: lambda >= mu'); end
m = struct('rho', r, 'P0', 1 - r, 'L', r / (1 - r), 'Lq', r * r / (1 - r), ...
           'W', 1 / (mu - lam), 'Wq', lam / (mu * (mu - lam)));
m.Pn = @(n) (1 - r) * r .^ n;
end
