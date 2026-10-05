function linhas = Gantt(acts, dur)
%GANTT  Diagrama de Gantt em texto, uma coluna por unidade de tempo (durações inteiras).
%
%   linhas = Gantt(acts)
%   linhas = Gantt(acts, dur)
%   acts: cell array com uma linha por atividade, {nome, {precedentes}, duração, ...};
%   dur:  vetor das durações (por omissão, a 3.ª coluna de acts).
%   '#' atividade crítica, '=' atividade com folga, '-' folga (de EF a LF), '.' livre.
%   linhas: cell array de linhas de texto (a primeira é a régua do tempo: 1, 2, ..., módulo 10).
%   Usa o CPM de 2.1 (Cpm.m).
%
%   Complementos de IO — deck 2.3.  J. F. A. Madeira — Licença MIT.
if nargin < 2, dur = []; end
[ES, EF, LS, LF, F, T] = Cpm(acts, dur);
T = round(T);
linhas = {['  tempo   ' sprintf('%d', mod(1:T, 10))]};
for i = 1:size(acts, 1)
  s = repmat('.', 1, T);
  if abs(F(i)) < 1e-9, c = '#'; else, c = '='; end
  s(ES(i) + 1:EF(i)) = c;
  s(EF(i) + 1:LF(i)) = '-';
  linhas{end+1} = sprintf('  %-7s %s', acts{i, 1}, s); %#ok<AGROW>
end
end
