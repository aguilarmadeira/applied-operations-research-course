% EX05_3_WORKFORCE  Reproduz os exemplos do deck 5.3 (gestão da mão-de-obra).
%
%   Exemplo-guia: montagem de feiras e congressos, necessidades 3, 8, 9, 4, 6; excesso 300 €;
%   contratação 600 € + 150 € por operário; ninguém contratado no início.
%   Seguir as necessidades: 4050 €; 9 desde o início: 6450 €; 336 planos possíveis.
%   Tabelas: f_5(4) = 900, f_5(5) = 750, f_5(6..9) = 0; f_4(9) = 600 (x_4 = 6); f_3(8) = 1350, f_3(9) = 600;
%   f_2(3) = 2400 (x_2 = 9); f_1(0) = 3450. Plano ótimo 3, 9, 9, 6, 6 (custos 1050, 1800, 0, 600, 0),
%   único por força bruta. Sensibilidade ao custo fixo: 0 -> 1650; 300 -> 2850 (4 planos);
%   600 -> 3450; 1200 -> 4650; 2000 -> 6050 (9, 9, 9, 6, 6).
%   Para resolver na aula: Exemplo 7: 5, 8, 8, 6, 6, custo 3300; Exemplo 8: 5, 7, 6, 6, custo 2400.
%
%   No fim compara com os slides.
%
%   Complementos de IO — deck 5.3.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 5.3: gestão da mão-de-obra\n');
ok = true;

% os três casos: título, necessidades, excesso, custo fixo, custo por operário
casos = {
  'Montagem de feiras e congressos', [3 8 9 4 6], 300, 600, 150
  'Exemplo 7', [5 7 8 4 6], 300, 400, 200
  'Exemplo 8', [5 7 4 6], 200, 300, 200};
% esperado: custo ótimo, plano ótimo (único)
esperado = {3450, [3 9 9 6 6]; 3300, [5 8 8 6 6]; 2400, [5 7 6 6]};

for e = 1:size(casos, 1)
  [titulo, b, ce, cf, cv] = casos{e, :};
  fprintf('\n%s: b = %s, ce = %d, cf = %d, cv = %d\n', titulo, mat2str(b), ce, cf, cv);
  n = numel(b);  M = max(b);
  politicas = {b, 'seguir as necessidades'; M*ones(1, n), sprintf('%d desde o início', M)};
  for p = 1:2
    [tot, cs] = CustoPlano(b, ce, cf, cv, politicas{p,1});
    fprintf('  %s %s: custos %s = %d\n', politicas{p,2}, mat2str(politicas{p,1}), mat2str(cs), tot);
  end
  nplanos = prod(M - b + 1);
  fprintf('  planos possíveis: %d\n', nplanos);
  [valor, plano, f, dec] = MaoObra(b, ce, cf, cv);
  fprintf('  recursão para trás (s = operários na semana anterior):\n');
  for t = n:-1:1
    for s = find(~isnan(f{t})) - 1
      cand = {};
      for x = b(t):M
        c = ce*(x - b(t)) + (x > s)*(cf + cv*(x - s));
        cand{end+1} = sprintf('%d: %d+%d=%d', x, c, f{t+1}(x+1), c + f{t+1}(x+1)); %#ok<AGROW>
      end
      xopt = strjoin(arrayfun(@num2str, dec{t}{s+1}, 'UniformOutput', false), ' ou ');
      fprintf('    semana %d, s = %d: f = %-5d x* = %-6s [%s]\n', t, s, f{t}(s+1), xopt, strjoin(cand, '; '));
    end
  end
  [tot, cs] = CustoPlano(b, ce, cf, cv, plano);
  fprintf('  plano ótimo %s, custo %d (custos por semana %s)\n', mat2str(plano), valor, mat2str(cs));
  [cb, pb] = MaoObraBruta(b, ce, cf, cv);
  fprintf('  força bruta (%d planos): %d com %s\n', nplanos, cb, mat2str(pb));
  ok = ok && valor == esperado{e,1} && isequal(plano, esperado{e,2}) && cb == esperado{e,1} ...
       && isequal(pb, esperado{e,2});

  if e == 1
    ok = ok && isequal(cs, [1050 1800 0 600 0]) && nplanos == 336 ...
         && CustoPlano(b, ce, cf, cv, b) == 4050 && CustoPlano(b, ce, cf, cv, 9*ones(1, 5)) == 6450 ...
         && isequal(f{5}(5:10), [900 750 0 0 0 0]) && f{4}(10) == 600 && isequal(f{3}(9:10), [1350 600]) ...
         && f{2}(4) == 2400 && f{1}(1) == 3450;
    fprintf('  e se o custo fixo de contratar mudar?\n');
    cfs = [0 300 600 1200 2000];
    sens = cell(numel(cfs), 2);
    for j = 1:numel(cfs)
      v = MaoObra(b, ce, cfs(j), cv);
      [~, pbr] = MaoObraBruta(b, ce, cfs(j), cv);
      sens(j, :) = {v, pbr};
      fprintf('    cf = %4d: custo %d, planos ótimos %s\n', cfs(j), v, mat2str(pbr));
    end
    ok = ok && isequal([sens{:,1}], [1650 2850 3450 4650 6050]) && isequal(sens{1,2}, [3 8 9 4 6]) ...
         && size(sens{2,2}, 1) == 4 && isequal(sens{3,2}, [3 9 9 6 6]) && isequal(sens{4,2}, [3 9 9 6 6]) ...
         && isequal(sens{5,2}, [9 9 9 6 6]);
  end
end

simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
