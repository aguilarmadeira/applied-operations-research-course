% EX07_2_SHORTAGES_DISCOUNTS  Reproduz os exemplos do deck 7.2 (rutura planeada e descontos de quantidade).
%
%   Tinta premium com rutura (D = 1200 latas/ano, Ca = 50 €, Ce = 80 €, Cp = 10 €, Cr = 30 €, prazo 1 semana):
%   rho = 0,75, Q* = 160, S* = 120, rutura máxima 40, ciclo 1,6 meses (6,9 semanas), 5,2 / 1,7 semanas,
%   Pe = 23,1 - 40 = -16,9, 7,5 encomendas/ano; encomenda 600 + posse 450 + rutura 150 = 1200 €
%   contra 1385,64 € sem rutura (poupa 185,64 €, 13 %); custo total 61 200 €.
%   Descontos no dióxido de titânio: 49 697,06, 48 324, 48 180 € -> encomendar 6000 kg
%   (poupa 1517 € face à QEE sem desconto; só 144 € abaixo de 3000 kg).
%   Para resolver na aula: Exemplo 3 (loja AAA -> 400 unidades, 3453,19 €) e
%   Exemplo 4 (componentes -> 6000, 1 419 975 u.m., 2,5 encomendas/ano, ciclo 0,4 anos).
%
%   Complementos de IO — deck 7.2.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 7.2: rutura planeada e descontos de quantidade\n');
ok = true;

% ------------------------------------------------------------ tinta premium com rutura
r = Rutura(1200, 80, 10, 30, 50, 1/52);
fprintf('\nTinta premium com rutura (D = 1200 latas/ano, Ce = 80, Cp = 10, Cr = 30, Ca = 50, prazo 1 semana)\n');
fprintf('  rho = %.2f;  Q* = %.2f;  S* = %.2f;  rutura máxima %.2f\n', r.rho, r.Q, r.S, r.R);
fprintf('  ciclo %.2f meses (%.2f semanas);  com stock %.2f semanas, em rutura %.2f semanas\n', ...
        r.T * 12, r.T * 52, r.T1 * 52, r.T2 * 52);
fprintf('  ponto de encomenda %.2f - %.2f = %.2f;  %.2f encomendas por ano\n', 1200 / 52, r.R, r.Pe, r.n);
s = Qee(1200, 80, 10);
gs = s.Kenc + s.Kpos;
gr = r.Kenc + r.Kpos + r.Krut;
fprintf('  €/ano         com rutura  sem rutura\n');
fprintf('  encomenda     %10.2f  %10.2f\n', r.Kenc, s.Kenc);
fprintf('  posse         %10.2f  %10.2f\n', r.Kpos, s.Kpos);
fprintf('  rutura        %10.2f\n', r.Krut);
fprintf('  soma          %10.2f  %10.2f\n', gr, gs);
fprintf('  poupança %.2f €/ano (%.1f%%);  compra %.0f;  custo total %.2f\n', gs - gr, 100 * (1 - gr / gs), r.Kaq, r.K);
r1 = @(x) round(10 * x) / 10;                      % arredonda a uma casa decimal
ok = ok && abs(r.rho - 0.75) < 1e-12 && abs(r.Q - 160) < 1e-9 && abs(r.S - 120) < 1e-9 ...
     && abs(r.R - 40) < 1e-9 && abs(r.T * 12 - 1.6) < 1e-9 && abs(r1(r.T * 52) - 6.9) < 1e-9 ...
     && abs(r1(r.T1 * 52) - 5.2) < 1e-9 && abs(r1(r.T2 * 52) - 1.7) < 1e-9 && abs(r1(r.Pe) + 16.9) < 1e-9 ...
     && abs(r.n - 7.5) < 1e-9 && abs(r.Kenc - 600) < 1e-9 && abs(r.Kpos - 450) < 1e-9 ...
     && abs(r.Krut - 150) < 1e-9 && abs(gs - 1385.64) < 0.005 && abs(gs - gr - 185.64) < 0.005 ...
     && round(100 * (1 - gr / gs)) == 13 && abs(r.K - 61200) < 1e-6;

% ------------------------------------------------------------ os três problemas de descontos
casos = {
  'Descontos no dióxido de titânio', 12000, 150, 0.2, [0 2999 4; 3000 5999 3.88; 6000 1e9 3.8]
  'Exemplo 3, loja AAA (D = 21 x 52 por ano)', 21 * 52, 20, 0.25, ...
      [0 399 3.2; 400 899 3.2 * 0.93; 900 1999 3.2 * 0.9; 2000 1e9 3.2 * 0.85]
  'Exemplo 4, componentes importados', 15000, 150, 0.2, ...
      [0 999 100; 1000 2999 95; 3000 5999 94; 6000 8999 91; 9000 1e9 90]};
res = cell(3, 2);
for c = 1:3
  [titulo, D, Ce, I, esc] = casos{c, :};
  [L, b] = Descontos(D, Ce, I, esc);
  res(c, :) = {L, b};
  fprintf('\n%s: D = %g, Ce = %g, posse %g%% do preço\n', titulo, D, Ce, 100 * I);
  fprintf('  escalão        preço      QEE  Q usado         compra  encomenda      posse          total\n');
  for j = 1:numel(L)
    if L(j).hi >= 1e9
      e = sprintf('%g+', L(j).lo);
    else
      e = sprintf('%g-%g', L(j).lo, L(j).hi);
    end
    Cp = I * L(j).Ca;
    fprintf('  %-11s %8.4g %8.1f %8.1f %14.2f %10.2f %10.2f %14.2f\n', ...
            e, L(j).Ca, L(j).Q, L(j).Qf, D * L(j).Ca, D * Ce / L(j).Qf, Cp * L(j).Qf / 2, L(j).K);
  end
  fprintf('  -> encomendar %.0f: custo %.2f;  %.2f encomendas por ano;  ciclo T = Q/D = %.4f\n', ...
          b.Qf, b.K, D / b.Qf, b.Qf / D);
  if c == 1
    fprintf('  poupa %.2f €/ano face à QEE sem desconto;  %.2f abaixo de 3000 kg\n', L(1).K - b.K, L(2).K - b.K);
  elseif c == 2
    fprintf('  ciclo %.1f semanas\n', 52 * b.Qf / D);
  else
    fprintf('  ciclo %.1f anos = %.1f meses\n', b.Qf / D, 12 * b.Qf / D);
  end
end
r2 = @(x) round(100 * x) / 100;                    % arredonda a duas casas decimais
[L, b] = res{1, :};
ok = ok && isequal(round([L.Q]), [2121 2154 2176]) && isequal(round([L.Qf]), [2121 3000 6000]) ...
     && abs(L(1).K - 49697.06) < 0.005 && abs(L(2).K - 48324) < 1e-6 && abs(L(3).K - 48180) < 1e-6 ...
     && b.Qf == 6000 && round(L(1).K - b.K) == 1517 && abs(L(2).K - b.K - 144) < 1e-6;
[L, b] = res{2, :};
ok = ok && max(abs(r2([L.K]) - [3681.33 3453.19 3493.23 3661.16])) < 1e-9 && b.Qf == 400 ...
     && max(abs(r1([L.Q]) - [233.7 242.3 246.3 253.4])) < 1e-9 ...
     && abs(r2(21 * 52 / b.Qf) - 2.73) < 1e-9 && abs(r1(52 * b.Qf / (21 * 52)) - 19.0) < 1e-9;
[L, b] = res{3, :};
ok = ok && max(abs(r2([L.K]) - [1509486.83 1436750 1438950 1419975 1431250])) < 1e-6 && b.Qf == 6000 ...
     && max(abs(r1([L.Q]) - [474.3 486.7 489.2 497.2 500.0])) < 1e-9 ...
     && abs(15000 / b.Qf - 2.5) < 1e-12 && abs(b.Qf / 15000 - 0.4) < 1e-12;

simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
