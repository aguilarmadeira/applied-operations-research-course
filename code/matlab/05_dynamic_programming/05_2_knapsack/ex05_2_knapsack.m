% EX05_2_KNAPSACK  Reproduz os exemplos do deck 5.2 (o problema da mochila).
%
%   Exemplo 1 (camião, 10 t, mochila ilimitada): paletes A (3 t, 7), B (4 t, 13), C (6 t, 17).
%   Tabela f(0..10) = 0, 0, 0, 7, 13, 13, 17, 20, 26, 26, 30; ótimo uma B e uma C, lucro 30
%   (única solução por força bruta); pelo rácio, B, B: 26.
%   Exemplo 2 (projetos, orçamento 10, mochila 0-1): custos 3, 5, 3, 4, 1; benefícios 12, 14, 15, 15, 8.
%   Tabela f_5..f_1; ótimo P1, P3, P4, benefício 42; pelo rácio P5, P3, P1: 35.
%   (O deck confirma o ótimo com o milp do scipy; aqui confirma-se pela força bruta.)
%   Para resolver na aula: Exemplo 4 (navio): 62, duas unidades do produto 1 (rácio 61);
%   Exemplo 5: 19, 2A + B (rácio 18); Exemplo 6: 26, A + 2C (rácio 24).
%
%   No fim compara com os slides.
%
%   Complementos de IO — deck 5.2.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 5.2: o problema da mochila\n');
ok = true;

% as mochilas ilimitadas: título, pesos, valores, capacidade, nomes
casos = {
  'Exemplo 1: carregar um camião, 10 t (mochila ilimitada)', [3 4 6], [7 13 17], 10, {'A', 'B', 'C'}
  'Exemplo 4: o navio, 4 t', [2 3 1], [31 47 14], 4, {'1', '2', '3'}
  'Exemplo 5: mochila de 10 kg', [3 4 7], [6 7 10], 10, {'A', 'B', 'C'}
  'Exemplo 6: mochila de 13 kg', [3 4 5 6], [6 7 10 12], 13, {'A', 'B', 'C', 'D'}};
% esperado: valor ótimo, soluções, valor pela regra do rácio
esperado = {30, [0 1 1], 26; 62, [2 0 0], 61; 19, [2 1 0], 18; 26, [1 0 2 0], 24};

for e = 1:size(casos, 1)
  [titulo, w, v, W, nomes] = casos{e, :};
  fprintf('\n%s\n', titulo);
  [f, esc] = MochilaIlimitada(w, v, W);
  for k = 0:W
    cabe = find(w <= k);
    cand = arrayfun(@(i) sprintf('%s: %d+f(%d)=%d', nomes{i}, v(i), k - w(i), v(i) + f(k - w(i) + 1)), ...
                    cabe, 'UniformOutput', false);
    if isempty(cand), ctxt = 'nada cabe'; else, ctxt = strjoin(cand, ', '); end
    if isempty(esc{k+1}), quem = ''; else, quem = sprintf(' (%s)', strjoin(nomes(esc{k+1}), ' ou ')); end
    fprintf('  k=%2d: %s -> f(%d) = %d%s\n', k, ctxt, k, f(k+1), quem);
  end
  k = W;  leitura = {};
  while ~isempty(esc{k+1})                          % ler a solução a partir de f(W)
    i = esc{k+1}(1);
    leitura{end+1} = sprintf('pôr %s, restam %d', nomes{i}, k - w(i)); %#ok<AGROW>
    k = k - w(i);
  end
  fprintf('  leitura a partir de f(%d): %s\n', W, strjoin(leitura, '; '));
  [melhor, sols] = SolucoesIlimitada(w, v, W);
  fprintf('  ótimo %d; soluções por força bruta (unidades de %s): %s\n', melhor, strjoin(nomes, ', '), mat2str(sols));
  [vr, xr] = RegraRacio(w, v, W);
  fprintf('  regra do rácio: %s, valor %d\n', mat2str(xr), vr);
  ok = ok && melhor == esperado{e,1} && isequal(sols, esperado{e,2}) && vr == esperado{e,3};
  if e == 1
    ok = ok && isequal(f, [0 0 0 7 13 13 17 20 26 26 30]);

    % -------------------------------------------------------- Exemplo 2: projetos (0-1)
    w = [3 5 3 4 1];  v = [12 14 15 15 8];  W = 10;
    P = {'P1', 'P2', 'P3', 'P4', 'P5'};
    fprintf('\nExemplo 2: escolher projetos, orçamento 10 (mochila 0-1)\n');
    [valor, x, F] = Mochila01(w, v, W);
    for i = numel(w):-1:1
      fprintf('  f_%d: %s\n', i, mat2str(F(i,:)));
    end
    k = W;
    for i = 1:numel(w)                              % ler a solução para a frente
      if w(i) <= k
        simnao01 = {'não', 'sim'};
        fprintf('  %s: não f_%d(%d) = %d, sim %d+f_%d(%d) = %d -> %s\n', P{i}, i + 1, k, F(i+1, k+1), ...
                v(i), i + 1, k - w(i), v(i) + F(i+1, k - w(i) + 1), simnao01{x(i) + 1});
      else
        fprintf('  %s: não cabe\n', P{i});
      end
      k = k - w(i)*x(i);
    end
    fprintf('  ótimo %d com x = %s (custo %d)\n', valor, mat2str(x), sum(w .* x));
    [melhor01, sols01] = ForcaBruta01(w, v, W);
    fprintf('  força bruta: %d com %s\n', melhor01, mat2str(sols01));
    [vr01, xr01] = RegraRacio(w, v, W, false);
    fprintf('  regra do rácio: %s, valor %d\n', mat2str(xr01), vr01);
    fprintf('  milp (scipy): só na versão Python; aqui confirma-se pela força bruta (linha acima)\n');
    ok = ok && valor == 42 && isequal(x, [1 0 1 1 0]) && melhor01 == 42 && isequal(sols01, [1 0 1 1 0]) ...
         && vr01 == 35 && isequal(xr01, [1 0 1 0 1]) && isequal(F(5,:), [0 8*ones(1, 10)]) ...
         && isequal(F(4,:), [0 8 8 8 15 23 23 23 23 23 23]) && isequal(F(3,:), [0 8 8 15 23 23 23 30 38 38 38]) ...
         && isequal(F(2,:), F(3,:)) && isequal(F(1,:), [0 8 8 15 23 23 27 35 38 38 42]);
  end
end

simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
