% EX07_1_ABC_EOQ  Reproduz os exemplos do deck 7.1 (classificação ABC e QEE).
%
%   Fábrica de tintas, ABC: total 120 300 €/ano; A: P1, P2, P3 (78,8 %); B: P4, P5; C: P6–P10.
%   Dióxido de titânio (D = 12 000 kg/ano, Ce = 150 €, Cp = 0,2 x 4 = 0,80 €/kg/ano, prazo 2 semanas):
%   Q* = 2121 kg, 5,66 encomendas/ano, ciclo 9,2 semanas, encomenda + posse 1697,06 €, K = 49 697,06 €,
%   ponto de encomenda 461,5 kg.
%   Robustez: Q = 1500, 2000, 2500, 3000 -> 1800, 1700, 1720, 1800 €; com D = 14 400 e Q = 2121:
%   1866,76 € contra 1859,03 € do ótimo (+0,4 %).
%   Para resolver na aula: Exemplo 1 (ABC, total 62 498; A: A1, A8, A3; B: A2, A5) e
%   Exemplo 2 (transístores: Cp = 5,50, Q* = 988, K = 198 094, 4 semanas, Pe = 494, 13 encomendas).
%
%   Complementos de IO — deck 7.1.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 7.1: classificação ABC e quantidade económica de encomenda\n');
ok = true;

% ------------------------------------------------------------ ABC da fábrica de tintas
nomes = {'P1', 'P2', 'P3', 'P4', 'P5', 'P6', 'P7', 'P8', 'P9', 'P10'};
v = [4 3.2 0.9 25 1.1 12 0.15 0.03 0.05 3];
q = [12000 9000 20000 400 6000 300 18000 40000 22000 100];
[tot, L] = Abc(nomes, v, q);
fprintf('\n%s: total %.2f\n', 'ABC da fábrica de tintas (€/ano)', tot);
fprintf('  artigo  valor/un.  quantidade      valor      %%  acum.  classe\n');
for j = 1:numel(L)
  l = L(j);
  fprintf('  %-6s %10.2f %11.0f %10.2f %6.1f %6.1f  %s\n', l.nome, l.v, l.q, l.valor, l.pct, l.acum, l.classe);
end
cl = struct('A', {{}}, 'B', {{}}, 'C', {{}});
for c = 'ABC'
  cl.(c) = {L([L.classe] == c).nome};
end
fprintf('  A: %s;  B: %s;  C: %s\n', strjoin(cl.A, ', '), strjoin(cl.B, ', '), strjoin(cl.C, ', '));
ok = ok && abs(tot - 120300) < 1e-6 && isequal(cl.A, {'P1', 'P2', 'P3'}) && isequal(cl.B, {'P4', 'P5'}) ...
     && isequal(cl.C, {'P6', 'P7', 'P8', 'P9', 'P10'}) && abs(L(3).acum - 78.8) < 0.05 ...
     && abs(L(5).acum - 92.6) < 0.05 && abs(L(6).acum - 95.6) < 0.05;

% ------------------------------------------------------------ QEE do dióxido de titânio
D = 12000;  Ce = 150;  Ca = 4;
Cp = 0.2 * Ca;
r = Qee(D, Ce, Cp, Ca, 2/52);
g = r.Kenc + r.Kpos;
fprintf('\nQEE do dióxido de titânio (D = %d kg/ano, Ce = %d €, Cp = %.2f €/kg/ano, prazo 2 semanas)\n', D, Ce, Cp);
fprintf('  Q* = %.2f kg;  encomendas por ano %.2f;  ciclo %.1f semanas\n', r.Q, r.n, r.T * 52);
fprintf('  encomenda %.2f + posse %.2f = %.2f €;  custo total (com compra) %.2f €\n', r.Kenc, r.Kpos, g, r.K);
fprintf('  ponto de encomenda %.1f kg\n', r.Pe);
ok = ok && abs(r.Q - 2121.32) < 0.01 && abs(r.n - 5.66) < 0.005 && abs(r.T * 52 - 9.2) < 0.05 ...
     && abs(g - 1697.06) < 0.005 && abs(r.K - 49697.06) < 0.005 && abs(r.Pe - 461.5) < 0.05;

% ------------------------------------------------------------ robustez
fprintf('\nRobustez (encomenda + posse)\n');
Qs = [1500 2000 2500 3000];
esperado = [1800 1700 1720 1800];
for j = 1:4
  gQ = CustoQee(Qs(j), D, Ce, Cp);
  fprintf('  Q = %4d: %.2f €  (+%.2f%%)\n', Qs(j), gQ, 100 * (gQ / g - 1));
  ok = ok && abs(gQ - esperado(j)) < 1e-6;
end
g14 = CustoQee(r.Q, 14400, Ce, Cp);
r14 = Qee(14400, Ce, Cp);
o14 = r14.Kenc + r14.Kpos;
fprintf('  D = 14400 com Q = %.0f: %.2f €;  ótimo (Q = %.0f): %.2f €  (+%.1f%%)\n', ...
        r.Q, g14, r14.Q, o14, 100 * (g14 / o14 - 1));
ok = ok && abs(g14 - 1866.76) < 0.005 && abs(o14 - 1859.03) < 0.005 && round(1000 * (g14 / o14 - 1)) == 4;

% ------------------------------------------------------------ Exemplo 1 (para resolver na aula)
nomes1 = {'A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'A10'};
v1 = [1 12 4.25 0.25 2.25 26 8.5 0.5 1.25 0.12];
q1 = [22000 410 1468 3500 1600 10 124 40000 440 25000];
[tot1, L1] = Abc(nomes1, v1, q1);
fprintf('\n%s: total %.2f\n', 'Exemplo 1 (ABC)', tot1);
fprintf('  artigo  valor/un.  quantidade      valor      %%  acum.  classe\n');
for j = 1:numel(L1)
  l = L1(j);
  fprintf('  %-6s %10.2f %11.0f %10.2f %6.1f %6.1f  %s\n', l.nome, l.v, l.q, l.valor, l.pct, l.acum, l.classe);
end
cl1 = struct('A', {{}}, 'B', {{}}, 'C', {{}});
for c = 'ABC'
  cl1.(c) = {L1([L1.classe] == c).nome};
end
fprintf('  A: %s;  B: %s;  C: %s\n', strjoin(cl1.A, ', '), strjoin(cl1.B, ', '), strjoin(cl1.C, ', '));
ok = ok && abs(tot1 - 62498) < 1e-6 && isequal(cl1.A, {'A1', 'A8', 'A3'}) && isequal(cl1.B, {'A2', 'A5'}) ...
     && isequal(cl1.C, {'A10', 'A7', 'A4', 'A9', 'A6'}) && abs(L1(6).acum - 95.6) < 0.05;

% ------------------------------------------------------------ Exemplo 2 (para resolver na aula)
Cp2 = 3.25 + 0.15 * 15;
r2 = Qee(12844, 209, Cp2, 15, 2/52);
fprintf('\nExemplo 2 (caixa de transístores): Cp = 3.25 + 0.15 x 15 = %.2f\n', Cp2);
fprintf('  a) Q* = %.2f;  b) custo anual %.2f (compra %.0f + encomenda %.2f + posse %.2f)\n', ...
        r2.Q, r2.K, 12844 * 15, r2.Kenc, r2.Kpos);
fprintf('  c) ciclo %.2f semanas;  d) ponto de encomenda %.2f;  e) %.2f encomendas por ano\n', ...
        r2.T * 52, r2.Pe, r2.n);
fprintf('  f) posse / encomenda = %.4f\n', r2.Kpos / r2.Kenc);
ok = ok && round(r2.Q) == 988 && round(r2.K) == 198094 && round(r2.T * 52) == 4 ...
     && round(r2.Pe) == 494 && round(r2.n) == 13 && round(r2.Kenc) == 2717 && abs(r2.Kpos / r2.Kenc - 1) < 1e-12;

simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
