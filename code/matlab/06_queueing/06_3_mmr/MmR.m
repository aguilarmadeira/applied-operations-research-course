function m = MmR(K, R, lam, mu)
%MMR  M/M/R com população finita K (problema da reparação de máquinas); r = lam/mu.
%
%   m = MmR(K, R, lam, mu)
%   K máquinas (população = capacidade), R reparadores (os servidores);
%   lam = taxa de avaria de uma máquina a funcionar; mu = taxa de reparação de um reparador.
%   m.P (vetor P_0..P_K: m.P(n+1) = P_n), m.P0, m.L, m.Lq, m.a_funcionar, m.lef, m.W, m.Wq.
%   P_n = C(K, n) r^n P0 se n <= R;  P_n = C(K, n) n!/(R! R^(n-R)) r^n P0 se n > R;
%   L = sum n P_n (paradas), Lq = sum_{n>R} (n - R) P_n, lef = lam (K - L), W = L/lef, Wq = Lq/lef.
%   Não há condição de estabilidade (quem está avariado não volta a avariar).
%
%   Complementos de IO — deck 6.3.  J. F. A. Madeira — Licença MIT.
r = lam / mu;
w = zeros(1, K + 1);
for j = 0:K
  if j <= R
    w(j + 1) = nchoosek(K, j) * r ^ j;
  else
    w(j + 1) = nchoosek(K, j) * factorial(j) * r ^ j / (factorial(R) * R ^ (j - R));
  end
end
P0 = 1 / sum(w);
P = w * P0;
n = 0:K;
L = sum(n .* P);
Lq = sum(max(n - R, 0) .* P);
lef = lam * (K - L);
m = struct('P', P, 'P0', P0, 'L', L, 'Lq', Lq, 'a_funcionar', K - L, 'lef', lef, ...
           'W', L / lef, 'Wq', Lq / lef);
end
