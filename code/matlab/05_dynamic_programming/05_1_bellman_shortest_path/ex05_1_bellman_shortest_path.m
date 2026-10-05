% EX05_1_BELLMAN_SHORTEST_PATH  Reproduz os exemplos do deck 5.1 (princípio de Bellman e caminho mais curto).
%
%   Exemplo-guia: transportadora de A a J (custos em centenas de €).
%   Regra gulosa: A-C-F-I-J, custo 21. Recursão para trás: f(H) = 5, f(I) = 7; f(E) = 11 (H ou I),
%   f(F) = 16, f(G) = 9; f(B) = 13, f(C) = 18 (E ou G), f(D) = 13; f(A) = 17. Ótimo A-B-G-I-J, custo 17.
%   Slide «Quanto se poupa?»: 15 percursos, 45 somas a enumerar contra 19 da PD; tabela k^N contra N k^2.
%   Para resolver na aula: Exemplos 1, 2 e 3 (do nó 1 ao nó 7): 26 por 1-4-6-7; 23 por 1-3-6-7;
%   17 por 1-2-3-5-7 (a regra gulosa dá 34, 28 e 17).
%
%   A rede é dada pela lista dos arcos {origem, destino, custo}; os nós ficam por ordem
%   alfabética e a matriz C(i,j) tem o custo do arco i -> j (Inf se não há arco).
%
%   No fim compara com os slides.
%
%   Complementos de IO — deck 5.1.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 5.1: princípio de Bellman e caminho mais curto\n');
ok = true;
num = @(M) [arrayfun(@num2str, M(:,1), 'UniformOutput', false), ...
            arrayfun(@num2str, M(:,2), 'UniformOutput', false), num2cell(M(:,3))];

% os quatro casos: título, arcos, início, fim
casos = {
  'Transportadora de A a J (custos em centenas de €)', ...
     {'A','B',4; 'A','C',2; 'A','D',8; 'B','E',4; 'B','F',2; 'B','G',4; 'C','E',7; 'C','F',3; 'C','G',9; ...
      'D','E',9; 'D','F',7; 'D','G',4; 'E','H',6; 'E','I',4; 'F','I',9; 'G','H',8; 'G','I',2; ...
      'H','J',5; 'I','J',7}, 'A', 'J'
  'Exemplo 1 (do nó 1 ao nó 7)', num([1 2 5; 1 3 9; 1 4 8; 2 5 10; 2 6 17; 3 5 4; 3 6 10; 4 5 9; 4 6 9; ...
                                      5 7 19; 6 7 9]), '1', '7'
  'Exemplo 2 (do nó 1 ao nó 7)', num([1 2 7; 1 3 8; 1 4 9; 2 5 12; 3 5 8; 3 6 9; 4 5 7; 4 6 13; ...
                                      5 7 9; 6 7 6]), '1', '7'
  'Exemplo 3 (do nó 1 ao nó 7)', num([1 2 5; 1 3 14; 1 4 6; 2 3 6; 2 5 12; 2 6 12; 3 5 2; 3 6 3; ...
                                      4 3 7; 4 6 9; 5 7 4; 6 7 4]), '1', '7'};
% esperado: custo ótimo, percurso ótimo, custo da regra gulosa
esperado = {17, 'A-B-G-I-J', 21; 26, '1-4-6-7', 34; 23, '1-3-6-7', 28; 17, '1-2-3-5-7', 17};

for e = 1:size(casos, 1)
  [titulo, arcos, nini, nfim] = casos{e, :};
  nos = unique([arcos(:,1); arcos(:,2)])';
  n = numel(nos);
  C = Inf(n);
  for r = 1:size(arcos, 1)
    C(strcmp(nos, arcos{r,1}), strcmp(nos, arcos{r,2})) = arcos{r,3};
  end
  ini = find(strcmp(nos, nini));  fim = find(strcmp(nos, nfim));

  fprintf('\n%s\n', titulo);
  [g, cg] = Guloso(C, ini, fim);
  fprintf('  regra gulosa: %s, custo %d\n', strjoin(nos(cg), '-'), g);
  [f, dec] = CaminhoEtapas(C, fim);
  fprintf('  recursão para trás (f = custo mínimo até %s):\n', nfim);
  for i = n:-1:1
    suc = find(isfinite(C(i,:)));
    if isempty(suc), continue; end
    vias = arrayfun(@(j) sprintf('via %s: %d+%d=%d', nos{j}, C(i,j), f(j), C(i,j) + f(j)), suc, 'UniformOutput', false);
    fprintf('    f(%s) = %-3d [%s]  -> %s\n', nos{i}, f(i), strjoin(vias, ', '), strjoin(nos(dec{i}), ' ou '));
  end
  cs = CaminhosOtimos(dec, ini, fim);
  txt = cellfun(@(c) strjoin(nos(c), '-'), cs, 'UniformOutput', false);
  fprintf('  ótimo: %d por %s\n', f(ini), strjoin(txt, ' e '));
  [tc, custos] = TodosCaminhos(C, ini, fim);
  fprintf('  força bruta: %d percursos, mínimo %d\n', numel(tc), min(custos));
  ok = ok && f(ini) == esperado{e,1} && isequal(txt, esperado(e,2)) && g == esperado{e,3} ...
       && min(custos) == esperado{e,1};

  if e == 1
    somas_enum = sum(cellfun(@numel, tc) - 2);      % um percurso com m arcos pede m - 1 somas
    somas_pd = sum(isfinite(C(:)));                 % uma soma por arco
    fprintf('  enumerar: %d somas; PD: %d somas (uma por arco)\n', somas_enum, somas_pd);
    fprintf('  em geral (N etapas, k nós por etapa):\n');
    Nk = [4 3; 10 10; 20 10];
    for r = 1:3
      fprintf('    N = %2d, k = %2d: %g percursos, %g somas da PD\n', Nk(r,1), Nk(r,2), ...
              Nk(r,2)^Nk(r,1), Nk(r,1)*Nk(r,2)^2);
    end
    ok = ok && isequal(f(2:9)', [13 18 13 11 16 9 5 7]) && isequal(nos(dec{5}), {'H', 'I'}) ...
         && isequal(nos(dec{3}), {'E', 'G'}) && numel(tc) == 15 && somas_enum == 45 && somas_pd == 19 ...
         && isequal((Nk(:,2).^Nk(:,1))', [81 1e10 1e20]) && isequal((Nk(:,1).*Nk(:,2).^2)', [36 1000 2000]);
  end
end
ok = ok && isequal(dec{4}, [3 6]);                  % Exemplo 3: empate em 4, que não interessa ao ótimo

simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
