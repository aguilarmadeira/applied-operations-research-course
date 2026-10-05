function F = Simula(n, Pacum, T, runs, seed)
%SIMULA  Simulação de Monte Carlo das falhas por período com a política individual.
%
%   F = Simula(n, Pacum)                     T = 8 períodos, 4000 corridas, semente 1
%   F = Simula(n, Pacum, T, runs, seed)
%   Cada unidade recebe o período em que falha; quando falha no período t, é substituída por uma
%   nova no fim de t. F(t) é a média, nas corridas, do número de falhas no período t (estima N_t).
%   Semente fixa para resultados reprodutíveis. Os números aleatórios não são os do numpy:
%   os valores diferem um pouco dos da versão Python (e dos do slide), dentro do erro de simulação.
%
%   Complementos de IO — deck 4.3.  J. F. A. Madeira — Licença MIT.
if nargin < 3, T = 8; end
if nargin < 4, runs = 4000; end
if nargin < 5, seed = 1; end
rng(seed);                                   % semente fixa (MATLAB e Octave >= 7)
Pc = Pacum(:)';
amostra = @(m) 1 + sum(bsxfun(@gt, rand(m, 1), Pc), 2);   % período de falha de m unidades novas
F = zeros(1, T);
for corrida = 1:runs
  falha = amostra(n);                        % período da primeira falha de cada unidade
  for t = 1:T
    f = (falha == t);
    k = sum(f);
    F(t) = F(t) + k;
    falha(f) = t + amostra(k);               % substituída no fim de t
  end
end
F = F / runs;
end
