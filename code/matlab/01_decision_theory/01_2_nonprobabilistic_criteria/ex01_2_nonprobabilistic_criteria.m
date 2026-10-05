% EX01_2_NONPROBABILISTIC_CRITERIA  Reproduz os exemplos do deck 1.2 (critérios não probabilísticos).
%
%   Exemplo-guia: capacidade de uma linha de produção (lucro, milhares de euros):
%       a1 pequena: 40, 45, 50;  a2 média: 20, 60, 80;  a3 grande: -40, 50, 120.
%   Maximax a3; Maximin a1; Laplace, Savage e Hurwicz (alpha = 0.5) a2;
%   Hurwicz: a1 para alpha < 0.4, a2 entre 0.4 e 0.6, a3 acima de 0.6 (com 0.7: 47, 62, 72).
%   Slide «Savage pode ser incoerente»: com uma 3.ª ação a escolha passa da Ação 1 à Ação 2.
%   Para resolver na aula: Exemplo 3 (investimento, Hurwicz 0.8) e o exercício a1–a4 (Hurwicz 0.7).
%   No fim, um exemplo de VerificaEscolhas (conferir respostas sem ver a resolução).
%
%   Complementos de IO — deck 1.2.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 1.2: critérios de decisão não probabilísticos\n');
crit = {'maximax', 'maximin', 'laplace', 'savage', 'hurwicz'};
fmt = @(v) strjoin(arrayfun(@(x) sprintf('%.4g', x), v, 'UniformOutput', false), '  ');
ok = true;

% os três casos: título, matriz, nomes, alpha
casos = {
  'Linha de produção (lucro, milhares de euros)', [40 45 50; 20 60 80; -40 50 120], ...
      {'a1 pequena', 'a2 média', 'a3 grande'}, 0.5
  'Exemplo 3 (investimento; subida, estável, descida)', [1000 0 -1500; 350 200 300; 220 100 0], ...
      {'ações', 'obrigações', 'títulos do tesouro'}, 0.8
  'Exercício (estimativas de ganhos)', [-50 0 80; -10 30 35; 60 45 -30; 90 40 45], ...
      {'a1', 'a2', 'a3', 'a4'}, 0.7};
res = cell(1, 3);
for c = 1:3
  [titulo, C, nomes, alpha] = casos{c, :};
  fprintf('\n%s\n', titulo);
  dom = Dominadas(C);
  if isempty(dom)
    fprintf('  dominadas: nenhuma\n');
  else
    txt = arrayfun(@(p) sprintf('%s (por %s)', nomes{dom(p,1)}, nomes{dom(p,2)}), 1:size(dom,1), 'UniformOutput', false);
    fprintf('  dominadas: %s\n', strjoin(txt, ', '));
  end
  res{c} = Criterios(C, alpha);
  for k = 1:5
    rot = crit{k};
    if k == 5, rot = sprintf('hurwicz (%.1f)', alpha); end
    r = res{c}.(crit{k});
    fprintf('  %-14s %-34s -> %s\n', rot, fmt(r.valores), strjoin(nomes(r.escolha), ', '));
  end
  if c == 1
    R = Arrependimentos(C);
    fprintf('  arrependimentos: %s\n', mat2str(R));
    h7 = Criterios(C, 0.7);
    fprintf('  Hurwicz com alpha = 0.7: %s -> %s\n', fmt(h7.hurwicz.valores), nomes{h7.hurwicz.escolha});
    [lim, quem] = IntervalosRetas(min(C, [], 2), max(C, [], 2) - min(C, [], 2));
    for j = 1:size(lim, 1)
      fprintf('  alpha em [%.2f, %.2f]: %s\n', lim(j,1), lim(j,2), strjoin(nomes(quem{j}), ', '));
    end
    ok = ok && isequal(R, [0 15 70; 20 0 40; 80 10 0]) && max(abs(h7.hurwicz.valores - [47 62 72])) < 1e-9 ...
         && isequal(h7.hurwicz.escolha, 3) && max(abs(lim(:) - [0; 0.4; 0.6; 0.4; 0.6; 1])) < 1e-9 ...
         && isequal(quem, {1, 2, 3});
  end
  if c == 1
    % Savage incoerente (entre a linha de produção e o Exemplo 3, como no deck)
    s2 = Criterios([60 -40; 70 -60]);  s3 = Criterios([60 -40; 70 -60; 90 -65]);
    fprintf('\nSavage incoerente: 2 ações, máx. arrependimentos %s -> Ação %d; com a Ação 3: %s -> Ação %d\n', ...
            mat2str(s2.savage.valores), s2.savage.escolha, mat2str(s3.savage.valores), s3.savage.escolha);
    ok = ok && s2.savage.escolha == 1 && s3.savage.escolha == 2 && isequal(s3.savage.valores, [30 20 25]);
  end
end
r1 = res{1};  r3 = res{2};  re = res{3};
ok = ok && isequal(r1.maximax.escolha, 3) && isequal(r1.maximin.escolha, 1) && isequal(r1.laplace.escolha, 2) ...
     && isequal(r1.savage.escolha, 2) && isequal(r1.hurwicz.escolha, 2) ...
     && max(abs(r1.laplace.valores - [45 160/3 130/3])) < 1e-9;
ok = ok && isequal(r3.maximax.escolha, 1) && isequal(r3.maximin.escolha, 2) && isequal(r3.laplace.escolha, 2) ...
     && isequal(r3.savage.escolha, 2) && isequal(r3.hurwicz.escolha, 1) ...
     && isequal(r3.savage.valores, [1800 650 780]) && max(abs(r3.hurwicz.valores - [500 320 176])) < 1e-9;
ok = ok && all(cellfun(@(k) isequal(re.(k).escolha, 4), crit)) && isequal(Dominadas(casos{3,2}), [2 4]);

% ------------------------------------------------------------ verificar respostas
fprintf('\nVerificaEscolhas: um aluno respondeu assim ao Exemplo 3\n');
v = VerificaEscolhas(casos{2,2}, 0.8, struct('maximax', 'ações', 'maximin', 'títulos do tesouro', ...
                                              'savage', 'obrigações'), casos{2,3});
ok = ok && v.maximax && ~v.maximin && v.savage;

simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
