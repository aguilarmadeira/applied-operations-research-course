% EX08_2_ATTRIBUTES  Reproduz os exemplos do deck 8.2 (atributos quantitativos e agregação).
%
%   Carrinhas: custo indireto (38 000, 44 000, 33 000 €), autonomia direta (220, 300, 160 km), carga direta
%   (900, 1000, 750 kg) e assistência pelas comparações de 8.1 => prioridades locais 0.332, 0.286, 0.382 no custo, ...;
%   pontuações A 0.324, B 0.373, C 0.302 -> B. C ganha 0.046 no custo; B recupera 0.056 na autonomia e 0.047
%   na assistência. A normalização comprime: 0.382 / 0.286 = 44 000 / 33 000 = 1.33.
%   Filtro «autonomia >= 200 km» (sem C): A 0.471, B 0.529 -> B.
%   Para resolver na aula: fornecedores (custo da MP, transporte e tempo indiretos; rendimento direto)
%   Exemplo 3 (exame 11/07/2019): RC = 0.062, F3 com 0.3034, margem 0.035 para F2;
%   Exemplo 4 (2.º teste 01/06/2018): RC = 0.027, F3 com 0.344, margem 0.108 para F4;
%   Exemplo 5 (2.º teste 27/06/2019): RC = 0.012, F3 com 0.2649, margem só 0.014 para F1;
%   no Exemplo 5, os erros frequentes (régua trocada, transporte como direto, soma sem pesos) dão F2.
%
%   Complementos de IO — deck 8.2.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 8.2: atributos quantitativos e agregação\n');
m4 = @(A) mat2str(round(A*1e4)/1e4);                  % como o mat2str(A, 4 casas) do Python
perto = @(x, v, tol) all(abs(x(:) - v(:)) <= tol);
coer = {'incoerente', 'coerente'};
ABC = 'ABC';
ok = true;

% ------------------------------------------------------------ carrinhas
C = MatrizReciproca(4, [1 2 2; 1 3 3; 1 4 5; 2 3 2; 2 4 3; 3 4 2]);   % de 8.1
S = MatrizReciproca(3, [1 2 1/3; 1 3 3; 2 3 5]);                      % assistência, de 8.1
w = Prioridades(C);
custo = [38000 44000 33000];  autonomia = [220 300 160];  carga = [900 1000 750];
M = [Indireto(custo), Direto(autonomia), Direto(carga), Prioridades(S)];
contrib = M .* w';
s = Agrega(M, w);
[~, b] = max(s);
fprintf('\nCarrinhas A, B, C (colunas: custo ind., autonomia dir., carga dir., assistência)\n');
fprintf('  custo: 10^5/v = %s (soma %.4f)\n', m4(1e5 ./ custo), sum(1e5 ./ custo));
fprintf('  prioridades locais: %s\n', m4(M));
fprintf('  pesos w (8.1): %s\n', m4(w'));
fprintf('  contribuições w_k p_ik: %s\n', m4(contrib));
fprintf('  pontuação S: %s -> carrinha %s\n', m4(s'), ABC(b));
ganho_custo = contrib(3, 1) - contrib(2, 1);
ganho_aut = contrib(2, 2) - contrib(3, 2);
ganho_ass = contrib(2, 4) - contrib(3, 4);
fprintf('  C ganha %.4f no custo; B recupera %.4f na autonomia e %.4f na assistência\n', ...
        ganho_custo, ganho_aut, ganho_ass);
fprintf('  compressão: B custa mais %.0f%% do que C; prioridades no custo C/B = %.4f = 44000/33000\n', ...
        100*(custo(2)/custo(3) - 1), M(3, 1) / M(2, 1));
Mf = [Indireto(custo(1:2)), Direto(autonomia(1:2)), Direto(carga(1:2)), ...
      Prioridades(MatrizReciproca(2, [1 2 1/3]))];
sf = Agrega(Mf, w);
[~, bf] = max(sf);
fprintf('  filtro autonomia >= 200 km (sem C): A %.4f  B %.4f -> %s\n', sf(1), sf(2), ABC(bf));
c = [perto(1e5 ./ custo, [2.632 2.273 3.030], 5e-4), perto(sum(1e5 ./ custo), 7.935, 5e-4), ...
     perto(M, [0.3317 0.3235 0.3396 0.2605; 0.2864 0.4412 0.3774 0.6333; 0.3819 0.2353 0.2830 0.1062], 5e-5), ...
     perto(contrib, [0.1600 0.0879 0.0535 0.0230; 0.1382 0.1199 0.0594 0.0559; 0.1842 0.0640 0.0446 0.0094], 5e-5), ...
     perto(s, [0.324 0.373 0.302], 5e-4), b == 2, ...
     perto([ganho_custo ganho_aut ganho_ass], [0.046 0.056 0.047], 5e-4), ...
     perto(M(3, 1) / M(2, 1), 44000/33000, 1e-12), perto(sf, [0.471 0.529], 5e-4)];
ok = ok && all(c);

% ------------------------------------------------------------ Exemplos 3, 4 e 5: fornecedores
% {nome, juízos C1..C4, custo MP, transporte, tempo, rendimento} e o esperado (notas do docente):
% {w, lambda_max, RC, S, índice do escolhido, margem, índice do 2.º}
casos = {
  'Exemplo 3 (exame, 11/07/2019)', [1 2 7; 1 3 5; 1 4 1/3; 2 3 1/3; 2 4 1/9; 3 4 1/7], ...
      [12000 6000 18000 12000], [400 600 200 800], [15 10 20 5], [2 1.5 3 1], ...
      {[0.2913 0.0445 0.0903 0.5739], 4.168, 0.062, [0.2406 0.2684 0.3034 0.1876], 3, 0.035, 2}
  'Exemplo 4 (2.º teste, 01/06/2018)', [1 2 1/5; 1 3 3; 1 4 1; 2 3 7; 2 4 5; 3 4 1/3], ...
      [10000 6000 16000 11000], [400 700 200 300], [12 10 20 15], [2.5 2 3 1], ...
      {[0.1542 0.6279 0.0637 0.1542], 4.074, 0.027, [0.2278 0.1918 0.3440 0.2364], 3, 0.108, 4}
  'Exemplo 5 (2.º teste, 27/06/2019)', [1 2 1/3; 1 3 5; 1 4 1; 2 3 9; 2 4 3; 3 4 1/5], ...
      [11000 7000 15000 12000], [1400 1700 1200 1300], [15 13 23 18], [3 2.5 3.5 2], ...
      {[0.2055 0.5416 0.0474 0.2055], 4.033, 0.012, [0.2509 0.2479 0.2649 0.2362], 3, 0.014, 1}};
for e = 1:size(casos, 1)
  [nome, juizos, mp, tr, te, re, esp] = casos{e, :};
  Cf = MatrizReciproca(4, juizos);
  [wf, lamf, ICf, RCf] = Prioridades(Cf);
  Mf = [Indireto(mp), Indireto(tr), Indireto(te), Direto(re)];
  sf = Agrega(Mf, wf);
  [~, o] = sort(sf, 'descend');
  fprintf('\n%s\n', nome);
  fprintf('  matriz dos critérios: %s\n', m4(Cf));
  fprintf('  somas das colunas: %s\n', m4(sum(Cf, 1)));
  fprintf('  pesos w: %s\n', m4(wf'));
  fprintf('  (Aw)_i/w_i: %s\n', m4((Cf*wf ./ wf)'));
  fprintf('  lambda_max = %.4f  IC = %.4f  RC = %.4f -> %s\n', lamf, ICf, RCf, coer{(RCf < 0.1) + 1});
  fprintf('  prioridades locais (linhas F1..F4; colunas MP, transp., tempo, rend.): %s\n', m4(Mf));
  fprintf('  pontuação S: %s -> F%d, margem %.4f para F%d\n', m4(sf'), o(1), sf(o(1)) - sf(o(2)), o(2));
  c = [perto(wf, esp{1}, 5e-5), perto(lamf, esp{2}, 5e-4), perto(RCf, esp{3}, 5e-4), ...
       perto(sf, esp{4}, 5e-5), o(1) == esp{5}, perto(sf(o(1)) - sf(o(2)), esp{6}, 5e-4), o(2) == esp{7}];
  ok = ok && all(c);
end

% ------------------------------------------------------------ Exemplo 5: os erros frequentes mudam a escolha
[nome, juizos, mp, tr, te, re] = casos{3, 1:6};
Cf = MatrizReciproca(4, juizos);
wf = Prioridades(Cf);
Mf = [Indireto(mp), Indireto(tr), Indireto(te), Direto(re)];
s_regua = Agrega(Mf, Prioridades(Cf'));               % régua trocada: matriz transposta
Md = Mf;  Md(:, 2) = Direto(tr);
s_dir = Agrega(Md, wf);                               % transporte tratado como direto
s_soma = sum(Mf, 2);                                  % somar sem ponderar
fprintf('\nExemplo 5, erros frequentes:\n');
rot = {'régua trocada', 'transporte como direto', 'soma sem pesos'};
V = [s_regua, s_dir, s_soma];
for t = 1:3
  [vmax, bt] = max(V(:, t));
  fprintf('  %s: S = %s -> F%d (%.4f)\n', rot{t}, m4(V(:, t)'), bt, vmax);
end
[r1, b1] = max(s_regua);  [r2, b2] = max(s_dir);  [r3, b3] = max(s_soma);
c = [b1 == 2, perto(r1, 0.305, 5e-4), b2 == 2, perto(r2, 0.303, 5e-4), b3 == 2, perto(r3, 1.119, 5e-4)];
ok = ok && all(c);

simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
