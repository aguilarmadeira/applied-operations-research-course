function [seq, constr] = Tdm2(a, b, nomes, log)
%TDM2  Método do desvio de tempo (TDM), duas máquinas.
%
%   [seq, constr] = Tdm2(a, b)
%   [seq, constr] = Tdm2(a, b, nomes, log)
%   a, b: tempos nas máquinas 1 e 2; nomes: nomes dos trabalhos (só para log; por omissão '1', '2', ...);
%   log = true imprime a tabela de desvios e as entradas de cada iteração.
%   seq: sequência do TDM (índices); constr: sequência construída, antes da inversão.
%
%   Em cada iteração, só com os trabalhos por atribuir: células (0, 0) na máquina 1 entram pela
%   frente (a seguir às que já lá estão); na máquina 2 entram por trás (antes das que já lá estão).
%   Desempate (tal como nos decks): pela maior soma dos quatro desvios do trabalho; por trás, o
%   bloco ordenado entra todo à esquerda do que já lá está (a de maior soma fica mais longe do fim).
%   Um trabalho com (0, 0) nas duas máquinas entra pela frente. No fim inverte-se a sequência.
%
%   Complementos de IO — deck 3.3.  J. F. A. Madeira — Licença MIT.
a = a(:)';  b = b(:)';
n = numel(a);
if nargin < 3 || isempty(nomes), nomes = arrayfun(@(k) sprintf('%d', k), 1:n, 'UniformOutput', false); end
if nargin < 4, log = false; end
F = [];  B = [];                    % bloco da frente e bloco de trás
rest = 1:n;
it = 0;
while ~isempty(rest)
  it = it + 1;
  D = Desvios(a, b, rest);
  z1 = rest(all(D(:, 1:2) == 0, 2));
  z2 = rest(all(D(:, 3:4) == 0, 2) & ~all(D(:, 1:2) == 0, 2));
  s = sum(D, 2)';                   % soma dos quatro desvios, pela ordem de rest
  [~, o] = sort(-s(ismember(rest, z1)));  z1 = z1(o);
  [~, o] = sort(-s(ismember(rest, z2)));  z2 = z2(o);
  F = [F z1]; %#ok<AGROW>
  B = [z2 B]; %#ok<AGROW>
  if log
    fprintf('  iteração %d (máx. %d e %d)\n', it, max(a(rest)), max(b(rest)));
    for k = 1:numel(rest)
      fprintf('    %-4s (%d, %d)  (%d, %d)\n', nomes{rest(k)}, D(k, :));
    end
  end
  rest = rest(~ismember(rest, [z1 z2]));
  if log
    txt = {strjoin(nomes(z1), ' '), strjoin(nomes(z2), ' ')};
    txt(cellfun(@isempty, txt)) = {'-'};
    fprintf('    pela frente: %s;  por trás: %s;  em construção: %s\n', txt{1}, txt{2}, ...
            strjoin([nomes(F), repmat({'_'}, 1, numel(rest)), nomes(B)], ' '));
  end
end
constr = [F B];
seq = fliplr(constr);
end
