% EX07_3_PRODUCTION  Reproduz os exemplos do deck 7.3 (produção e consumo simultâneos).
%
%   Tinta de interior (D = 24 000 L/ano, P = 60 000 L/ano, Ce = 900 €, custo 2 €/L, Cp = 0,25 x 2 = 0,50 €/L/ano):
%   Q* = 9295 x sqrt(60/36) = 12 000 L, stock máximo 7200 L, 2,4 meses a produzir, ciclo 6 meses, 2 lotes/ano,
%   preparação + posse = 1800 + 1800 = 3600 €, custo total 51 600 €.
%   Comparação: lote de uma vez (QEE) 9295 L e 4648 €/ano; o lote ótimo aumenta 29 %; linha ocupada 40 %.
%   Para resolver na aula (ano de 300 dias, preparação de 5 dias):
%   Exemplo 5 (resina): Q* = 1400 t, Smax = 350 t, T = 28 dias, Tp = 21 dias, lançamento a 250 t, K = 302 100 000;
%   Exemplo 6: Q* = 3487,1 t, Smax = 697,4 t, T = 52,3 dias, Tp = 41,85 dias, lançamento a 333,3 t, K = 100 871 779,8.
%
%   Complementos de IO — deck 7.3.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 7.3: produção e consumo simultâneos\n');
ok = true;
r1 = @(x) round(10 * x) / 10;                      % arredonda a uma casa decimal

% ------------------------------------------------------------ tinta de interior
D = 24000;  P = 60000;  Ce = 900;  Ca = 2;
Cp = 0.25 * Ca;
p = Producao(D, P, Ce, Cp, Ca);
qs = Qee(D, Ce, Cp);
gs = qs.Kenc + qs.Kpos;
fprintf('\nTinta de interior (D = %d L/ano, P = %d L/ano, Ce = %d, Cp = %.2f)\n', D, P, Ce, Cp);
fprintf('  Q* = %.2f x %.4f = %.2f L;  stock máximo %.2f L\n', qs.Q, sqrt(P / (P - D)), p.Q, p.Smax);
fprintf('  tempo a produzir %.2f meses;  ciclo %.2f meses;  %.2f lotes por ano\n', p.Tp * 12, p.T * 12, p.n);
fprintf('  preparação %.2f + posse %.2f = %.2f €;  custo total (com produção) %.2f €\n', ...
        p.Kenc, p.Kpos, p.Kenc + p.Kpos, p.K);
fprintf('  lote de uma vez (QEE): Q = %.2f L, custo de gestão %.2f €;  lote ótimo +%.1f%%;  linha ocupada %.0f%%\n', ...
        qs.Q, gs, 100 * (p.Q / qs.Q - 1), 100 * D / P);
ok = ok && round(qs.Q) == 9295 && abs(p.Q - 12000) < 1e-6 && abs(p.Smax - 7200) < 1e-6 ...
     && abs(p.Tp * 12 - 2.4) < 1e-9 && abs(p.T * 12 - 6) < 1e-9 && abs(p.n - 2) < 1e-9 ...
     && abs(p.Kenc - 1800) < 1e-6 && abs(p.Kpos - 1800) < 1e-6 && abs(p.K - 51600) < 1e-6 ...
     && round(gs) == 4648 && round(100 * (p.Q / qs.Q - 1)) == 29 && round(100 * sqrt(60 / 36)) == 129;

% ------------------------------------------------------------ Exemplos 5 e 6 (para resolver na aula)
casos = {'Exemplo 5 (resina)', 20000, 15000, 98000, 20000, 0.3
         'Exemplo 6',          25000, 20000, 76000,  5000, 0.25};
res = cell(1, 2);
for c = 1:2
  [nome, P_, D_, Ce_, Ca_, I] = casos{c, :};
  Cp_ = I * Ca_;
  r = Producao(D_, P_, Ce_, Cp_, Ca_, 5/300);
  res{c} = r;
  fprintf('\n%s: D = %d t/ano, P = %d t/ano, Ce = %d, Cp = %g x %d = %g (ano de 300 dias)\n', ...
          nome, D_, P_, Ce_, I, Ca_, Cp_);
  fprintf('  Q* = %.2f x %.4f = %.2f t;  stock máximo %.2f t\n', ...
          sqrt(2 * D_ * Ce_ / Cp_), sqrt(P_ / (P_ - D_)), r.Q, r.Smax);
  fprintf('  ciclo %.2f dias;  a produzir %.2f dias;  sem produção %.2f dias;  %.2f lotes por ano\n', ...
          r.T * 300, r.Tp * 300, (r.T - r.Tp) * 300, r.n);
  fprintf('  ponto de lançamento da produção %.2f t (preparação de 5 dias)\n', r.Pl);
  fprintf('  produção %.2f + preparação %.2f + posse %.2f = %.2f por ano\n', D_ * Ca_, r.Kenc, r.Kpos, r.K);
end
[r5, r6] = res{:};
ok = ok && abs(r5.Q - 1400) < 1e-6 && abs(r5.Smax - 350) < 1e-6 && abs(r5.T * 300 - 28) < 1e-9 ...
     && abs(r5.Tp * 300 - 21) < 1e-9 && abs(r5.Pl - 250) < 1e-9 && abs(r5.K - 302100000) < 1e-3 ...
     && abs(r1(r5.n) - 10.7) < 1e-9;
ok = ok && abs(r1(r6.Q) - 3487.1) < 1e-9 && abs(r1(r6.Smax) - 697.4) < 1e-9 && abs(r1(r6.T * 300) - 52.3) < 1e-9 ...
     && abs(r6.Tp * 300 - 41.85) < 0.005 && abs(r1(r6.Pl) - 333.3) < 1e-9 && abs(r1(r6.K) - 100871779.8) < 1e-6 ...
     && abs(r1(r6.n) - 5.7) < 1e-9 && abs(r1((r6.T - r6.Tp) * 300) - 10.5) < 1e-9;

simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
