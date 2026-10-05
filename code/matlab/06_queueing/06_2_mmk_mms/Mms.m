function m = Mms(lam, mu, s)
%MMS  M/M/s em regime estacionário (exige rho = lam/(s mu) < 1).
%
%   m = Mms(lam, mu, s)
%   m.a, m.rho, m.P0, m.Pw (P(esperar), fórmula C de Erlang), m.Lq, m.Wq, m.W, m.L
%   e m.Pn (função de n).
%   a = lam/mu; P0 = [sum_{n<s} a^n/n! + a^s/(s! (1 - rho))]^(-1);
%   Pw = a^s/(s! (1 - rho)) P0; Lq = Pw rho/(1 - rho); Wq = Lq/lam, W = Wq + 1/mu, L = Lq + a.
%
%   Complementos de IO — deck 6.2.  J. F. A. Madeira — Licença MIT.
a = lam / mu;
r = a / s;
if r >= 1, error('instável'); end
P0 = 1 / (sum(a .^ (0:s-1) ./ factorial(0:s-1)) + a ^ s / (factorial(s) * (1 - r)));
Pw = a ^ s / factorial(s) * P0 / (1 - r);         % P(esperar) = P(j >= s) (Erlang C)
Lq = Pw * r / (1 - r);
Wq = Lq / lam;
m = struct('a', a, 'rho', r, 'P0', P0, 'Pw', Pw, 'Lq', Lq, 'Wq', Wq, 'W', Wq + 1 / mu, 'L', Lq + a);
m.Pn = @(n) P0 * a .^ n ./ (factorial(min(n, s)) .* s .^ max(n - s, 0));
end
