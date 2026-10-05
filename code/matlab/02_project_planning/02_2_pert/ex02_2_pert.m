% EX02_2_PERT  Reproduz os exemplos do deck 2.2 (planeamento de projetos: PERT).
%
%   Slide «Quando as durações são incertas»: B com (2, 3, 10) => te = 4, var = 1.78.
%   Laboratório com três estimativas: T = 13, crítico A, C, D, F, H, var = 0.556, sd = 0.745;
%   P(T <= 14) = P(Z <= 1.34) = 0.91; A--B--F--H tem var 2.111 e P(A--B--F--H <= 14) = 0.92.
%   Slide «Simulação: 200 000 projetos» (Beta-PERT, semente 2026): média 13.2;
%   P(T <= 13, 14, 15) = 41%, 80%, 96% (PERT: 50%, 91%, 99.6%); A--B--F--H é o mais longo em 23%.
%   Para resolver na aula: Exemplo PERT, T = 17, crítico C, F, H, J, P(T <= 22) = 0.989.
%
%   Os números aleatórios do MATLAB/Octave não são os do numpy: a simulação compara-se
%   com os slides com tolerância (os valores arredondados costumam coincidir).
%
%   Complementos de IO — deck 2.2.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 2.2: planeamento de projetos (PERT)\n');
ok = true;

% ------------------------------------------------------------ uma atividade
teB = (2 + 4*3 + 10)/6;  vB = ((10 - 2)/6)^2;
fprintf('\nEncomenda do equipamento (B): to = 2, tm = 3, tp = 10 -> te = %g, var = %.3f\n', teB, vB);
ok = ok && teB == 4 && abs(vB - 1.778) < 1e-3;

% projetos: uma linha por atividade, {nome, {precedentes}, to, tm, tp}
LAB = {'A', {}, 2, 3, 4;  'B', {'A'}, 2, 3, 10;  'C', {'A'}, 1, 2, 3;  'D', {'C'}, 2, 3, 4;
       'E', {'C'}, 1, 2, 3;  'F', {'B', 'D', 'E'}, 2, 3, 4;  'G', {'D'}, 1, 2, 3;  'H', {'F', 'G'}, 1, 2, 3};
PEX = {'A', {}, 5, 6, 7;  'B', {}, 1, 3, 5;  'C', {}, 1, 4, 7;  'D', {'A'}, 1, 2, 3;
       'E', {'B'}, 1, 2, 9;  'F', {'C'}, 1, 5, 9;  'G', {'C'}, 2, 2, 8;  'H', {'E', 'F'}, 4, 4, 10;
       'I', {'D'}, 2, 5, 8;  'J', {'H', 'G'}, 2, 2, 8};
casos = {'Laboratório com três estimativas', LAB, [13 14 15], 14
         'Exemplo PERT (para resolver na aula)', PEX, 22, 22};
for c = 1:2
  [titulo, P, alvos, xcam] = casos{c, :};
  nomes = P(:, 1)';
  [te, v, T, crit] = Pert(P);
  s2 = sum(v(crit));
  fprintf('\n%s\n', titulo);
  fprintf('  ativ.  to  tm  tp     te    var\n');
  for i = 1:size(P, 1)
    fprintf('  %-5s %3g %3g %3g %6.4g %6.3f\n', nomes{i}, P{i, 3}, P{i, 4}, P{i, 5}, te(i), v(i));
  end
  fprintf('  duração esperada: %g semanas; caminho crítico: %s\n', T, strjoin(nomes(crit), ', '));
  fprintf('  var = %.3f; sd = %.3f\n', s2, sqrt(s2));
  prob = zeros(size(alvos));
  for k = 1:numel(alvos)
    z = (alvos(k) - T)/sqrt(s2);
    prob(k) = Phi(z);
    fprintf('  P(T <= %g) = Phi(%.3f) = %.4f\n', alvos(k), z, Phi(z));
  end
  acts = [P(:, 1:2), num2cell(te(:))];
  cam = Caminhos(acts);
  mu = cellfun(@(p) sum(te(p)), cam);
  vc = cellfun(@(p) sum(v(p)), cam);
  for k = 1:numel(cam)
    fprintf('  caminho %-14s mu = %-3g var = %.3f  P(<= %g) = %.4f\n', ...
            strjoin(nomes(cam{k}), '--'), mu(k), vc(k), xcam, Phi((xcam - mu(k))/sqrt(vc(k))));
  end
  camtxt = cellfun(@(p) strjoin(nomes(p), '--'), cam, 'UniformOutput', false);

  if c == 1
    ok = ok && max(abs(te - [3 4 2 3 2 3 2 2])) < 1e-9 && abs(T - 13) < 1e-9 ...
         && isequal(crit, [1 3 4 6 8]) && abs(s2 - 0.556) < 1e-3 && abs(sqrt(s2) - 0.745) < 1e-3 ...
         && round(100/sqrt(s2))/100 == 1.34 && round(prob(2)*100)/100 == 0.91 ...
         && round(prob(1)*1000)/1000 == 0.5 && round(prob(3)*1000)/1000 == 0.996;
    j = find(strcmp(camtxt, 'A--B--F--H'));
    ok = ok && abs(mu(j) - 12) < 1e-9 && abs(vc(j) - 2.111) < 1e-3 && round(Phi(2/sqrt(vc(j)))*100)/100 == 0.92;

    % ------------------------------------------------------------ simulação
    N = 200000;
    [Tsim, D] = SimulaPert(LAB, N, 2026);
    xs = [13 14 15];
    psim = arrayfun(@(x) mean(Tsim <= x), xs);
    fprintf('\nSimulação: %d projetos, durações Beta-PERT, semente 2026\n', N);
    fprintf('                 PERT    simulação\n');
    fprintf('  duração média  %.1f    %.1f\n', T, mean(Tsim));
    for k = 1:3
      fprintf('  P(T <= %g)     %.1f%%   %.0f%%\n', xs(k), 100*prob(k), 100*psim(k));
    end
    camL = Caminhos(LAB);
    L = zeros(N, numel(camL));
    for k = 1:numel(camL), L(:, k) = sum(D(:, camL{k}), 2); end
    [~, arg] = max(L, [], 2);
    freq = arrayfun(@(k) mean(arg == k), 1:numel(camL));
    txt = arrayfun(@(k) sprintf('%s %.0f%%', strjoin(nomes(camL{k}), '--'), 100*freq(k)), 1:numel(camL), ...
                   'UniformOutput', false);
    fprintf('  caminho mais longo nos sorteios: %s\n', strjoin(txt, '; '));
    % histograma do slide (densidade por intervalo de meia semana, de 10 a 18)
    hist_slide = [0.001 0.008 0.0404 0.1248 0.2606 0.3938 0.427 0.3468 ...
                  0.2122 0.1014 0.046 0.0212 0.0098 0.0044 0.0018 0.0004];
    dens = arrayfun(@(x) mean(Tsim >= x & Tsim < x + 0.5)/0.5, 10:0.5:17.5);
    hist_ok = max(abs(dens - hist_slide)) < 0.01;
    simnao = {'não', 'sim'};
    fprintf('  histograma igual ao do slide (tolerância 0.01): %s\n', simnao{hist_ok + 1});
    ok = ok && abs(mean(Tsim) - 13.2) < 0.05 && all(abs(psim - [0.41 0.80 0.96]) < 0.01) ...
         && abs(freq(1) - 0.23) < 0.01 && hist_ok;
  else
    ok = ok && abs(T - 17) < 1e-9 && isequal(crit, [3 6 8 10]) && abs(s2 - 4.778) < 1e-3 ...
         && round(prob(1)*1000)/1000 == 0.989 ...
         && isequal(camtxt, {'A--D--I', 'B--E--H--J', 'C--F--H--J', 'C--G--J'}) ...
         && max(abs(mu - [13 14 17 10])) < 1e-6 && max(abs(round(vc*1000)/1000 - [1.222 4.222 4.778 3])) < 1e-9;
  end
end

simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
