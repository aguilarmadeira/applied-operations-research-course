function [te, v, T, crit] = Pert(acts3)
%PERT  Tempos esperados, variâncias, duração esperada e caminho crítico do PERT.
%
%   [te, v, T, crit] = Pert(acts3)
%   acts3: cell array com uma linha por atividade, {nome, {precedentes}, to, tm, tp}.
%   te = (to + 4 tm + tp)/6 e v = ((tp - to)/6)^2 (vetores pela ordem das linhas);
%   T: duração esperada (CPM com os te); crit: índices das atividades críticas.
%   Usa o CPM de 2.1 (Cpm.m).
%
%   Complementos de IO — deck 2.2.  J. F. A. Madeira — Licença MIT.
to = cell2mat(acts3(:, 3))';  tm = cell2mat(acts3(:, 4))';  tp = cell2mat(acts3(:, 5))';
te = (to + 4*tm + tp)/6;
v = ((tp - to)/6).^2;
acts = [acts3(:, 1:2), num2cell(te(:))];
[~, ~, ~, ~, F, T] = Cpm(acts);
crit = find(abs(F) < 1e-9);
end
