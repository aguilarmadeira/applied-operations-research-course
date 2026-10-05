function r = Risco(C, h, custos)
%RISCO  Critérios probabilísticos: valor esperado (MVE), perda de oportunidade esperada (POE), VEIP.
%
%   r = Risco(C, h)          ganhos;  r = Risco(C, h, true)  custos
%   r.VE, r.POE (uma por ação), r.info_perfeita, r.VEIP = min POE, r.soma (igual em todas as linhas),
%   r.escolha_VE, r.escolha_POE (índices).
%
%   Complementos de IO — deck 1.3.  J. F. A. Madeira — Licença MIT.
if nargin < 3, custos = false; end
h = h(:);
if any(h < 0) || abs(sum(h) - 1) > 1e-9
  error('as probabilidades têm de ser >= 0 e somar 1');
end
ve = (C*h)';
poe = (Arrependimentos(C, custos)*h)';
if custos
  info = min(C, [], 1)*h;  alvo = min(ve);  soma = ve - poe;
else
  info = max(C, [], 1)*h;  alvo = max(ve);  soma = ve + poe;
end
r = struct('VE', ve, 'POE', poe, 'info_perfeita', info, 'VEIP', min(poe), 'soma', soma, ...
           'escolha_VE', find(abs(ve - alvo) < 1e-9), 'escolha_POE', find(abs(poe - min(poe)) < 1e-9));
end
