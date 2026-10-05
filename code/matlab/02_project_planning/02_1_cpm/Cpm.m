function [ES, EF, LS, LF, F, T] = Cpm(acts, dur)
%CPM  Método do caminho crítico: passagem para a frente e para trás.
%
%   [ES, EF, LS, LF, F, T] = Cpm(acts)
%   [ES, EF, LS, LF, F, T] = Cpm(acts, dur)
%   acts: cell array com uma linha por atividade, {nome, {precedentes}, duração, ...}
%   dur:  vetor das durações (por omissão, a 3.ª coluna de acts).
%   ES, EF, LS, LF, F (folga = LS - ES): vetores pela ordem das linhas de acts;
%   T = max EF (duração do projeto).
%
%   Complementos de IO — deck 2.1.  J. F. A. Madeira — Licença MIT.
if nargin < 2 || isempty(dur), dur = cell2mat(acts(:, 3))'; end
n = size(acts, 1);
nomes = acts(:, 1)';
o = Topo(acts);
ES = zeros(1, n);  EF = zeros(1, n);
for i = o                                  % para a frente: ES = max EF dos precedentes
  p = find(ismember(nomes, acts{i, 2}));
  if ~isempty(p), ES(i) = max(EF(p)); end
  EF(i) = ES(i) + dur(i);
end
T = max(EF);
succ = Sucessores(acts);
LS = zeros(1, n);  LF = zeros(1, n);
for i = fliplr(o)                          % para trás: LF = min LS dos sucessores
  if isempty(succ{i}), LF(i) = T; else, LF(i) = min(LS(succ{i})); end
  LS(i) = LF(i) - dur(i);
end
F = LS - ES;
end
