% EX04_3_GROUP_REPLACEMENT  Reproduz os exemplos do deck 4.3 (falhas súbitas e substituição de grupo).
%
%   Exemplo-guia: 800 luminárias, c_i = 25 €, c_g = 6 € por luminária, P(t) = 0,03 0,08 0,20 0,45 0,75 1 (semestres).
%   Vida média 4,49 semestres; individual: 800/4,49 = 178,2 falhas e K_ind = 4454,34 € por semestre.
%   N_t = 24; 40,72; 98,42; 207,87; 262,04; 247,45; 88,29; ...; grupo de 3 em 3 semestres: K(3) = 2959,5 €
%   (poupança de 1494,8 € por semestre, -34%). Leitura marginal: 25 N_4 = 5197 > K(3), 25 N_3 = 2461 < K(2).
%   Sensibilidade: c_g = 10, K(3) = 4026 (grupo); c_g = 12, K(3) = 4560 > 4454 (individual).
%   Simulação de Monte Carlo (4000 corridas, semente 1) dos N_t, comparada com a fórmula com tolerância 1,0.
%   Os números aleatórios do MATLAB/Octave não são os do numpy: a coluna da simulação difere um pouco
%   da versão Python (e do slide), dentro da tolerância.
%   Para resolver na aula: Exemplo 5 (1000 lâmpadas, c_i = 3, c_g = 1): vida 3,45 semanas, K_ind = 869,57,
%   grupo de 4 em 4 semanas, K(4) = 863,57 (compensa, por pouco).
%
%   Complementos de IO — deck 4.3.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 4.3: falhas súbitas e substituição de grupo\n');
fmt = @(v, f) strjoin(arrayfun(@(x) sprintf(f, x), v, 'UniformOutput', false), ' ');
ok = true;

% ------------------------------------------------------------ luminárias
Pac = [0.03 0.08 0.20 0.45 0.75 1.0];
n = 800;  ci = 25;  cg = 6;
[p, vida, ind, G] = Grupo(n, ci, cg, Pac);
[~, ~, N] = Falhas(n, Pac);                    % N_1, ..., N_12
fprintf('\nLuminárias (n = 800, c_i = 25 €, c_g = 6 € por luminária; períodos de um semestre)\n');
fprintf('  p_t: %s\n', fmt(p, '%.2f'));
fprintf('  vida média: %.2f semestres\n', vida);
fprintf('  individual: n/vida = %.1f falhas por semestre; K_ind = %.2f € por semestre\n', n / vida, ind);
fprintf('  N_t (t = 1, ..., 12): %s\n', fmt(N, '%.2f'));
fprintf('  política de grupo de t em t semestres:\n');
fprintf('     t     N_t   soma N  25 soma N    total     K(t)\n');
fprintf('  %4d %7.2f %8.2f %10.1f %8.1f %8.1f\n', G(:, [1 2 3 4 6 7])');
b = Melhor(G);
fprintf('  melhor: grupo de %d em %d semestres, K = %.1f € por semestre, contra %.1f da individual\n', b(1), b(1), b(7), ind);
fprintf('  poupança: %.1f € por semestre (%.0f%%), %.1f € por ano\n', ind - b(7), 100 * (b(7) / ind - 1), 2 * (ind - b(7)));
fprintf('  leitura marginal: 25 x N_3 = %.1f < K(2) = %.1f; 25 x N_4 = %.1f > K(3) = %.1f\n', ci * N(3), G(2, 7), ci * N(4), G(3, 7));
% o slide faz a tabela com os N_t já arredondados (K(6) = 4468,8; sem arredondar, 4468,75):
ok = ok && max(abs(p - [0.03 0.05 0.12 0.25 0.30 0.25])) < 1e-12 && abs(vida - 4.49) < 1e-9 ...
     && abs(n / vida - 178.2) < 0.05 && abs(ind - 4454.34) < 0.005 ...
     && max(abs(N - [24 40.72 98.42 207.87 262.04 247.45 88.29 138.14 190.73 215.67 194.40 162.39])) <= 0.005 ...
     && max(abs(G(:, 7)' - [5400.0 3209.0 2959.5 3518.8 4125.3 4468.8])) <= 0.06 ...
     && max(abs(G(:, 6)' - [5400.0 6418.0 8878.5 14075.3 20626.3 26812.5])) <= 0.06 ...
     && b(1) == 3 && abs(ind - b(7) - 1494.8) < 0.05 && round(100 * (b(7) / ind - 1)) == -34 ...
     && ci * N(4) > G(3, 7) && ci * N(3) < G(2, 7);

% ------------------------------------------------------------ sensibilidade a c_g
cgs = [10 12];  K3_ok = [4026.2 4559.5];
for j = 1:2
  [~, ~, ~, Gx] = Grupo(n, ci, cgs(j), Pac);
  K3 = Gx(3, 7);
  if K3 < ind, s = '<'; qual = 'grupo'; else, s = '>'; qual = 'individual'; end
  fprintf('  sensibilidade: c_g = %d: K(3) = %.1f %s %.1f -> %s\n', cgs(j), K3, s, ind, qual);
  bx = Melhor(Gx);
  ok = ok && abs(K3 - K3_ok(j)) < 0.05 && bx(1) == 3;
end

% ------------------------------------------------------------ simulação
T = 8;
F = Simula(n, Pac, T, 4000, 1);
fprintf('\nSimulação de Monte Carlo (4000 corridas de 800 luminárias, semente 1)\n');
fprintf('     t  N_t (fórmula)  simulação\n');
fprintf('  %4d %14.1f %10.1f\n', [1:T; N(1:T); F]);
if max(abs(F - N(1:T))) <= 1.0, txt = 'até 1,0 (dentro da tolerância)'; else, txt = 'mais de 1,0'; end
fprintf('  maior diferença: %s\n', txt);
ok = ok && max(abs(F - N(1:T))) <= 1.0;

% ------------------------------------------------------------ Para resolver na aula: Exemplo 5
[p5, v5, i5, G5] = Grupo(1000, 3, 1, [0.10 0.25 0.50 0.70 1.00]);
b5 = Melhor(G5);
fprintf('\nExemplo 5 (1000 lâmpadas, c_i = 3 €, c_g = 1 €; períodos de uma semana)\n');
fprintf('  p_t: %s\n', fmt(p5, '%.2f'));
fprintf('  a) vida média: %.2f semanas\n', v5);
fprintf('  b) individual: K_ind = %.2f € por semana\n', i5);
fprintf('  c) N_t: %s\n', fmt(G5(:, 2)', '%.2f'));
fprintf('     K(t): %s\n', fmt(G5(:, 7)', '%.2f'));
if b5(7) < i5, s = '<'; txt = 'compensa'; else, s = '>'; txt = 'não compensa'; end
fprintf('     melhor: grupo de %d em %d semanas, K = %.2f %s %.2f -> %s\n', b5(1), b5(1), b5(7), s, i5, txt);
ok = ok && max(abs(p5 - [0.10 0.15 0.25 0.20 0.30])) < 1e-12 && abs(v5 - 3.45) < 1e-9 && abs(i5 - 869.57) < 0.005 ...
     && max(abs(G5(:, 2)' - [100 160 281 277.1 429.86])) <= 0.005 ...
     && max(abs(G5(:, 7)' - [1300 890 874.33 863.57 948.78])) <= 0.006 ...
     && b5(1) == 4 && b5(7) < i5;

simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
