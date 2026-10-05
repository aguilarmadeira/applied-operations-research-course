% EX06_1_MM1  Reproduz os exemplos do deck 6.1 (conceitos, lei de Little e M/M/1).
%
%   Exemplo-guia: posto de carregamento rápido com um carregador, lambda = 3 carros/h, mu = 4/h:
%       rho = 0.75, P0 = 0.25, L = 3, Lq = 2.25, W = 1 h, Wq = 45 min; Pn = 0.25*0.75^n;
%       P(n>=1) = 75%, P(n>=3) = 42%, P(n>=8) = 10%; Little na loja (40/120 h = 20 min).
%   Efeito da utilização: lambda = 2, 2.5, 3, 3.5, 3.8 -> Wq = 15, 25, 45, 105, 285 min.
%   Cauda: 95% esperam menos de 2.71 h; a simulação (SimulaMms(3, 4, 1), o código do slide)
%   compara-se com as fórmulas com tolerância (o gerador do MATLAB/Octave não é o do numpy,
%   por isso os números simulados não são os do slide, 45.5 min, 0.75 e 2.72 h).
%   Para resolver na aula: Exemplo 1 (controlo de bagagens, lambda = 10/min, mu = 12/min):
%   83.3%, 69.4%, 4.17 passageiros, 30 s.
%
%   Complementos de IO — deck 6.1.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

ok = true;
simnao = {'não', 'sim'};
fprintf('Complementos de IO — deck 6.1: filas de espera, lei de Little e M/M/1\n');

% ------------------------------------------------------------ posto de carregamento
lam = 3;  mu = 4;
m = Mm1(lam, mu);
fprintf('\nPosto de carregamento rápido (M/M/1, lambda = %g/h, mu = %g/h)\n', lam, mu);
fprintf('  rho = %.4g  P0 = %.4g  L = %.4g  Lq = %.4g  W = %.4g h  Wq = %.4g min\n', ...
        m.rho, m.P0, m.L, m.Lq, m.W, m.Wq * 60);
fprintf('  Little: lambda*W = %.4g (= L);  lambda*Wq = %.4g (= Lq)\n', lam * m.W, lam * m.Wq);
Pn = m.Pn(0:8);
fprintf('  Pn, n = 0..8: %s\n', strjoin(arrayfun(@(x) sprintf('%.4f', x), Pn, 'UniformOutput', false), ' '));
pmaior = m.rho .^ [1 3 8];                      % P(n >= k) = rho^k
fprintf('  P(n>=1) = %.0f%%  P(n>=3) = %.0f%%  P(n>=8) = %.0f%%\n', 100 * pmaior);
fprintf('Little na loja: 40 clientes, 120 entradas/h -> %.4g min por cliente\n', 40 / 120 * 60);
ok = ok && max(abs([m.rho m.P0 m.L m.Lq m.W m.Wq * 60] - [0.75 0.25 3 2.25 1 45])) < 1e-9 ...
     && max(abs(round(Pn * 1e4) / 1e4 - [0.25 0.1875 0.1406 0.1055 0.0791 0.0593 0.0445 0.0334 0.025])) < 1e-9 ...
     && max(abs(round(pmaior * 100) / 100 - [0.75 0.42 0.10])) < 1e-9;

% ------------------------------------------------------------ efeito da utilização
fprintf('\nO efeito da utilização (mu = 4/h)\n');
lams = [2 2.5 3 3.5 3.8];
Wq = zeros(size(lams));
for j = 1:numel(lams)
  x = Mm1(lams(j), mu);
  Wq(j) = x.Wq * 60;
  fprintf('  lambda = %.1f/h  rho = %.3f  Wq = %.4g min\n', lams(j), x.rho, Wq(j));
end
fprintf('  3 -> 3.5 carros/h (+%.0f%%): Wq passa de %.4g para %.4g min (x%.2f)\n', ...
        100 * 0.5 / 3, Wq(3), Wq(4), Wq(4) / Wq(3));
ok = ok && max(abs(Wq - [15 25 45 105 285])) < 1e-9;

% ------------------------------------------------------------ cauda e simulação
t95 = log(m.rho / 0.05) / (mu - lam);           % rho*exp(-(mu - lam) t) = 0.05
fprintf('\nCauda: P(Wq > t) = rho*exp(-(mu - lambda)*t); 95%% esperam menos de %.2f h\n', t95);
sim = SimulaMms(lam, mu, 1);
fprintf('Simulação (SimulaMms(3, 4, 1): 200000 carros, semente 1, sem os 10000 primeiros)\n');
fprintf('  Wq = %.1f min (fórmula %.4g)  P(esperar) = %.2f (%.2f)  quantil 95%% = %.2f h (%.2f)\n', ...
        sim.Wq * 60, m.Wq * 60, sim.Pw, m.rho, sim.p95, t95);
tol = abs(sim.Wq - m.Wq) <= 0.10 * m.Wq && abs(sim.Pw - m.rho) <= 0.02 && abs(sim.p95 - t95) <= 0.10 * t95;
fprintf('  simulação dentro da tolerância (10%% nas médias e no quantil, 0.02 nas probabilidades): %s\n', ...
        simnao{tol + 1});
ok = ok && abs(round(t95 * 100) / 100 - 2.71) < 1e-9 && tol;

% ------------------------------------------------------------ Exemplo 1 (para resolver na aula)
b = Mm1(10, 12);
fprintf('\nExemplo 1 — controlo de bagagens (lambda = 10/min, mu = 12/min)\n');
fprintf('  a) P(máquina não ociosa) = rho = %.4f (%.1f%%)\n', b.rho, 100 * b.rho);
fprintf('  b) P(haver fila) = P(n>=2) = rho^2 = %.4f (%.1f%%)\n', b.rho ^ 2, 100 * b.rho ^ 2);
fprintf('  c) Lq = %.4f passageiros\n', b.Lq);
fprintf('  d) W = %.4g min = %.4g s (Wq = %.4g s mais o controlo)\n', b.W, b.W * 60, b.Wq * 60);
ok = ok && abs(round(1000 * b.rho) / 10 - 83.3) < 1e-9 && abs(round(1000 * b.rho ^ 2) / 10 - 69.4) < 1e-9 ...
     && abs(b.Lq - 25 / 6) < 1e-9 && abs(b.W * 60 - 30) < 1e-9;

fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
