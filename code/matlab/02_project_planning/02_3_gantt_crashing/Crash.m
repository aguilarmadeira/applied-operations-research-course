function [declive, res] = Crash(acts, bonus)
%CRASH  Aceleração do projeto (crashing) por enumeração exata.
%
%   [declive, res] = Crash(acts)
%   [declive, res] = Crash(acts, bonus)
%   acts: cell array com uma linha por atividade, {nome, {precedentes}, DN, custo DN, DM, custo DM}
%         (DN: duração normal; DM: duração mínima; custo linear entre as duas).
%   declive: custo por unidade de tempo de cada atividade (0 se DN = DM).
%   res.T: durações possíveis do projeto (por ordem decrescente); para cada uma,
%   res.direto (custo direto mínimo), res.dur (uma linha com as durações das atividades)
%   e res.total = direto - bonus*(Tn - T), em que Tn é a duração normal.
%   Testa todas as combinações de durações inteiras entre DM e DN (a última atividade
%   varia mais depressa); em caso de empate fica a primeira encontrada. Só para redes pequenas.
%   Usa o CPM de 2.1 (Cpm.m).
%
%   Complementos de IO — deck 2.3.  J. F. A. Madeira — Licença MIT.
if nargin < 2, bonus = 0; end
n = size(acts, 1);
DN = cell2mat(acts(:, 3))';  cDN = cell2mat(acts(:, 4))';
DM = cell2mat(acts(:, 5))';  cDM = cell2mat(acts(:, 6))';
declive = zeros(1, n);
k = DN > DM;
declive(k) = (cDM(k) - cDN(k))./(DN(k) - DM(k));
Ts = zeros(1, 0);  custos = zeros(1, 0);  durs = zeros(0, n);
d = DM;
while true
  [~, ~, ~, ~, ~, T] = Cpm(acts, d);
  c = sum(cDN + declive.*(DN - d));
  j = find(Ts == T);
  if isempty(j)
    Ts(end+1) = T;  custos(end+1) = c;  durs(end+1, :) = d; %#ok<AGROW>
  elseif c < custos(j) - 1e-9
    custos(j) = c;  durs(j, :) = d;
  end
  i = n;                                   % próxima combinação (como um conta-quilómetros)
  while i >= 1 && d(i) == DN(i)
    d(i) = DM(i);
    i = i - 1;
  end
  if i < 1, break; end
  d(i) = d(i) + 1;
end
Tn = max(Ts);
[~, ord] = sort(Ts, 'descend');
res.T = Ts(ord);
res.direto = custos(ord);
res.dur = durs(ord, :);
res.total = custos(ord) - bonus*(Tn - Ts(ord));
end
