% EX08_1_AHP  Reproduz os exemplos do deck 8.1 (o AHP, comparações par a par e consistência).
%
%   Carrinhas elétricas: critérios custo, autonomia, carga e assistência, juízos 2, 3, 5, 2, 3, 2
%   => pesos 0.482, 0.272, 0.158, 0.088; lambda_max = 4.015, IC = 0.0048, RC = 0.005 (coerente);
%   vetor próprio 0.4829, 0.2720, 0.1570, 0.0882.
%   Slide «Quando os juízos não batem certo»: com a13 = 1/2, RC = 0.173; o par custo–carga é o mais
%   afastado (0.40 e 2.49); com a13 = 3, RC = 0.005; com a13 = 1, RC = 0.069.
%   Assistência (A, B, C): 0.261, 0.633, 0.106, RC = 0.033.
%   Para resolver na aula: Exemplo 1 (frutos: 0.283, 0.643, 0.074, RC = 0.056) e
%   Exemplo 2 (emprego: pesos 0.094, 0.738, 0.168, RC = 0.012; A com 0.735).
%
%   Complementos de IO — deck 8.1.  J. F. A. Madeira — Licença MIT.

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..')); uc_setup;   % caminhos do código da UC

fprintf('Complementos de IO — deck 8.1: o AHP, comparações par a par e consistência\n');
m4 = @(A) mat2str(round(A*1e4)/1e4);                  % como o mat2str(A, 4 casas) do Python
m2 = @(A) mat2str(round(A*1e2)/1e2);
perto = @(x, v, tol) all(abs(x(:) - v(:)) <= tol);
coer = {'incoerente', 'coerente'};
% contas do método das colunas (o passo_a_passo do Python)
passo = @(A, w, lam, IC, RC) sprintf(['  somas das colunas: %s\n  matriz normalizada: %s\n  pesos w: %s\n' ...
    '  Aw: %s\n  (Aw)_i/w_i: %s\n  lambda_max = %.4f  IC = %.4f  RC = %.4f -> %s\n'], ...
    m4(sum(A, 1)), m4(A ./ sum(A, 1)), m4(w'), m4((A*w)'), m4((A*w ./ w)'), lam, IC, RC, coer{(RC < 0.1) + 1});
ok = true;

% ------------------------------------------------------------ carrinhas: pesos dos critérios
crit = {'custo', 'autonomia', 'carga', 'assistência'};
C = MatrizReciproca(4, [1 2 2; 1 3 3; 1 4 5; 2 3 2; 2 4 3; 3 4 2]);
fprintf('\nCarrinhas: critérios custo, autonomia, carga, assistência\n');
[w, lam, IC, RC] = Prioridades(C);
fprintf('%s', passo(C, w, lam, IC, RC));
[wv, lamv] = Prioridades(C, 'vetor');
fprintf('  vetor próprio: w = %s  lambda_max = %.4f\n', m4(wv'), lamv);
c = [perto(sum(C, 1), [2.033 3.833 6.5 11], 5e-4), ...
     perto(C ./ sum(C, 1), [0.492 0.522 0.462 0.455; 0.246 0.261 0.308 0.273; ...
                            0.164 0.130 0.154 0.182; 0.098 0.087 0.077 0.091], 5e-4), ...
     perto(w, [0.4824 0.2718 0.1575 0.0883], 5e-5), ...
     perto(C*w, [1.940 1.093 0.631 0.354], 5e-4), ...
     perto(C*w ./ w, [4.021 4.021 4.005 4.011], 5e-4), ...
     perto(lam, 4.0145, 5e-5), perto(IC, 0.0048, 5e-5), perto(RC, 0.005, 5e-4), ...
     perto(wv, [0.4829 0.2720 0.1570 0.0882], 5e-5), perto(lamv, 4.0145, 5e-5)];
ok = ok && all(c);

% ------------------------------------------------------------ juízo incoerente a13 = 1/2
Cm = C;  Cm(1, 3) = 1/2;  Cm(3, 1) = 2;
[wm, lamm, ~, RCm] = Prioridades(Cm);
R = Cm .* (wm' ./ wm);                                % a_ij w_j / w_i (devia ser perto de 1)
pior = 0;  ip = 1;  jp = 1;
for i = 1:4
  for j = i+1:4
    if abs(log(R(i, j))) > pior
      pior = abs(log(R(i, j)));  ip = i;  jp = j;
    end
  end
end
fprintf('\nJuízo incoerente a13 = 1/2 (os outros cinco iguais)\n');
fprintf('  lambda_max = %.4f  RC = %.4f -> %s\n', lamm, RCm, coer{(RCm < 0.1) + 1});
fprintf('  pesos w: %s\n', m4(wm'));
fprintf('  a_ij w_j / w_i: %s\n', m2(R));
fprintf('  par mais afastado de 1: %s–%s (%.2f e %.2f)\n', crit{ip}, crit{jp}, R(ip, jp), R(jp, ip));
RCa = zeros(1, 2);  as = [3 1];
for t = 1:2
  Ct = C;  Ct(1, 3) = as(t);  Ct(3, 1) = 1/as(t);
  [~, ~, ~, RCa(t)] = Prioridades(Ct);
end
fprintf('  a13 = 3: RC = %.4f;  a13 = 1: RC = %.4f\n', RCa(1), RCa(2));
c = [perto(lamm, 4.467, 5e-4), perto(RCm, 0.173, 5e-4), perto(wm, [0.343 0.292 0.276 0.089], 5e-4), ...
     perto(R, [1 1.70 0.40 1.30; 0.59 1 1.89 0.92; 2.49 0.53 1 0.65; 0.77 1.09 1.54 1], 5e-3), ...
     ip == 1 && jp == 3, perto(RCa(1), 0.005, 5e-4), perto(RCa(2), 0.069, 5e-4)];
ok = ok && all(c);

% ------------------------------------------------------------ assistência (critério qualitativo)
S = MatrizReciproca(3, [1 2 1/3; 1 3 3; 2 3 5]);
[ws, lams, ICs, RCs] = Prioridades(S);
fprintf('\nAssistência (A, B, C): prioridades %s  lambda_max = %.4f  IC = %.4f  RC = %.4f\n', ...
        m4(ws'), lams, ICs, RCs);
c = [perto(ws, [0.2605 0.6333 0.1062], 5e-5), perto(lams, 3.039, 5e-4), ...
     perto(ICs, 0.019, 5e-4), perto(RCs, 0.033, 5e-4)];
ok = ok && all(c);

% ------------------------------------------------------------ Exemplo 1: três frutos
F = MatrizReciproca(3, [1 2 1/3; 1 3 5; 2 3 7]);     % F2 face a F1: 3; F1 face a F3: 5; F2 face a F3: 7
fprintf('\nExemplo 1 (frutos F1, F2, F3)\n');
[wf, lamf, ICf, RCf] = Prioridades(F);
fprintf('%s', passo(F, wf, lamf, ICf, RCf));
[~, ordem] = sort(wf, 'descend');
fprintf('  ordem: %s;  coerência perfeita pediria F2/F3 = 3 x 5 = 15 (o juízo foi 7)\n', ...
        strjoin(arrayfun(@(i) sprintf('F%d', i), ordem', 'UniformOutput', false), ', '));
c = [perto(sum(F, 1), [4.2 1.476 13], 5e-4), perto(wf, [0.283 0.643 0.074], 5e-4), ...
     perto(F*wf ./ wf, [3.062 3.121 3.013], 5e-4), ...
     perto(lamf, 3.066, 5e-4), perto(ICf, 0.033, 5e-4), perto(RCf, 0.056, 5e-4), isequal(ordem', [2 1 3])];
ok = ok && all(c);

% ------------------------------------------------------------ Exemplo 2: duas propostas de emprego
E = [1 1/7 1/2; 7 1 5; 2 1/5 1];
fprintf('\nExemplo 2 (emprego, propostas A e B)\n');
[we, lame, ICe, RCe] = Prioridades(E);
fprintf('%s', passo(E, we, lame, ICe, RCe));
% salário como comparação coerente (B paga 2500/2000 = 1.25 vezes mais); critérios 2 e 3: A 3 e 5 vezes
Me = [Prioridades(MatrizReciproca(2, [1 2 2000/2500])), ...
      Prioridades(MatrizReciproca(2, [1 2 3])), ...
      Prioridades(MatrizReciproca(2, [1 2 5]))];
Se = Me * we;
[~, b] = max(Se);  AB = 'AB';
fprintf('  prioridades locais (linhas A, B; colunas salário, critério 2, critério 3): %s\n', m4(Me));
fprintf('  pontuação: A %.4f  B %.4f -> proposta %s\n', Se(1), Se(2), AB(b));
fprintf('  implícito c2/c3 = 7 x 1/2 = %.1f; o juízo foi 5\n', E(2, 1) * E(1, 3));
c = [perto(sum(E, 1), [10 1.343 6.5], 5e-4), perto(we, [0.094 0.738 0.168], 5e-4), ...
     perto(lame, 3.014, 5e-4), perto(ICe, 0.007, 5e-4), perto(RCe, 0.012, 5e-4), ...
     perto(Me, [0.444 0.75 0.833; 0.556 0.25 0.167], 5e-4), perto(Se, [0.735 0.265], 5e-4), b == 1];
ok = ok && all(c);

simnao = {'não', 'sim'};
fprintf('\nconfere com os slides: %s\n', simnao{ok + 1});
