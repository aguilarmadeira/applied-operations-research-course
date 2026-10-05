% EX06_3_MMR  Reproduz os exemplos do deck 6.3 (população finita, M/M/R).
%
%   Exemplo-guia: K = 10 empilhadores, lambda = 0.1 avarias/dia, mu = 0.8 reparações/dia;
%   técnico 150 €/dia, empilhador parado 250 €/dia. R = 1, 2, 3:
%       P0 0.122, 0.283, 0.305; L 2.97, 1.35, 1.14; Lq 2.09, 0.26, 0.04; W 4.23, 1.55, 1.29 dias;
%       custo 893, 636, 736 €/dia -> dois técnicos (menos 257 €/dia); com um técnico Wq ~ 2.98 dias;
%       o 3.º técnico tira 0.2 empilhadores da paragem (50 €/dia) e custa 150.
%   População infinita: lambda = 1/dia contra mu = 0.8 dá rho = 1.25 (instável); na lavandaria 1 contra 0.4.
%   Para resolver na aula: Exemplo 3 (lavandaria, 5 máquinas, 3 mecânicos contra um super-mecânico):
%   L = 1.71 contra 1.16 -> trocar; Wq 0.11 contra 0.68 dias, W 2.61 contra 1.51 dias.
%
%   Complementos de IO — deck 6.3.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

% v arredondado a «casas» casas decimais (por coluna) dá os valores do slide?
confere = @(v, alvo, casas) all(all(abs(v - alvo) <= 0.5 * 10 .^ (-casas) + 1e-9));
r2 = @(x) round(100 * x) / 100;                  % arredondar a 2 casas
ok = true;
simnao = {'não', 'sim'};
fprintf('Complementos de IO — deck 6.3: população finita (M/M/R)\n');

% ------------------------------------------------------------ empilhadores
K = 10;  lam = 0.1;  mu = 0.8;  ct = 150;  cp = 250;
fprintf('\nEmpilhadores (K = %d, lambda = %g/dia, mu = %g/dia; técnico %d €/dia, parado %d €/dia)\n', ...
        K, lam, mu, ct, cp);
fprintf('  R  P0     L (parados)  Lq    a funcionar  W (dias)  custo (€/dia)\n');
res = cell(1, 3);
tab = zeros(3, 6);
for R = 1:3
  e = MmR(K, R, lam, mu);
  custo = ct * R + cp * e.L;
  res{R} = e;
  tab(R, :) = [e.P0 e.L e.Lq e.a_funcionar e.W custo];
  fprintf('  %d  %.3f  %.2f         %.2f  %.2f         %.2f      %.0f\n', ...
          R, e.P0, e.L, e.Lq, e.a_funcionar, e.W, custo);
end
[~, best] = min(tab(:, 6));
fprintf('  decisão: %d técnicos (%.0f €/dia), menos %.0f €/dia do que com um só\n', ...
        best, tab(best, 6), tab(1, 6) - tab(best, 6));
fprintf('  com um técnico, Wq = W - 1/mu = %.2f dias\n', res{1}.Wq);
dL = res{2}.L - res{3}.L;
fprintf('  o 3.º técnico tira %.1f empilhadores da paragem (%.1f €/dia) e custa %d €/dia\n', dL, cp * dL, ct);
ok = ok && confere(tab, [0.122 2.97 2.09 7.03 4.23 893; 0.283 1.35 0.26 8.65 1.55 636; ...
                         0.305 1.14 0.04 8.86 1.29 736], [3 2 2 2 2 0]) ...
     && best == 2 && round(tab(1, 6) - tab(2, 6)) == 257 && abs(r2(res{1}.Wq) - 2.98) < 1e-9 ...
     && abs(round(10 * dL) / 10 - 0.2) < 1e-9 && round(cp * dL / 10) * 10 == 50;

% ------------------------------------------------------------ população infinita?
fprintf('\nCom o modelo de população infinita: lambda = %g x %g = %g avarias/dia, mu = %g -> rho = %.2f (instável)\n', ...
        K, lam, K * lam, mu, K * lam / mu);
fprintf('Na lavandaria: lambda = 5 x 0.2 = %g por dia contra mu = 0.4 de cada mecânico\n', 5 * 0.2);
ok = ok && abs(K * lam / mu - 1.25) < 1e-12;

% ------------------------------------------------------------ Exemplo 3 (para resolver na aula)
l3 = MmR(5, 3, 0.2, 1 / 2.5);
l1 = MmR(5, 1, 0.2, 1 / (5 / 6));
fprintf('\nExemplo 3 — lavandaria (5 máquinas, lambda = 0.2/dia)\n');
fprintf('  opção                        P0      L       Lq      a funcionar  W (dias)  Wq (dias)\n');
nomes = {'3 mecânicos (mu = 0.4)     ', 'super-mecânico (mu = 1.2)  '};
opcoes = {l3, l1};
for j = 1:2
  l = opcoes{j};
  fprintf('  %s  %.4f  %.4f  %.4f  %.4f       %.4f    %.4f\n', nomes{j}, l.P0, l.L, l.Lq, l.a_funcionar, l.W, l.Wq);
end
if l1.L < l3.L, dec = 'trocar pelo super-mecânico'; else, dec = 'manter os 3 mecânicos'; end
fprintf('  decisão (mesmo salário): %s — menos máquinas paradas (%.2f contra %.2f)\n', dec, l1.L, l3.L);
ok = ok && abs(r2(l3.L) - 1.71) < 1e-9 && abs(r2(l1.L) - 1.16) < 1e-9 && l1.L < l3.L ...
     && abs(r2(l3.Wq) - 0.11) < 1e-9 && abs(r2(l1.Wq) - 0.68) < 1e-9 ...
     && abs(r2(l3.W) - 2.61) < 1e-9 && abs(r2(l1.W) - 1.51) < 1e-9;

fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
