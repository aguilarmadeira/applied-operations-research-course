% EX08_3_SENSITIVITY  Reproduz os exemplos do deck 8.3 (análise de sensibilidade).
%
%   Carrinhas (8.1 e 8.2): fazendo variar o peso do custo, S(0) = (0.318, 0.455, 0.228) e S(1) = (0.332, 0.286, 0.382);
%   C passa A a p = 0.641 e passa B a p = 0.704 (d0 = 0.2267, d1 = -0.0955); com a autonomia, a carga ou a
%   assistência B fica em 1.º para qualquer peso.
%   Um juízo (a12 = 1, 2, 5, 9): B ganha sempre; com custo 7/9/9 face aos outros, C empata com B (0.3364 e 0.3365).
%   Todos os juízos (20 000 repetições, cada juízo sobe/desce um degrau ou fica): B em 100%; RC > 0.1 em 1.1%.
%   Para resolver na aula: Exemplo 6 (= Exemplo 5): margem 0.014 para F1; F2 passa F3 com o custo da MP acima
%   de 0.268 e com o transporte abaixo de 0.426; F3 em 89.9% das simulações.
%   Exemplo 7 (= Exemplo 3): F3 enquanto o rendimento pesar pelo menos 0.484; F3 em 100% das simulações.
%   As simulações usam semente fixa (rng(1)), mas o gerador não é o do numpy: as frequências ficam próximas
%   das do Python, não iguais (só essas linhas diferem da saída do Python).
%
%   Complementos de IO — deck 8.3.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 8.3: análise de sensibilidade\n');
m4 = @(A) mat2str(round(A*1e4)/1e4);                  % como o mat2str(A, 4 casas) do Python
perto = @(x, v, tol) all(abs(x(:) - v(:)) <= tol);
ABC = 'ABC';
ok = true;

% ------------------------------------------------------------ dados: carrinhas e Exemplos 5 e 3 de 8.2
C = MatrizReciproca(4, [1 2 2; 1 3 3; 1 4 5; 2 3 2; 2 4 3; 3 4 2]);
S = MatrizReciproca(3, [1 2 1/3; 1 3 3; 2 3 5]);
w = Prioridades(C);
M = [Indireto([38000 44000 33000]), Direto([220 300 160]), Direto([900 1000 750]), Prioridades(S)];
crit = {'custo', 'autonomia', 'carga', 'assistência'};
F4 = {'F1', 'F2', 'F3', 'F4'};
critf = {'custo MP', 'transporte', 'tempo', 'rendimento'};
C5 = MatrizReciproca(4, [1 2 1/3; 1 3 5; 1 4 1; 2 3 9; 2 4 3; 3 4 1/5]);       % Exemplo 5 de 8.2
w5 = Prioridades(C5);
M5 = [Indireto([11000 7000 15000 12000]), Indireto([1400 1700 1200 1300]), ...
      Indireto([15 13 23 18]), Direto([3 2.5 3.5 2])];
C3 = MatrizReciproca(4, [1 2 7; 1 3 5; 1 4 1/3; 2 3 1/3; 2 4 1/9; 3 4 1/7]);   % Exemplo 3 de 8.2
w3 = Prioridades(C3);
M3 = [Indireto([12000 6000 18000 12000]), Indireto([400 600 200 800]), ...
      Indireto([15 10 20 5]), Direto([2 1.5 3 1])];

% três grupos: carrinhas, Exemplo 6 (= Exemplo 5) e Exemplo 7 (= Exemplo 3)
grupos = {M, w, {'A', 'B', 'C'}, 1:4, crit
          M5, w5, F4, 1:3, critf
          M3, w3, F4, [4 1], critf};
res = cell(1, 3);
for g = 1:3
  [Mg, wg, nomes, ks, crits] = grupos{g, :};
  sg = Agrega(Mg, wg);
  [~, o] = sort(sg, 'descend');
  if g == 1
    fprintf('\nCarrinhas: pontuação S = %s; pesos w = %s\n', m4(sg'), m4(wg'));
  elseif g == 2
    fprintf('\nExemplo 6 (= Exemplo 5; 2.º teste, 27/06/2019): S = %s\n', m4(sg'));
    fprintf('  a) %s em 1.º, margem %.4f para %s\n', nomes{o(1)}, sg(o(1)) - sg(o(2)), nomes{o(2)});
  else
    fprintf('\nExemplo 7 (= Exemplo 3; exame, 11/07/2019): S = %s; %s em 1.º, margem %.4f para %s\n', ...
            m4(sg'), nomes{o(1)}, sg(o(1)) - sg(o(2)), nomes{o(2)});
  end

  % retas no peso de cada critério k: S(0), S(1), viragens do vencedor e intervalo em que se mantém
  b = o(1);
  for k = ks
    s0 = Agrega(Mg, PesosCom(wg, k, 0));
    fprintf('  %s (peso atual %.4f): S(0) = %s  S(1) = %s\n', crits{k}, wg(k), m4(s0'), m4(Mg(:, k)'));
    lo = 0;  qlo = 0;  hi = 1;  qhi = 0;  vir = nan(1, size(Mg, 1));
    for j = 1:size(Mg, 1)
      if j == b, continue; end
      p = Viragem(Mg, wg, k, b, j);
      if isempty(p), continue; end
      vir(j) = p;
      fprintf('    %s–%s: d0 = %.4f  d1 = %.4f  p* = %.4f\n', nomes{b}, nomes{j}, s0(b) - s0(j), Mg(b, k) - Mg(j, k), p);
      if p > wg(k) && p < hi, hi = p;  qhi = j; end
      if p < wg(k) && p > lo, lo = p;  qlo = j; end
    end
    if qlo == 0 && qhi == 0
      fprintf('    %s em 1.º para qualquer p em [0, 1]\n', nomes{b});
    else
      txt = sprintf('    %s em 1.º para p em [%.4f, %.4f]', nomes{b}, lo, hi);
      if qlo > 0, txt = [txt sprintf('; abaixo passa %s', nomes{qlo})]; end %#ok<AGROW>
      if qhi > 0, txt = [txt sprintf('; acima passa %s', nomes{qhi})]; end %#ok<AGROW>
      fprintf('%s\n', txt);
    end
    res{g}{k} = struct('lo', lo, 'qlo', qlo, 'hi', hi, 'qhi', qhi, 'vir', vir);
  end

  if g == 1
    % ------------------------------------------------------------ carrinhas: pontos de viragem no custo
    pBC = Viragem(M, w, 1, 2, 3);  pCA = Viragem(M, w, 1, 3, 1);
    sCA = Agrega(M, PesosCom(w, 1, pCA));  sBC = Agrega(M, PesosCom(w, 1, pBC));
    fprintf('  no custo: C passa A a p = %.4f (S = %s) e passa B a p = %.4f (S = %s)\n', pCA, m4(sCA'), pBC, m4(sBC'));
    grelha = linspace(0, 1, 11);
    T = Sensibilidade(M, w, 1, grelha);
    fprintf('  sensibilidade no peso do custo (o gráfico do slide):\n');
    for t = 1:numel(grelha)
      fprintf('    p = %.1f: A %.4f  B %.4f  C %.4f\n', grelha(t), T(t, 1), T(t, 2), T(t, 3));
    end
    gfina = linspace(0, 1, 1001);
    [~, am] = max(Sensibilidade(M, w, 1, gfina), [], 2);
    Bgrelha = gfina(am == 2);
    r = res{1};
    c = [perto(Agrega(M, PesosCom(w, 1, 0)), [0.3177 0.4545 0.2278], 5e-5), ...
         perto(M(:, 1), [0.3317 0.2864 0.3819], 5e-5), perto(pBC, 0.704, 5e-4), perto(pCA, 0.641, 5e-4), ...
         r{1}.hi == pBC && r{1}.qhi == 3 && r{1}.qlo == 0, ...
         all(cellfun(@(x) x.qlo == 0 && x.qhi == 0, r(2:4))), ...
         perto(sBC(2:3), [0.336 0.336], 5e-4), perto(sCA([1 3]), [0.3266 0.3266], 5e-5), ...
         perto(T([1 end], :), [0.3177 0.4545 0.2278; 0.3317 0.2864 0.3819], 5e-5), ...
         min(Bgrelha) == 0 && perto(max(Bgrelha), 0.703, 1e-9)];
    ok = ok && all(c);

    % ------------------------------------------------------------ um juízo: custo face a autonomia
    fprintf('\nUm juízo: a12 (custo face a autonomia; era 2)\n');
    as = [1 2 5 9];  tab = zeros(4, 6);
    for t = 1:4
      Ct = C;  Ct(1, 2) = as(t);  Ct(2, 1) = 1/as(t);
      [wt, ~, ~, rct] = Prioridades(Ct);
      st = Agrega(M, wt);
      [~, bt] = max(st);
      tab(t, :) = [as(t) wt(1) rct st'];
      fprintf('  a12 = %d: w_custo = %.4f  RC = %.4f  S = %s -> %s\n', as(t), wt(1), rct, m4(st'), ABC(bt));
    end
    C7 = MatrizReciproca(4, [1 2 7; 1 3 9; 1 4 9; 2 3 2; 2 4 3; 3 4 2]);
    s7 = Agrega(M, Prioridades(C7));
    fprintf('  custo 7, 9 e 9 vezes mais importante do que autonomia, carga e assistência: S = %s\n', m4(s7'));
    c = [perto(tab(:, 2:end), [0.4159 0.0126 0.3238 0.3840 0.2922; 0.4824 0.0054 0.3244 0.3734 0.3021; ...
                               0.5562 0.0665 0.3252 0.3615 0.3133; 0.5887 0.1583 0.3256 0.3561 0.3182], 5e-5), ...
         all(tab(:, 5) > max(tab(:, [4 6]), [], 2)), perto(s7(2:3), [0.3364 0.3365], 5e-5)];
    ok = ok && all(c);

    % ------------------------------------------------------------ todos os juízos: simulação
    [vit, inc] = SimulaJuizos(C, M, {4, S});
    fprintf('\nTodos os juízos (20000 repetições, ±1 degrau na escala de Saaty, semente 1):\n');
    fprintf('  1.º lugar: A %.1f%%  B %.1f%%  C %.1f%%;  RC > 0.1 em %.1f%% das matrizes\n', ...
            100*vit(1), 100*vit(2), 100*vit(3), 100*inc);
    c = [vit(2) >= 0.995, perto(inc, 0.011, 0.004)];      % frequências: tolerância de simulação
    ok = ok && all(c);
  elseif g == 2
    vit6 = SimulaJuizos(C5, M5);
    fprintf('  simulação (±1 degrau): F3 em 1.º em %.1f%% das repetições\n', 100*vit6(3));
    r = res{2};
    c = [o(1) == 3 && o(2) == 1, perto(sg(3) - sg(1), 0.014, 5e-4), ...
         perto(Agrega(M5, PesosCom(w5, 1, 0)), [0.2545 0.2157 0.2885 0.2412], 5e-5), ...
         perto(r{1}.vir([2 1 4]), [0.268 0.350 0.522], 5e-4), r{1}.hi == r{1}.vir(2) && r{1}.qhi == 2, ...
         perto(Agrega(M5, PesosCom(w5, 2, 0)), [0.2569 0.3015 0.2391 0.2025], 5e-5), ...
         perto(r{2}.vir([2 1]), [0.426 0.303], 5e-4), r{2}.lo == r{2}.vir(2) && r{2}.qlo == 2, ...
         perto(r{3}.hi, 0.152, 5e-4) && r{3}.qhi == 2, perto(vit6(3), 0.899, 0.01)];
    ok = ok && all(c);
  else
    vit7 = SimulaJuizos(C3, M3);
    fprintf('  simulação (±1 degrau): F3 em 1.º em %.1f%% das repetições\n', 100*vit7(3));
    r = res{3};
    c = [o(1) == 3 && perto(sg(3) - sg(2), 0.035, 5e-4), ...
         perto(Agrega(M3, PesosCom(w3, 4, 0)), [0.2055 0.3606 0.1732 0.2607], 5e-5), ...
         perto(r{4}.vir([2 4 1]), [0.484 0.247 0.195], 5e-4), ...
         r{4}.lo == r{4}.vir(2) && r{4}.qlo == 2 && r{4}.qhi == 0, ...
         perto(r{1}.hi, 0.369, 5e-4) && r{1}.qhi == 2, vit7(3) >= 0.995];
    ok = ok && all(c);
  end
end

simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
