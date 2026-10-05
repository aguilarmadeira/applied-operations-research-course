function [p, vida, N] = Falhas(n, Pacum, T)
%FALHAS  Probabilidades de falha por período, vida média e falhas esperadas N_t (com renovação).
%
%   [p, vida, N] = Falhas(n, Pacum)       N_t para t = 1, ..., max(numel(p), 12)
%   [p, vida, N] = Falhas(n, Pacum, T)    N_t para t = 1, ..., max(numel(p), T)
%   Pacum: probabilidades acumuladas de uma unidade nova ter falhado até ao fim de cada período.
%   p_t = P(t) - P(t-1);  vida = soma t p_t;  N_t = n p_t + N_1 p_{t-1} + ... + N_{t-1} p_1.
%
%   Complementos de IO — deck 4.3.  J. F. A. Madeira — Licença MIT.
if nargin < 3, T = 12; end
Pacum = Pacum(:)';
p = [Pacum(1), Pacum(2:end) - Pacum(1:end-1)];
vida = 0;
for i = 1:numel(p)
  vida = vida + i * p(i);
end
m = max(numel(p), T);
Nc = [n, zeros(1, m)];               % Nc(1) = n: as unidades instaladas no instante 0
for t = 1:m
  s = 0;
  for k = 0:t-1
    if t - k <= numel(p)
      s = s + Nc(k + 1) * p(t - k);
    end
  end
  Nc(t + 1) = s;
end
N = Nc(2:end);
end
