function [valor, plano, f, dec] = MaoObra(b, ce, cf, cv, x0)
%MAOOBRA  Gestão da mão-de-obra por programação dinâmica (recursão para trás).
%
%   [valor, plano, f, dec] = MaoObra(b, ce, cf, cv, x0)
%   O modelo das aulas: necessidades b(t) na semana t (nunca se trabalha com menos);
%   excesso ce por operário a mais por semana; contratar y > 0 pessoas custa cf + cv*y;
%   dispensar não custa. x0 = operários antes da semana 1 (por omissão 0).
%   Etapa = semana; estado s = operários na semana anterior; decisão x = operários nesta semana:
%       f_t(s) = min_{b_t <= x <= max(b)} { c_t(s, x) + f_{t+1}(x) },  f_{n+1}(s) = 0,
%       c_t(s, x) = ce (x - b_t) + [x > s] (cf + cv (x - s)).
%   valor = f_1(x0); plano: lido para a frente (primeira decisão ótima em caso de empate).
%   f: cell 1 x (n+1); f{t}(s+1) = f_t(s) (NaN nos estados que não ocorrem); f{n+1} = 0.
%   dec: cell 1 x n; dec{t}{s+1} = decisões ótimas no estado s da semana t.
%
%   Complementos de IO — deck 5.3.  J. F. A. Madeira — Licença MIT.
if nargin < 5, x0 = 0; end
n = numel(b);  M = max(b);
custo = @(s, x, t) ce*(x - b(t)) + (x > s)*(cf + cv*(x - s));
f = cell(1, n + 1);  dec = cell(1, n);
f{n+1} = zeros(1, M + 1);
for t = n:-1:1                            % semana n -> 1
  if t == 1, estados = x0; else, estados = b(t-1):M; end
  f{t} = NaN(1, M + 1);  dec{t} = cell(1, M + 1);
  for s = estados
    xs = b(t):M;
    vals = arrayfun(@(x) custo(s, x, t), xs) + f{t+1}(xs + 1);
    m = min(vals);
    f{t}(s + 1) = m;
    dec{t}{s + 1} = xs(vals == m);
  end
end
s = x0;  plano = zeros(1, n);             % ler o plano para a frente
for t = 1:n
  s = dec{t}{s + 1}(1);
  plano(t) = s;
end
valor = f{1}(x0 + 1);
end
