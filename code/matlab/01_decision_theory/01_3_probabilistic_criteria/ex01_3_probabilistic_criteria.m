% EX01_3_PROBABILISTIC_CRITERIA  Reproduz os exemplos do deck 1.3 (critérios probabilísticos).
%
%   Linha de produção com h = (0.3, 0.5, 0.2): VE = 44.5, 52, 37 e POE = 21.5, 14, 29 -> a2;
%   VE + POE = 66 em todas as linhas; informação perfeita 66, VEIP = 66 - 52 = 14.
%   Sensibilidade: h1 = 0.3 fixo, t = h3, h2 = 0.7 - t: VE = 43.5 + 5t, 48 + 20t, 23 + 70t;
%   a decisão passa de a2 para a3 em t = 0.5 (VE = 58).
%   Para resolver na aula: Exemplo 3 (investimento) com h = (0.3, 0.5, 0.2):
%   VE = 0, 265, 116 e POE = 460, 195, 344 -> obrigações; VEIP = 195.
%
%   Complementos de IO — deck 1.3.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 1.3: critérios de decisão probabilísticos\n');
fmt = @(v) strjoin(arrayfun(@(x) sprintf('%.4g', x*(abs(x) > 1e-9)), v, 'UniformOutput', false), '  ');
h = [0.3 0.5 0.2];
casos = {'Linha de produção', [40 45 50; 20 60 80; -40 50 120], {'a1 pequena', 'a2 média', 'a3 grande'}
         'Exemplo 3 (investimento)', [1000 0 -1500; 350 200 300; 220 100 0], {'ações', 'obrigações', 'títulos'}};
ok = true;
for c = 1:2
  [titulo, C, nomes] = casos{c, :};
  r = Risco(C, h);
  fprintf('\n%s, h = (%g, %g, %g)\n', titulo, h);
  fprintf('  VE : %s -> %s\n', fmt(r.VE), strjoin(nomes(r.escolha_VE), ', '));
  fprintf('  POE: %s -> %s\n', fmt(r.POE), strjoin(nomes(r.escolha_POE), ', '));
  fprintf('  VE + POE: %s (igual em todas as linhas)\n', fmt(r.soma));
  fprintf('  com informação perfeita: %.4g;  VEIP = %.4g\n', r.info_perfeita, r.VEIP);
  if c == 1
    ok = ok && max(abs(r.VE - [44.5 52 37])) < 1e-9 && max(abs(r.POE - [21.5 14 29])) < 1e-9 ...
         && max(abs(r.soma - 66)) < 1e-9 && abs(r.VEIP - 14) < 1e-9 && isequal(r.escolha_VE, 2);
    % sensibilidade: VE_i(t) = 0.3 c_i1 + (0.7 - t) c_i2 + t c_i3 = a_i + b_i t
    a = 0.3*C(:,1) + 0.7*C(:,2);  b = C(:,3) - C(:,2);
    txt = arrayfun(@(i) sprintf('%.4g + %.4gt', a(i), b(i)), 1:3, 'UniformOutput', false);
    fprintf('\nSensibilidade (h1 = 0.3, t = h3): VE = %s\n', strjoin(txt, ', '));
    [lim, quem] = IntervalosRetas(a, b, 0, 0.7);
    for j = 1:size(lim, 1)
      fprintf('  t em [%.2f, %.2f]: %s\n', lim(j,1), lim(j,2), strjoin(nomes(quem{j}), ', '));
    end
    ok = ok && max(abs(a' - [43.5 48 23])) < 1e-9 && max(abs(b' - [5 20 70])) < 1e-9 ...
         && max(abs(lim(:) - [0; 0.5; 0.5; 0.7])) < 1e-9 && isequal(quem, {2, 3});
  else
    ok = ok && max(abs(r.VE - [0 265 116])) < 1e-9 && max(abs(r.POE - [460 195 344])) < 1e-9 ...
         && abs(r.VEIP - 195) < 1e-9 && isequal(r.escolha_VE, 2) && isequal(r.escolha_POE, 2);
  end
end
simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
