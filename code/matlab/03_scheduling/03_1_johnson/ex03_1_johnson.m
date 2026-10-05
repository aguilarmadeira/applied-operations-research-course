% EX03_1_JOHNSON  Reproduz os exemplos do deck 3.1 (regra de Johnson, 2 máquinas).
%
%   Gráfica, seis trabalhos (impressão, acabamento): pela ordem de chegada T = 53 h (ociosos 12 e 11);
%   Johnson D, E, A, F, B, C com T = 45 h (ociosos 4 e 3).
%   Força bruta: o mínimo das 720 sequências é 45 h (só D E A F B C e D E F A B C), média 53 h, pior 61 h.
%   Para resolver na aula: Exemplo 1 (nove trabalhos) T = 61, ociosos 11 e 2;
%   Exemplo 2 (sete trabalhos) T = 67, ociosos 1 e 17, e os empates não mudam o tempo total.
%
%   Complementos de IO — deck 3.1.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 3.1: regra de Johnson (2 máquinas)\n');
% sequência, tempo total, ociosos e a tabela dos instantes de conclusão
lista = @(v, sep) strjoin(arrayfun(@(x) sprintf('%d', x), v, 'UniformOutput', false), sep);
tabC = @(C) strjoin(arrayfun(@(i) sprintf('    M%d:%s\n', i, sprintf('%4d', C(:, i))), 1:size(C, 2), 'UniformOutput', false), '');
mostra = @(nome, s, P, nomes) fprintf('  %s: %s  T = %d  ociosos = %s\n%s', nome, strjoin(nomes(s), ' '), ...
                                      Cmax(s, P), lista(Ocios(s, P), ', '), tabC(Tempos(s, P)));
ok = true;

% ------------------------------------------------------------ a gráfica (slide «Em Python»)
nomes = {'A', 'B', 'C', 'D', 'E', 'F'};
a = [8 11 5 3 4 10];
b = [9 5 2 5 12 9];
P = [a' b'];
fprintf('\nGráfica (impressão, acabamento): somas %d e %d h\n', sum(a), sum(b));
mostra('ordem de chegada', 1:6, P, nomes);
s = Johnson(a, b);
mostra('Johnson', s, P, nomes);
fprintf('  tempo_total(Johnson) = %d\n', TempoTotal(s, a, b));
C = Tempos(s, P);
ok = ok && Cmax(1:6, P) == 53 && isequal(Ocios(1:6, P), [12 11]);
ok = ok && isequal(s, [4 5 1 6 2 3]) && TempoTotal(s, a, b) == 45 && isequal(Ocios(s, P), [4 3]);
ok = ok && isequal(C(:, 2)', [8 20 29 38 43 45]);

% ------------------------------------------------------------ força bruta: as 720 sequências
[vals, seqs] = ForcaBruta(P);
iot = find(vals == vals(1));
otimas = arrayfun(@(k) strjoin(nomes(seqs(k, :)), ''), iot', 'UniformOutput', false);
fprintf('\nForça bruta: %d sequências; mínimo %d (%s); média %.2f; pior %d\n', ...
        numel(vals), vals(1), strjoin(otimas, ', '), mean(vals), max(vals));
Ts = unique(vals)';
cont = arrayfun(@(T) sum(vals == T), Ts);
fprintf('  n.º de sequências por T: %s\n', strjoin(arrayfun(@(k) sprintf('%d: %d', Ts(k), cont(k)), ...
        1:numel(Ts), 'UniformOutput', false), ', '));
ok = ok && vals(1) == 45 && isequal(otimas, {'DEAFBC', 'DEFABC'}) && max(vals) == 61;
ok = ok && round(mean(vals)) == 53 && cont(2) == 38 && Ts(2) == 46 && cont(6) == 123 && Ts(6) == 50;

% ------------------------------------------------------------ Exemplo 1: nove trabalhos
M1 = [2 5 4 9 6 8 7 5 4];
M2 = [6 8 7 4 3 9 3 8 11];
nomes1 = arrayfun(@(k) sprintf('J%d', k), 1:9, 'UniformOutput', false);
P1 = [M1' M2'];
fprintf('\nExemplo 1 (nove trabalhos): somas %d e %d\n', sum(M1), sum(M2));
s1 = Johnson(M1, M2);
mostra('Johnson', s1, P1, nomes1);
alt = [1 9 3 8 2 6 4 7 5];
fprintf('  com os empates escolhidos ao contrário: %s  T = %d\n', strjoin(nomes1(alt), ' '), Cmax(alt, P1));
ok = ok && isequal(s1, [1 3 9 2 8 6 4 5 7]) && Cmax(s1, P1) == 61 && isequal(Ocios(s1, P1), [11 2]);
ok = ok && Cmax(alt, P1) == 61;

% ------------------------------------------------------------ Exemplo 2: sete trabalhos
M1 = [3 12 15 6 10 11 9];
M2 = [8 10 10 6 12 1 3];
nomes2 = arrayfun(@(k) sprintf('%d', k), 1:7, 'UniformOutput', false);
P2 = [M1' M2'];
fprintf('\nExemplo 2 (sete trabalhos): somas %d e %d\n', sum(M1), sum(M2));
s2 = Johnson(M1, M2);
mostra('Johnson', s2, P2, nomes2);
fprintf('  empates (o 4 tem a = b = 6; o 2 e o 3 têm b = 10): outras sequências de Johnson\n');
variantes = [1 5 4 2 3 7 6; 1 5 3 2 4 7 6; 1 5 2 3 4 7 6; 1 4 5 3 2 7 6];
Tv = zeros(1, size(variantes, 1));
for k = 1:size(variantes, 1)
  Tv(k) = Cmax(variantes(k, :), P2);
  fprintf('    %s  T = %d\n', lista(variantes(k, :), ' '), Tv(k));
end
ok = ok && isequal(s2, [1 4 5 2 3 7 6]) && Cmax(s2, P2) == 67 && isequal(Ocios(s2, P2), [1 17]);
ok = ok && all(Tv == 67);

simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
