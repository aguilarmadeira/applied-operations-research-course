% EX02_3_GANTT_CRASHING  Reproduz os exemplos do deck 2.3 (diagrama de Gantt e crashing).
%
%   Slide «Do plano ao calendário»: Gantt do laboratório (críticas A, C, D, F, H; folga em B, E e G).
%   Slide «E se o cliente quiser o laboratório mais cedo?»: custo por semana 3, 3, 2, 4, -, 4, 3, 5;
%   custo normal 63; bónus de 6 por semana antecipada.
%   Slides «Aceleração semana a semana» e «Custo total»: encurtar C, A, F, H (2, 3, 4, 5);
%   custo total 63, 59, 56, 54, 53, 54 para T = 13, ..., 8; ótimo T = 9 (53), porque 9 -> 8 custa 7 > 6.
%   Slide «Complemento»: a programação linear só está na versão Python (precisa de linprog);
%   aqui o ótimo confere-se com a enumeração exata (Crash.m).
%   Para resolver na aula: exame de 26/07/2019, T = 18 dias, crítico A, C, E, custo 3700;
%   crashing para 16 dias: 4050 (A, B e C menos 1 dia); Gantt do plano final.
%
%   Complementos de IO — deck 2.3.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 2.3: diagrama de Gantt e aceleração de projetos (crashing)\n');
ok = true;

% projetos: uma linha por atividade, {nome, {precedentes}, DN, custo DN, DM, custo DM}
LAB = {'A', {}, 3, 6, 2, 9;  'B', {'A'}, 4, 20, 2, 26;  'C', {'A'}, 2, 4, 1, 6;  'D', {'C'}, 3, 8, 2, 12;
       'E', {'C'}, 2, 5, 2, 5;  'F', {'B', 'D', 'E'}, 3, 10, 1, 18;  'G', {'D'}, 2, 6, 1, 9;
       'H', {'F', 'G'}, 2, 4, 1, 9};
EX = {'A', {}, 4, 700, 2, 1100;  'B', {}, 9, 900, 7, 1000;  'C', {'A'}, 9, 300, 8, 400;
      'D', {'A', 'B'}, 3, 400, 2, 475;  'E', {'C', 'D'}, 5, 600, 5, 600;  'F', {'B', 'D'}, 4, 800, 3, 950};
casos = {'Crashing do laboratório (bónus 6 por semana antecipada)', LAB, 6, 8
         'Crashing do exercício até 16 dias', EX, 0, 16};
for c = 1:2
  [titulo, acts, bonus, Tmin] = casos{c, :};
  nomes = acts(:, 1)';
  DN = cell2mat(acts(:, 3))';  DM = cell2mat(acts(:, 5))';

  if c == 1
    fprintf('\nGantt do laboratório (# crítica, = com folga, - folga)\n');
    g = Gantt(acts);
    fprintf('%s\n', g{:});
    ok = ok && isequal(g(2:end), {'  A       ###..........', '  B       ...====-.....', '  C       ...##........', ...
                                  '  D       .....###.....', '  E       .....==-.....', '  F       ........###..', ...
                                  '  G       ........==-..', '  H       ...........##'});
  else
    [ES, EF, LS, LF, F, T] = Cpm(acts);
    crit = find(abs(F) < 1e-9);
    fprintf('\nExercício (exame de 26/07/2019), durações em dias\n');
    txt = arrayfun(@(i) sprintf('%s %g', nomes{i}, F(i)), 1:numel(nomes), 'UniformOutput', false);
    fprintf('  folgas: %s\n', strjoin(txt, '; '));
    fprintf('  duração do projeto: %g dias; caminho crítico: %s; custo normal %g\n', ...
            T, strjoin(nomes(crit), ', '), sum(cell2mat(acts(:, 4))));
    ok = ok && T == 18 && isequal(crit, [1 3 5]) && isequal(F, [0 1 0 1 0 2]);
  end

  % ---------------------------------------------------- tabela do crashing
  [declive, res] = Crash(acts, bonus);
  Tn = max(res.T);
  cam = Caminhos(acts);
  fprintf('\n%s\n', titulo);
  txt = cell(1, numel(nomes));
  for i = 1:numel(nomes)
    if DN(i) > DM(i), txt{i} = sprintf('%s %g', nomes{i}, declive(i)); else, txt{i} = [nomes{i} ' -']; end
  end
  fprintf('  custo por unidade: %s\n', strjoin(txt, '; '));
  txt = arrayfun(@(k) sprintf('(%d) %s', k, strjoin(nomes(cam{k}), '--')), 1:numel(cam), 'UniformOutput', false);
  fprintf('  caminhos: %s\n', strjoin(txt, '  '));
  fprintf('   T  encurtada   +custo  direto   bónus   total   duração dos caminhos\n');
  for k = find(res.T >= Tmin)
    d = res.dur(k, :);
    if k == 1
      enc = '---';  marg = '---';
    else
      dant = res.dur(k - 1, :);
      enc = strjoin(nomes(d < dant), '+');
      mais = find(d > dant);
      for i = mais, enc = [enc ' repõe ' nomes{i}]; end %#ok<AGROW>
      marg = sprintf('%g', res.direto(k) - res.direto(k - 1));
    end
    durc = cellfun(@(p) sprintf('%g', sum(d(p))), cam, 'UniformOutput', false);
    fprintf('  %2g  %-10s %6s %7g %7g %7g   %s\n', res.T(k), enc, marg, res.direto(k), ...
            -bonus*(Tn - res.T(k)) + 0, res.total(k), strjoin(durc, ' '));
  end

  if c == 1
    [mtot, j] = min(res.total);            % em caso de empate, a maior duração
    Topt = res.T(j);
    j1 = find(res.T == Topt - 1);
    fprintf('  custo normal %g; ótimo: T = %g semanas, custo total %g; %g -> %g custaria %g > %g\n', ...
            sum(cell2mat(acts(:, 4))), Topt, mtot, Topt, Topt - 1, res.direto(j1) - res.direto(j), 6);
    fprintf('  programação linear: só na versão Python (crash_pl, com o linprog do scipy); a enumeração dá o mesmo ótimo\n');
    i13 = arrayfun(@(T) find(res.T == T), 13:-1:8);
    ok = ok && isequal(declive, [3 3 2 4 0 4 3 5]) && sum(cell2mat(acts(:, 4))) == 63 ...
         && isequal(res.direto(i13), [63 65 68 72 77 84]) && isequal(res.total(i13), [63 59 56 54 53 54]) ...
         && Topt == 9 && isequal(DN - res.dur(j, :), [1 0 1 0 0 1 0 1]);
  else
    j16 = find(res.T == 16);
    d16 = res.dur(j16, :);
    enc16 = find(d16 < DN);
    fprintf('  16 dias: custo %g (encurtar %s um dia cada)\n', res.direto(j16), strjoin(nomes(enc16), ', '));
    fprintf('Gantt do plano final (16 dias)\n');
    g2 = Gantt(acts, d16);
    fprintf('%s\n', g2{:});
    i18 = arrayfun(@(T) find(res.T == T), 18:-1:16);
    ok = ok && isequal(res.direto(i18), [3700 3800 4050]) && isequal(enc16, [1 2 3]) ...
         && isequal(declive, [200 50 100 75 0 150]) ...
         && isequal(g2(2:end), {'  A       ###.............', '  B       ########........', '  C       ...########.....', ...
                                '  D       ........###.....', '  E       ...........#####', '  F       ...........====-'});
  end
end

simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
