% EX02_1_CPM  Reproduz os exemplos do deck 2.1 (planeamento de projetos: CPM).
%
%   Exemplo do capítulo: renovar um laboratório (8 atividades, soma das durações 21 semanas).
%   Slide «Passagem para a frente e para trás»: T = 13 semanas, caminho crítico A, C, D, F, H;
%   folga 1 em B, E e G.  Slide «Caminho crítico = caminho mais longo»: 12, 13, 12, 12.
%   Slide «O que fazer com as folgas?»: se B atrasar 2 semanas, o projeto passa a 14.
%   Para resolver na aula: Exemplo 1 (T = 15, crítico A, C, E, G, H) e
%   Exemplo 2, construção de uma obra (Hillier & Lieberman): T = 44, sem multa nem prémio.
%
%   Complementos de IO — deck 2.1.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 2.1: planeamento de projetos (CPM)\n');
ok = true;
simnao = {'não', 'sim'};

% projetos: uma linha por atividade, {nome, {precedentes}, duração}
LAB = {'A', {}, 3;  'B', {'A'}, 4;  'C', {'A'}, 2;  'D', {'C'}, 3;
       'E', {'C'}, 2;  'F', {'B', 'D', 'E'}, 3;  'G', {'D'}, 2;  'H', {'F', 'G'}, 2};
EX1 = {'A', {}, 2;  'B', {}, 3;  'C', {'A'}, 2;  'D', {'A', 'B'}, 4;
       'E', {'C'}, 4;  'F', {'C'}, 3;  'G', {'D', 'E'}, 5;  'H', {'F', 'G'}, 2};
HL = {'A', {}, 2;  'B', {'A'}, 4;  'C', {'B'}, 10;  'D', {'C'}, 6;  'E', {'C'}, 4;
      'F', {'E'}, 5;  'G', {'D'}, 7;  'H', {'E', 'G'}, 9;  'I', {'C'}, 7;  'J', {'F', 'I'}, 8;
      'K', {'J'}, 4;  'L', {'J'}, 5;  'M', {'H'}, 2;  'N', {'K', 'L'}, 6};
soma = sum(cell2mat(LAB(:, 3)));
casos = {sprintf('Laboratório (soma das durações: %g semanas)', soma), LAB
         'Exemplo 1', EX1
         'Exemplo 2 (construção de uma obra, Hillier & Lieberman)', HL};
res = cell(3, 4);
for c = 1:3
  [titulo, acts] = casos{c, :};
  nomes = acts(:, 1)';
  d = cell2mat(acts(:, 3))';
  [ES, EF, LS, LF, F, T] = Cpm(acts);
  crit = find(abs(F) < 1e-9);
  fprintf('\n%s\n', titulo);
  fprintf('  ativ.  dur   ES   EF   LS   LF  folga\n');
  for i = Topo(acts)
    fprintf('  %-5s %4g %4g %4g %4g %4g %6g\n', nomes{i}, d(i), ES(i), EF(i), LS(i), LF(i), F(i));
  end
  fprintf('  duração do projeto: %g semanas; caminho crítico: %s\n', T, strjoin(nomes(crit), ', '));
  cam = Caminhos(acts);
  txt = cellfun(@(p) sprintf('%s %g', strjoin(nomes(p), '--'), sum(d(p))), cam, 'UniformOutput', false);
  fprintf('  caminhos: %s\n', strjoin(txt, '; '));
  res(c, :) = {F, T, crit, txt};

  if c == 1
    % B atrasa 2 semanas
    d6 = d;  d6(2) = 6;
    [ES6, EF6, LS6, LF6, F6, T6] = Cpm(acts, d6);
    crit6 = find(abs(F6) < 1e-9);
    fprintf('\nB atrasa 2 semanas (B = 6): EF_B = %g > LS_F = %g; T = %g semanas; crítico: %s\n', ...
            EF6(2), LS(6), T6, strjoin(nomes(crit6), ', '));
    ok = ok && soma == 21 && T == 13 && isequal(crit, [1 3 4 6 8]) && isequal(F, [0 1 0 0 1 0 1 0]) ...
         && isequal(ES, [0 3 3 5 5 8 8 11]) && isequal(LF, [3 8 5 8 8 11 11 13]) ...
         && isequal(txt, {'A--B--F--H 12', 'A--C--D--F--H 13', 'A--C--D--G--H 12', 'A--C--E--F--H 12'}) ...
         && EF6(2) == 9 && LS(6) == 8 && T6 == 14 && isequal(crit6, [1 2 6 8]);
  end
  if c == 3
    fprintf('  multa (T > 47)? %s;  prémio (T < 40)? %s;  para o prémio é preciso retirar %g semanas\n', ...
            simnao{(T > 47) + 1}, simnao{(T < 40) + 1}, T - 39);
  end
end
[F1, T1, crit1, cam1] = res{2, :};
ok = ok && T1 == 15 && isequal(crit1, [1 3 5 7 8]) && isequal(F1, [0 1 0 1 0 6 0 0]) ...
     && isequal(cam1, {'A--C--E--G--H 15', 'A--C--F--H 9', 'A--D--G--H 13', 'B--D--G--H 14'});
[F2, T2, crit2] = res{3, 1:3};
ok = ok && T2 == 44 && isequal(crit2, [1 2 3 5 6 10 12 14]) && isequal(F2([4 7 8 9 11 13]), [4 4 4 2 1 4]) ...
     && ~(T2 > 47) && ~(T2 < 40);

fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
