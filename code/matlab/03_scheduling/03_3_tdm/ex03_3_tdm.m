% EX03_3_TDM  Reproduz os exemplos do deck 3.3 (método do desvio de tempo, TDM).
%
%   Gráfica (2 máquinas): iteração 1 com B pela frente e E por trás; construída B, F, C, D, A, E;
%   TDM E, A, D, C, F, B com T = 46 h (Johnson 45); das 720 sequências, 40 dão 46 h ou menos.
%   Os três exemplos do capítulo (chegada, TDM, Johnson, ótimo): 53, 46, 45, 45; 55, 49, 47, 47; 39, 40, 39, 35.
%   Para resolver na aula: Exemplo 6 (= Exemplo 1 de 3.1) T = 63 contra 61 de Johnson;
%   Exemplo 7 (= Exemplo 5 de 3.2) T = 54 contra 51; Exemplo 8 T = 62 contra 60 (o ótimo).
%   (A experiência com 500 problemas aleatórios está só em Python: ver o README.)
%
%   Complementos de IO — deck 3.3.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 3.3: método do desvio de tempo (TDM)\n');
lista = @(v, sep) strjoin(arrayfun(@(x) sprintf('%d', x), v, 'UniformOutput', false), sep);
tabC = @(C) strjoin(arrayfun(@(i) sprintf('    M%d:%s\n', i, sprintf('%4d', C(:, i))), 1:size(C, 2), 'UniformOutput', false), '');
mostra = @(nome, s, P, nomes) fprintf('  %s: %s  T = %d  ociosos = %s\n%s', nome, strjoin(nomes(s), ' '), ...
                                      Cmax(s, P), lista(Ocios(s, P), ', '), tabC(Tempos(s, P)));
numeros = @(n) arrayfun(@(k) sprintf('%d', k), 1:n, 'UniformOutput', false);
ok = true;

% ------------------------------------------------------------ gráfica, passo a passo
nomes = {'A', 'B', 'C', 'D', 'E', 'F'};
P = [8 11 5 3 4 10; 9 5 2 5 12 9]';
a = P(:, 1);  b = P(:, 2);
fprintf('\nGráfica (impressão, acabamento); desvios (máquina, trabalho) em cada máquina\n');
[s, constr] = Tdm(P, nomes, true);
fprintf('  construída: %s;  TDM (invertida): %s\n', strjoin(nomes(constr), ' '), strjoin(nomes(s), ' '));
mostra('TDM', s, P, nomes);
vals = ForcaBruta(P);
fprintf('  das %d sequências, %d dão T <= %d\n', numel(vals), sum(vals <= 46), 46);
D1 = Desvios(a, b, 1:6);
D2 = Desvios(a, b, [1 3 4 6]);
C = Tempos(s, P);
ok = ok && isequal(D1([1 2 3 5], :), [3 1 3 0; 0 0 7 6; 6 0 10 3; 7 8 0 0]) && isequal(D2(4, :), [0 0 0 1]);
ok = ok && isequal(constr, [2 6 3 4 1 5]) && isequal(s, [5 1 4 3 6 2]) && Cmax(s, P) == 46;
ok = ok && isequal(C(:, 2)', [16 25 30 32 41 46]) && sum(vals <= 46) == 40;

% ------------------------------------------------------------ os três exemplos do capítulo
fprintf('\nOs três exemplos do capítulo (tempos totais em horas)\n');
fprintf('  %-36s %8s %5s %8s %6s\n', '', 'chegada', 'TDM', 'Johnson', 'ótimo');
casos = {'Gráfica, 2 máquinas (3.1)', P
         'Com corte, 3 máquinas (3.2)', [8 11 5 3 4 10; 2 3 1 2 3 1; 9 5 2 5 12 9]'
         'Plastificação, condição falha (3.2)', [2 7 2 4; 4 8 9 8; 3 8 7 5]'};
quadro = zeros(3, 4);
for c = 1:3
  [nome, Q] = casos{c, :};
  vq = ForcaBruta(Q);
  quadro(c, :) = [Cmax(1:size(Q, 1), Q), Cmax(Tdm(Q), Q), Cmax(JohnsonM(Q), Q), vq(1)];
  fprintf('  %-36s %8d %5d %8d %6d\n', nome, quadro(c, :));
end
[sq, cq] = Tdm(casos{3, 2});
fprintf('  plastificação: TDM %s (construída %s)\n', lista(sq, ' '), lista(cq, ' '));
ok = ok && isequal(quadro, [53 46 45 45; 55 49 47 47; 39 40 39 35]) && isequal(sq, [2 3 4 1]);

% ------------------------------------------------------------ Exemplo 6 (= Exemplo 1 de 3.1)
E1 = [2 5 4 9 6 8 7 5 4; 6 8 7 4 3 9 3 8 11]';
nomes1 = arrayfun(@(k) sprintf('J%d', k), 1:9, 'UniformOutput', false);
fprintf('\nExemplo 6 (= Exemplo 1 de 3.1)\n');
[s6, c6] = Tdm(E1, nomes1, true);
fprintf('  construída: %s\n', strjoin(nomes1(c6), ' '));
mostra('TDM', s6, E1, nomes1);
fprintf('  Johnson: T = %d\n', Cmax(JohnsonM(E1), E1));
ok = ok && isequal(c6, [4 7 5 1 3 2 8 6 9]) && Cmax(s6, E1) == 63 && isequal(Ocios(s6, E1), [13 4]);
ok = ok && Cmax(JohnsonM(E1), E1) == 61;

% ------------------------------------------------------------ Exemplo 7 (= Exemplo 5 de 3.2)
E5 = [7 6 5 8; 5 6 4 3; 2 4 5 3; 3 5 6 2; 9 10 8 6]';
nomes5 = numeros(4);
[G, H] = Reduz(E5);
fprintf('\nExemplo 7 (= Exemplo 5 de 3.2): G = %s, H = %s\n', mat2str(G), mat2str(H));
[s7, c7] = Tdm(E5, nomes5, true);
fprintf('  construída: %s\n', strjoin(nomes5(c7), ' '));
mostra('TDM', s7, E5, nomes5);
mostra('Johnson', JohnsonM(E5), E5, nomes5);
ok = ok && isequal(c7, [4 1 3 2]) && isequal(s7, [2 3 1 4]) && Cmax(s7, E5) == 54 && Cmax(JohnsonM(E5), E5) == 51;

% ------------------------------------------------------------ Exemplo 8
E8 = [7 8 10 9 7; 5 6 4 5 7; 12 10 7 8 11]';
nomes8 = numeros(5);
[verif, info] = Condicao(E8);
[G, H] = Reduz(E8);
simfalha = {'falha', 'verifica-se'};
fprintf('\nExemplo 8: condição %s (min M1 = %d, min M3 = %d, máx. M2 = %d); G = %s, H = %s\n', ...
        simfalha{verif + 1}, info(1), info(2), info(3), mat2str(G), mat2str(H));
[s8, c8] = Tdm(E8, nomes8, true);
fprintf('  construída: %s\n', strjoin(nomes8(c8), ' '));
mostra('TDM', s8, E8, nomes8);
j8 = JohnsonM(E8);
mostra('Johnson', j8, E8, nomes8);
v8 = ForcaBruta(E8);
fprintf('  força bruta: ótimo = %d\n', v8(1));
ok = ok && verif && isequal(info, [7 7 7]) && isequal(c8, [3 4 2 1 5]) && isequal(s8, [5 1 2 4 3]) && Cmax(s8, E8) == 62;
ok = ok && isequal(j8, [1 2 5 4 3]) && Cmax(j8, E8) == 60 && v8(1) == 60;

simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
