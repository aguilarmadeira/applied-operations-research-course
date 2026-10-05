% EX03_2_M_MACHINES  Reproduz os exemplos do deck 3.2 (três ou mais máquinas).
%
%   Gráfica com corte (impressão, corte, acabamento): min M1 = 3 >= máx. M2 = 3, a condição verifica-se;
%   G = (10, 14, 6, 5, 7, 11), H = (11, 8, 3, 7, 15, 10); Johnson D, E, A, F, B, C com T = 47 h
%   (ociosos 6, 35, 5); pela ordem de chegada 55 h; força bruta: mínimo 47 h.
%   Semana da plastificação: a condição falha (máx. M2 = 9, min M1 = 2, min M3 = 3);
%   Johnson «à força» 1, 3, 4, 2 com T = 39; ótimo (24 sequências) 3, 2, 4, 1 com T = 35.
%   Para resolver na aula: Exemplos 3 (T = 51), 4 (T = 52) e 5 (cinco máquinas, T = 51).
%   (A experiência com 500 problemas aleatórios está só em Python: ver o README.)
%
%   Complementos de IO — deck 3.2.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 3.2: três ou mais máquinas\n');
lista = @(v, sep) strjoin(arrayfun(@(x) sprintf('%d', x), v, 'UniformOutput', false), sep);
tabC = @(C) strjoin(arrayfun(@(i) sprintf('    M%d:%s\n', i, sprintf('%4d', C(:, i))), 1:size(C, 2), 'UniformOutput', false), '');
mostra = @(nome, s, P, nomes) fprintf('  %s: %s  T = %d  ociosos = %s\n%s', nome, strjoin(nomes(s), ' '), ...
                                      Cmax(s, P), lista(Ocios(s, P), ', '), tabC(Tempos(s, P)));
simfalha = {'falha', 'verifica-se'};
ok = true;

% os casos: título, tabela (uma linha por máquina), nomes dos trabalhos
casos = {
  'Gráfica com corte (impressão, corte, acabamento)', [8 11 5 3 4 10; 2 3 1 2 3 1; 9 5 2 5 12 9], {'A', 'B', 'C', 'D', 'E', 'F'}
  'Semana da plastificação (impressão, plastificação, acabamento)', [2 7 2 4; 4 8 9 8; 3 8 7 5], {}
  'Exemplo 3', [8 10 6 7 11; 5 6 2 3 4; 4 9 8 6 5], {}
  'Exemplo 4', [6 7 9 10 6; 5 6 4 3 4; 11 10 6 7 8], {}
  'Exemplo 5 (cinco máquinas)', [7 6 5 8; 5 6 4 3; 2 4 5 3; 3 5 6 2; 9 10 8 6], {}};
res = cell(size(casos, 1), 5);
for c = 1:size(casos, 1)
  [titulo, linhas, nomes] = casos{c, :};
  P = linhas';                                   % linha = trabalho, coluna = máquina
  n = size(P, 1);
  if isempty(nomes), nomes = arrayfun(@(k) sprintf('%d', k), 1:n, 'UniformOutput', false); end
  [verif, info] = Condicao(P);
  [G, H] = Reduz(P);
  fprintf('\n%s\n', titulo);
  fprintf('  condição: min M1 = %d, min M%d = %d, máx. das intermédias = %d -> %s\n', ...
          info(1), size(P, 2), info(2), info(3), simfalha{verif + 1});
  fprintf('  G = %s,  H = %s\n', mat2str(G), mat2str(H));
  s = JohnsonM(P);
  mostra('Johnson', s, P, nomes);
  res(c, :) = {P, verif, info, s, [G; H]};
  if c == 1
    mostra('ordem de chegada', 1:n, P, nomes);
    vals = ForcaBruta(P);
    fprintf('  força bruta: mínimo das %d sequências = %d\n', numel(vals), vals(1));
    ok = ok && verif && isequal(info, [3 2 3]) && isequal(G, [10 14 6 5 7 11]) && isequal(H, [11 8 3 7 15 10]);
    ok = ok && isequal(s, [4 5 1 6 2 3]) && Cmax(s, P) == 47 && isequal(Ocios(s, P), [6 35 5]);
    ok = ok && Cmax(1:n, P) == 55 && vals(1) == 47;
  elseif c == 2
    [vals, seqs] = ForcaBruta(P);
    iot = find(vals == vals(1));
    otimas = arrayfun(@(k) strjoin(nomes(seqs(k, :)), ''), iot', 'UniformOutput', false);
    fprintf('  força bruta (%d sequências): ótimo %s\n', numel(vals), strjoin(otimas, ', '));
    mostra('ótimo', seqs(iot(1), :), P, nomes);
    ok = ok && ~verif && isequal(info, [2 3 9]) && isequal(G, [6 15 11 12]) && isequal(H, [7 16 16 13]);
    ok = ok && isequal(s, [1 3 4 2]) && Cmax(s, P) == 39 && isequal(otimas, {'3241'}) && vals(1) == 35;
  end
end

% ------------------------------------------------------------ para resolver na aula
[P3, v3, i3, s3] = res{3, 1:4};
[P4, v4, i4, s4] = res{4, 1:4};
[P5, v5, i5, s5, GH5] = res{5, :};
ok = ok && v3 && isequal(i3, [6 4 6]) && isequal(s3, [3 2 1 4 5]) && Cmax(s3, P3) == 51;
ok = ok && isequal(Ocios(s3, P3), [9 31 19]);
ok = ok && v4 && isequal(i4, [6 6 6]) && isequal(s4, [5 1 2 3 4]) && Cmax(s4, P4) == 52;
ok = ok && isequal(Ocios(s4, P4), [14 30 10]);
ok = ok && v5 && isequal(i5, [5 6 6]) && isequal(s5, [1 3 2 4]) && Cmax(s5, P5) == 51;
ok = ok && isequal(GH5, [17 21 20 16; 19 25 23 14]) && isequal(Ocios(s5, P5), [25 33 37 35 18]);

simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
