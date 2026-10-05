% EX06_2_MMK_MMS  Reproduz os exemplos do deck 6.2 (capacidade limitada e vários servidores).
%
%   M/M/1/K no posto de 6.1 (lambda = 3/h, mu = 4/h), K = 2..6 e infinito: P_K, lambda_ef, L, W;
%   com K = 4, 10.4% desistem (0.31 por hora) e quem fica está 32 min; SimulaMm1k(3, 4, 4)
%   compara-se com as fórmulas com tolerância.
%   M/M/s com lambda = 6/h: s = 2..5 -> P(esperar) 0.643, 0.237, 0.075, 0.020 e Wq 19.3, 2.4, 0.45, 0.09 min.
%   Fila única (M/M/2, 19.3 min) contra duas filas separadas (duas M/M/1, 45 min).
%   Custo 12 s + 20 Lq (CustoCaixas): 62.57, 40.74, 48.90, 60.17 €/h -> 3 carregadores;
%   nível de serviço «menos de 10% esperam» -> 4 (7.5%), mais 8.16 €/h. SimulaMms(6, 4, 3): Wq ~ 2.4 min.
%   As simulações usam o gerador do MATLAB/Octave, não o do numpy: os números simulados diferem
%   dos do Python e conferem-se com tolerância.
%   Para resolver na aula: Exemplo 2 (restaurante, M/M/1/K com K = 300): Lq = 4/3, P(fila) = 44.4%,
%   W = 18 s, igual ao M/M/1 (P_K ~ 5e-54).
%
%   Complementos de IO — deck 6.2.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

% v arredondado a «casas» casas decimais (por coluna) dá os valores do slide?
confere = @(v, alvo, casas) all(all(abs(v - alvo) <= 0.5 * 10 .^ (-casas) + 1e-9));
ok = true;
simnao = {'não', 'sim'};
fprintf('Complementos de IO — deck 6.2: capacidade limitada e vários servidores\n');

% ------------------------------------------------------------ M/M/1/K
lam = 3;  mu = 4;
fprintf('\nM/M/1/K: posto de carregamento com K lugares (lambda = 3/h, mu = 4/h)\n');
fprintf('  K    P_K    lambda_ef    L     W (min)\n');
tab = zeros(5, 4);
Ks = [2 3 4 5 6];
for j = 1:5
  x = Mm1k(lam, mu, Ks(j));
  tab(j, :) = [x.PK x.lef x.L x.W * 60];
  fprintf('  %-3d  %.3f  %.2f         %.2f  %.0f\n', Ks(j), x.PK, x.lef, x.L, x.W * 60);
end
m = Mm1(lam, mu);
fprintf('  inf  0      %.4g            %.4g     %.4g\n', lam, m.L, m.W * 60);
k4 = Mm1k(lam, mu, 4);
fprintf('  K = 4: desistem %.1f%% (%.2f por hora); quem fica está %.0f min\n', ...
        100 * k4.PK, lam * k4.PK, k4.W * 60);
ok = ok && confere(tab, [0.243 2.27 0.81 21; 0.154 2.54 1.15 27; 0.104 2.69 1.44 32; ...
                         0.072 2.78 1.70 37; 0.051 2.85 1.92 41], [3 2 2 0]) ...
     && abs(round(100 * lam * k4.PK) / 100 - 0.31) < 1e-9;

sk = SimulaMm1k(lam, mu, 4);
fprintf('Simulação (SimulaMm1k(3, 4, 4): 200000 chegadas, semente 1)\n');
fprintf('  desistem %.1f%% (fórmula %.1f%%)  W = %.0f min (%.0f)\n', 100 * sk.PK, 100 * k4.PK, sk.W * 60, k4.W * 60);
tol = abs(sk.PK - k4.PK) <= 0.02 && abs(sk.W - k4.W) <= 0.10 * k4.W;
fprintf('  simulação dentro da tolerância (10%% nas médias, 0.02 nas probabilidades): %s\n', simnao{tol + 1});
ok = ok && tol;

% ------------------------------------------------------------ M/M/s
lam = 6;
fprintf('\nM/M/s: a procura duplica (lambda = 6/h, mu = 4/h)\n');
fprintf('  s  P(esperar)  Lq     Wq (min)\n');
v = zeros(4, 3);
for s = 2:5
  y = Mms(lam, mu, s);
  v(s - 1, :) = [y.Pw y.Lq y.Wq * 60];
  fprintf('  %d  %.3f       %.3f  %.2f\n', s, y.Pw, y.Lq, y.Wq * 60);
end
ok = ok && confere(v(:, 1)', [0.643 0.237 0.075 0.020], 3) ...
     && confere(v(:, 2)', [1.93 0.24 0.045 0.009], [2 2 3 3]) ...
     && confere(v(:, 3)', [19.3 2.4 0.45 0.09], [1 1 2 2]);

% ------------------------------------------------------------ fila única ou separadas
x1 = Mm1(3, mu);  x2 = Mms(6, mu, 2);
sep = x1.Wq * 60;  uni = x2.Wq * 60;
fprintf('\nFila única ou uma fila por carregador (2 carregadores, lambda = 6/h)\n');
fprintf('  duas filas separadas (duas M/M/1, lambda = 3): Wq = %.1f min\n', sep);
fprintf('  uma fila única (M/M/2, lambda = 6):            Wq = %.1f min\n', uni);
ok = ok && abs(round(10 * sep) / 10 - 45) < 1e-9 && abs(round(10 * uni) / 10 - 19.3) < 1e-9;

% ------------------------------------------------------------ custo contra espera
fprintf('\nQuantos carregadores? custo(s) = 12 s + 20 Lq(s) (€/h)\n');
fprintf('  s  carregadores  espera  total\n');
tc = CustoCaixas(lam, mu, 12, 20, 5);             % linhas [s Pw Lq L custo]
for j = 1:size(tc, 1)
  fprintf('  %d  %-12.0f  %-6.2f  %.2f\n', tc(j, 1), 12 * tc(j, 1), 20 * tc(j, 3), tc(j, 5));
end
c = tc(:, 5)';
[cmin, imin] = min(c);
smin = tc(imin, 1);
iserv = find(tc(:, 2) < 0.10, 1);
sserv = tc(iserv, 1);
fprintf('  mínimo custo: %d carregadores (%.2f €/h); esperam %.1f%%\n', smin, cmin, 100 * tc(imin, 2));
fprintf('  menos de 10%% esperam: %d carregadores (%.1f%%), %.2f €/h; preço do nível de serviço %.2f €/h\n', ...
        sserv, 100 * tc(iserv, 2), c(iserv), c(iserv) - cmin);
ok = ok && isequal(tc(:, 1)', [2 3 4 5]) && confere(c, [62.57 40.74 48.90 60.17], 2) ...
     && smin == 3 && sserv == 4 && abs(round(100 * (c(iserv) - cmin)) / 100 - 8.16) < 1e-9;

sm = SimulaMms(lam, mu, 3);
y3 = Mms(lam, mu, 3);
fprintf('Simulação (SimulaMms(6, 4, 3), semente 1)\n');
fprintf('  Wq = %.2f min (fórmula %.2f)  P(esperar) = %.3f (%.3f)\n', sm.Wq * 60, y3.Wq * 60, sm.Pw, y3.Pw);
tol = abs(sm.Wq - y3.Wq) <= 0.10 * y3.Wq && abs(sm.Pw - y3.Pw) <= 0.02;
fprintf('  simulação dentro da tolerância (10%% nas médias, 0.02 nas probabilidades): %s\n', simnao{tol + 1});
ok = ok && tol;

% ------------------------------------------------------------ Exemplo 2 (para resolver na aula)
z = Mm1k(400, 600, 300);
zi = Mm1(400, 600);
pfila = 1 - z.P(1) - z.P(2);                     % 1 - P0 - P1
fprintf('\nExemplo 2 — restaurante (M/M/1/GD/300/inf, lambda = 400/h, mu = 600/h)\n');
fprintf('  a) Lq = %.4f clientes\n', z.Lq);
fprintf('  b) P(haver fila) = 1 - P0 - P1 = %.4f (%.1f%%)\n', pfila, 100 * pfila);
fprintf('  c) W = %.4g s\n', z.W * 3600);
fprintf('  d) M/M/1 sem limite: Lq = %.4f, P(fila) = rho^2 = %.4f, W = %.4g s; P_K = %.1e: o limite não conta\n', ...
        zi.Lq, zi.rho ^ 2, zi.W * 3600, z.PK);
ok = ok && abs(z.Lq - 4 / 3) < 1e-9 && abs(pfila - 4 / 9) < 1e-9 && abs(z.W * 3600 - 18) < 1e-9 ...
     && abs(zi.Lq - z.Lq) < 1e-9 && z.PK < 1e-50;

fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
