% EX04_1_WEAR  Reproduz os exemplos do deck 4.1 (equipamentos que se desgastam, sem valor temporal do dinheiro).
%
%   Exemplo-guia: carrinha a gasóleo, P = 30000, C_n = 3000, ..., 12500, S_n = 22000, ..., 5000.
%   Custo médio anual mínimo A(5) = 8760: substituir ao fim de 5 anos; fundo achatado (A(4) e A(6) a cerca de 1%).
%   Regra: M_5 = 8400 < A(4) = 8850 (manter), M_6 = 9100 > A(5) = 8760 (substituir).
%   Duas máquinas: carrinha elétrica, P = 44000, mínimo 8316,67 aos 6 anos; a gasóleo com 3 anos troca-se
%   ao fim do 4.º ano (M_4 = 7900 < 8316,67, M_5 = 8400 > 8316,67). Código do slide «Em Python»: 5 8760.0.
%   Para resolver na aula: Exemplo 1 (7 anos, 1821,43), Exemplo 2 (6 anos, 6333,33) e
%   Exemplo 3 (duas máquinas: trocar A pela B no fim do ano 2 ou do ano 3; comprar agora a B).
%
%   Complementos de IO — deck 4.1.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 4.1: equipamentos que se desgastam\n');
fmt = @(v, f) strjoin(arrayfun(@(x) sprintf(f, x), v, 'UniformOutput', false), ' ');
sinais = struct('manter', '<', 'indiferente', '=', 'trocar', '>');
ok = true;

% ------------------------------------------------------------ carrinha a gasóleo
P = 30000;
C = [3000 3600 4400 5400 6400 7600 9800 12500];
S = [22000 17000 13500 11000 9000 7500 6200 5000];
fprintf('\nCarrinha a gasóleo (P = 30000)\n');
L = Media(P, C, S);
fprintf('     n     C_n   soma C   P - S_n    total       A(n)\n');
fprintf('  %4d %7d %8d %9d %8d %10.2f\n', L');
b = Melhor(L);
fprintf('  substituir ao fim de %d anos: A = %.2f € por ano\n', b(1), b(6));
perda = (P - S) ./ (1:8);
func = L(:, 3)' ./ (1:8);
fprintf('  perda de valor por ano: %s\n', fmt(perda, '%.1f'));
fprintf('  funcionamento por ano:  %s\n', fmt(func, '%.1f'));
fprintf('  fundo achatado: A(4) %+.2f%% e A(6) %+.2f%% em relação a A(5)\n', ...
        100 * (L(4, 6) / L(5, 6) - 1), 100 * (L(6, 6) / L(5, 6) - 1));
for n = [4 5]
  M = CustoMaisUmAno(C, S, n);
  if M < L(n, 6), s = '<'; dec = 'manter'; else, s = '>'; dec = 'substituir'; end
  fprintf('  regra: M_%d = %d + %d = %d %s A(%d) = %.2f -> %s\n', n + 1, C(n + 1), S(n) - S(n + 1), M, s, n, L(n, 6), dec);
end
ok = ok && b(1) == 5 && abs(b(6) - 8760) < 1e-9 ...
     && max(abs(L(:, 6)' - [11000 9800 27500/3 8850 8760 52900/6 64000/7 9712.5])) < 1e-9 ...
     && isequal(perda, [8000 6500 5500 4750 4200 3750 3400 3125]) ...
     && abs(func(3) - 3666.67) < 0.01 && abs(func(7) - 5742.86) < 0.01 ...
     && CustoMaisUmAno(C, S, 4) == 8400 && CustoMaisUmAno(C, S, 5) == 9100;

% ------------------------------------------------------------ duas máquinas: a elétrica
Pe = 44000;
Ce = [1600 1900 2400 3100 4000 5400 7000 9000];
Se = [32000 25500 21000 17500 14800 12500 10600 9000];
Le = Media(Pe, Ce, Se);
be = Melhor(Le);
fprintf('\nCarrinha elétrica (P = 44000)\n');
fprintf('  A(n): %s\n', fmt(Le(:, 6)', '%.2f'));
fprintf('  mínimo: %.2f € por ano, substituindo ao fim de %d anos\n', be(6), be(1));
fprintf('Gasóleo com 3 anos: trocar já pela elétrica?\n');
[quando, linhas, decisao] = QuandoTrocar(C, S, 3, be(6));
for j = 1:size(linhas, 1)
  fprintf('  %d.º ano da antiga: M = %d %s %.2f -> %s\n', linhas(j, 1), linhas(j, 2), sinais.(decisao{j}), be(6), decisao{j});
end
fprintf('  -> manter a gasóleo e trocar ao fim do %d.º ano\n', quando(1));
ok = ok && be(1) == 6 && abs(be(6) - 8316.67) < 0.005 && isequal(quando, 4) ...
     && max(abs(Le(:, 6)' - [13600 11000 9633 8875 8440 8317 8400 8675])) <= 0.5;

% ------------------------------------------------------------ código do slide «Em Python»
A = CustoMedio(P, C, S);
[~, n] = min(A);
fprintf('\nComo no slide «Em Python»: %d %.1f\n', n, A(n));
ok = ok && n == 5 && A(n) == 8760;

% ------------------------------------------------------------ Para resolver na aula: Exemplos 1 e 2
casos = {
  'Exemplo 1 (P = 7100, sucata 100)', 7100, [200 350 500 700 1000 1300 1700 2100], 100, 7, 1821.43
  'Exemplo 2 (P = 24400, sucata 400)', 24400, [400 1000 1600 2400 3600 5000 6400 8000], 400, 6, 6333.33};
for c = 1:2
  [nome, Px, Cx, Sx, n_ok, a_ok] = casos{c, :};
  Lx = Media(Px, Cx, Sx);
  bx = Melhor(Lx);
  fprintf('\n%s\n', nome);
  fprintf('  A(n): %s\n', fmt(Lx(:, 6)', '%.2f'));
  fprintf('  substituir ao fim de %d anos: A = %.2f\n', bx(1), bx(6));
  ok = ok && bx(1) == n_ok && abs(bx(6) - a_ok) < 0.005;
end

% ------------------------------------------------------------ Exemplo 3: duas máquinas, sem revenda
CA = 2000 + 10000 * (0:7);
CB = 3000 + 4000 * (0:7);
AA = CustoMedio(45000, CA);  AB = CustoMedio(55000, CB);
bA = Melhor(Media(45000, CA));  bB = Melhor(Media(55000, CB));
fprintf('\nExemplo 3 (duas máquinas, sem revenda)\n');
fprintf('  A: A(n) = %s; mínimo %.2f aos %d anos\n', fmt(AA, '%.2f'), bA(6), bA(1));
fprintf('  B: A(n) = %s; mínimo %.2f aos %d anos\n', fmt(AB, '%.2f'), bB(6), bB(1));
fprintf('a) A em funcionamento (no 1.º ano); mais um ano de A custa C_{n+1}:\n');
[q3, linhas, decisao] = QuandoTrocar(CA, 0, 1, bB(6));
for j = 1:size(linhas, 1)
  fprintf('  %d.º ano da antiga: M = %d %s %.2f -> %s\n', linhas(j, 1), linhas(j, 2), sinais.(decisao{j}), bB(6), decisao{j});
end
fprintf('  -> trocar A pela B no fim do ano %s\n', strjoin(arrayfun(@(k) sprintf('%d', k), q3, 'UniformOutput', false), ' ou do ano '));
if bB(6) < bA(6), qual = 'B'; else, qual = 'A'; end
fprintf('b) comprar agora: %s (%.2f contra %.2f)\n', qual, bB(6), bA(6));
ok = ok && bA(1) == 3 && bA(6) == 27000 && bB(1) == 5 && bB(6) == 22000 && isequal(q3, [2 3]) ...
     && max(abs(AA(1:5) - [47000 29500 27000 28250 31000])) < 1e-9 ...
     && max(abs(AB(1:7) - [58000 32500 76000/3 22750 22000 133000/6 160000/7])) < 1e-9;

simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
