function [T, D] = SimulaPert(acts3, N, semente)
%SIMULAPERT  Simulação do projeto: N sorteios das durações e CPM em cada sorteio.
%
%   [T, D] = SimulaPert(acts3)              N = 200000, semente 2026
%   [T, D] = SimulaPert(acts3, N, semente)
%   acts3: cell array com uma linha por atividade, {nome, {precedentes}, to, tm, tp}.
%   Sorteia as durações (Beta-PERT, independentes) e, em cada sorteio, calcula a
%   duração do projeto com a passagem para a frente do CPM.
%   T: vetor N x 1 das durações do projeto; D: matriz N x n das durações sorteadas.
%   Os números aleatórios do MATLAB/Octave não são os do numpy: os resultados só
%   coincidem com os da versão Python dentro do erro de simulação.
%
%   Complementos de IO — deck 2.2.  J. F. A. Madeira — Licença MIT.
if nargin < 2, N = 200000; end
if nargin < 3, semente = 2026; end
rng(semente);
n = size(acts3, 1);
nomes = acts3(:, 1)';
D = zeros(N, n);
for i = 1:n
  D(:, i) = BetaPert(acts3{i, 3}, acts3{i, 4}, acts3{i, 5}, N);
end
EF = zeros(N, n);
for i = Topo(acts3)
  p = find(ismember(nomes, acts3{i, 2}));
  if isempty(p), ES = zeros(N, 1); else, ES = max(EF(:, p), [], 2); end
  EF(:, i) = ES + D(:, i);
end
T = max(EF, [], 2);
end
