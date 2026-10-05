function res = SimulaMm1k(lam, mu, K, n, seed)
%SIMULAMM1K  Simulação do M/M/1/K com bloqueio: quem chega com o sistema cheio (K) desiste.
%
%   res = SimulaMm1k(lam, mu, K)
%   res = SimulaMm1k(lam, mu, K, n, seed)      (por omissão 200000 chegadas, semente 1)
%   Por cada chegada (rng(seed)) sorteia-se o intervalo desde a anterior e, se entrar,
%   o seu tempo de serviço (-log(rand)/taxa).
%   res.PK (fração de perdidos) e res.W (tempo médio no sistema de quem entra).
%   O gerador do MATLAB/Octave não é o do numpy: os números não são os do Python.
%
%   Complementos de IO — deck 6.2.  J. F. A. Madeira — Licença MIT.
if nargin < 4, n = 200000; end
if nargin < 5, seed = 1; end
rng(seed);
t = 0;
fila = zeros(1, 0);                   % instantes de saída de quem está no sistema
perdidos = 0;
soma = 0;  entram = 0;
for i = 1:n
  t = t - log(rand) / lam;
  fila = fila(fila > t);
  if numel(fila) >= K
    perdidos = perdidos + 1;
    continue
  end
  if isempty(fila), ini = t; else, ini = max(t, fila(end)); end
  sai = ini - log(rand) / mu;
  fila(end + 1) = sai; %#ok<AGROW>
  soma = soma + (sai - t);  entram = entram + 1;
end
res = struct('PK', perdidos / n, 'W', soma / entram);
end
