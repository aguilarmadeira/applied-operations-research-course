% EX04_2_DISCOUNTING  Reproduz os exemplos do deck 4.2 (substituição com valor temporal do dinheiro).
%
%   Fator de desconto d = 1/(1+r); com r = 10%: d = 0,9091 e 1000 € daqui a 5 anos valem hoje 620,92 €.
%   Carrinha a gasóleo de 4.1 com r = 10%: W(n) mínimo 10191,0 aos 6 anos (sem desconto eram 5 anos).
%   Regra: M_6 = 9781,8 < W(5) = 10251,9 (manter), M_7 = 11663,6 > W(6) = 10191,0 (substituir).
%   Ótimo e taxa (código do slide «Em Python»): 0 5 8760.0 | 0.05 6 9514.6 | 0.1 6 10191.0 | 0.15 6 10846.0.
%   Para resolver na aula: Exemplo 4 (P = 500, r = 5%): 3 anos, W = 271,61; sem desconto também 3 anos (266,67).
%
%   Complementos de IO — deck 4.2.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 4.2: com valor temporal do dinheiro\n');
fmt = @(v, f) strjoin(arrayfun(@(x) sprintf(f, x), v, 'UniformOutput', false), ' ');
ok = true;

% ------------------------------------------------------------ fator de desconto
d = 1 / 1.1;
fprintf('\nFator de desconto com r = 10%%: d = %.4f; 1000 € daqui a 5 anos valem hoje %.2f €\n', d, 1000 * d^5);
ok = ok && abs(1000 * d^5 - 620.92) < 0.005;

% ------------------------------------------------------------ carrinha com r = 10%
P = 30000;
C = [3000 3600 4400 5400 6400 7600 9800 12500];
S = [22000 17000 13500 11000 9000 7500 6200 5000];
W = Desconto(P, C, 0.10, S);
fprintf('\nCarrinha a gasóleo com r = 10%% (P = 30000)\n');
fprintf('    n     C_n  d^(n-1)  C_n d^(n-1)  soma C d   S_n d^n  P+soma-S d^n  soma d      W(n)\n');
SD = P + W(:, 5) - W(:, 6);                    % S_n d^n
fprintf('  %3d %7d %8.4f %12.1f %9.1f %9.1f %13.1f %7.4f %9.1f\n', [W(:, 1:5), SD, W(:, 6:8)]');
b = Melhor(W);
fprintf('  substituir ao fim de %d anos: W = %.1f € por ano (sem desconto: 5 anos)\n', b(1), b(8));
for n = [5 6]
  M = CustoMaisUmAno(C, S, n, d);
  if M < W(n, 8), s = '<'; dec = 'manter'; else, s = '>'; dec = 'substituir'; end
  fprintf('  regra: M_%d = %d + %d - %.4f x %d = %.1f %s W(%d) = %.1f -> %s\n', ...
          n + 1, C(n + 1), S(n), d, S(n + 1), M, s, n, W(n, 8), dec);
end
ok = ok && b(1) == 6 && abs(b(8) - 10191.0) < 0.05 ...
     && max(abs(W(:, 8)' - [13000 11640.7 10881.4 10454.4 10251.9 10191.0 10346.2 10679.2])) <= 0.05 ...
     && max(abs(SD' - [20000 14049.6 10142.7 7513.1 5588.3 4233.6 3181.6 2332.5])) <= 0.05 ...
     && max(abs(W(:, 7)' - [1 1.9091 2.7355 3.4869 4.1699 4.7908 5.3553 5.8684])) <= 5e-5 ...
     && abs(CustoMaisUmAno(C, S, 5, d) - 9781.8) < 0.05 && abs(CustoMaisUmAno(C, S, 6, d) - 11663.6) < 0.05;

% ------------------------------------------------------------ ótimo e taxa (código do slide «Em Python»)
fprintf('\nÓtimo e taxa de desconto (como no slide «Em Python»):\n');
taxas = [0 0.05 0.10 0.15];
W_ok = [8760.0 9514.6 10191.0 10846.0];
n_ok = [5 6 6 6];
res = cell(1, 4);
for j = 1:4
  Wr = CustoEquivalente(P, C, S, taxas(j));
  [Wmin, n] = min(Wr);
  res{j} = sprintf('%g %d %.1f', taxas(j), n, Wmin);
  ok = ok && abs(Wmin - W_ok(j)) < 0.05 && n == n_ok(j);
end
fprintf('  %s\n', strjoin(res, ' | '));

% ------------------------------------------------------------ Para resolver na aula: Exemplo 4
C4 = [0 100 200 300 400];
W4 = Desconto(500, C4, 0.05);
fprintf('\nExemplo 4 (P = 500, r = 5%%, sucata 0)\n');
fprintf('    n  C_n d^(n-1)  soma C d  soma d    W(n)\n');
fprintf('  %3d %11.2f %9.2f %7.4f %7.2f\n', W4(:, [1 4 5 7 8])');
b4 = Melhor(W4);
fprintf('  substituir ao fim de %d anos: W = %.2f\n', b4(1), b4(8));
fprintf('  regra (sem revenda): C_3 = %d <= W(2) = %.2f e C_4 = %d > W(3) = %.2f\n', C4(3), W4(2, 8), C4(4), W4(3, 8));
A4 = CustoMedio(500, C4);
[~, n4] = min(A4);
fprintf('  sem desconto: A(n) = %s -> %d anos\n', fmt(A4, '%.2f'), n4);
ok = ok && b4(1) == 3 && abs(b4(8) - 271.61) < 0.005 ...
     && max(abs(W4(:, 8)' - [500 304.88 271.61 278.20 300.24])) <= 0.005 ...
     && C4(3) <= W4(2, 8) && C4(4) > W4(3, 8) ...
     && n4 == 3 && max(abs(A4 - [500 300 800/3 275 300])) < 1e-9;

simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
