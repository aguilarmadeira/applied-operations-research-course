function m = Mm1k(lam, mu, K)
%MM1K  M/M/1/K: capacidade K (quem chega com o sistema cheio perde-se); rho pode ser >= 1.
%
%   m = Mm1k(lam, mu, K)
%   m.rho, m.P (vetor P_0..P_K: m.P(n+1) = P_n), m.P0, m.PK, m.L, m.Lq, m.lef, m.W, m.Wq.
%   P_n = (1 - rho) rho^n / (1 - rho^(K+1)) (P_n = 1/(K+1) se rho = 1);
%   lef = lam (1 - P_K) é a taxa de quem entra; W = L/lef, Wq = Lq/lef.
%
%   Complementos de IO — deck 6.2.  J. F. A. Madeira — Licença MIT.
r = lam / mu;
n = 0:K;
if abs(r - 1) < 1e-12
  P = ones(1, K + 1) / (K + 1);
else
  P = (1 - r) * r .^ n / (1 - r ^ (K + 1));
end
L = sum(n .* P);
Lq = sum((n(2:end) - 1) .* P(2:end));
lef = lam * (1 - P(K + 1));
m = struct('rho', r, 'P', P, 'P0', P(1), 'PK', P(K + 1), 'L', L, 'Lq', Lq, ...
           'lef', lef, 'W', L / lef, 'Wq', Lq / lef);
end
