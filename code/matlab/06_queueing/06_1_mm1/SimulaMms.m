function res = SimulaMms(lam, mu, s, n, seed, aquecimento)
%SIMULAMMS  Simulação de uma fila FIFO com s servidores, chegadas e serviços exponenciais.
%
%   res = SimulaMms(lam, mu, s)
%   res = SimulaMms(lam, mu, s, n, seed, aquecimento)   (por omissão 200000, 1, 10000)
%   Gera n chegadas (rng(seed): primeiro os n intervalos entre chegadas, depois os n
%   tempos de serviço, com -log(rand)/taxa); cada cliente vai para o servidor que fica
%   livre primeiro. Descarta os primeiros «aquecimento» clientes (arranque).
%   res.Wq, res.W, res.Pw (P(esperar)) e res.p95 (quantil 95% da espera na fila,
%   interpolação linear como o numpy.quantile, sem a Statistics Toolbox).
%   Com s = 1 é o código do slide «Confirmar com simulação»; com s > 1 serve para o M/M/s.
%   O gerador do MATLAB/Octave não é o do numpy: os números não são os do slide.
%
%   Complementos de IO — deck 6.1.  J. F. A. Madeira — Licença MIT.
if nargin < 4, n = 200000; end
if nargin < 5, seed = 1; end
if nargin < 6, aquecimento = 10000; end
rng(seed);
cheg = cumsum(-log(rand(n, 1)) / lam);
serv = -log(rand(n, 1)) / mu;
livre = zeros(s, 1);                  % instante em que cada servidor fica livre
espera = zeros(n, 1);
for i = 1:n
  [~, k] = min(livre);
  ini = max(cheg(i), livre(k));
  espera(i) = ini - cheg(i);
  livre(k) = ini + serv(i);
end
e = espera(aquecimento + 1:end);
sv = serv(aquecimento + 1:end);
es = sort(e);
h = (numel(es) - 1) * 0.95 + 1;       % quantil 95% (interpolação linear)
j = floor(h);
p95 = es(j) + (h - j) * (es(min(j + 1, numel(es))) - es(j));
res = struct('Wq', mean(e), 'W', mean(e + sv), 'Pw', mean(e > 0), 'p95', p95);
end
