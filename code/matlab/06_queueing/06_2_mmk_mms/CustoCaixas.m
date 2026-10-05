function tab = CustoCaixas(lam, mu, c_serv, c_esp, smax, base)
%CUSTOCAIXAS  Custo por unidade de tempo de s servidores (M/M/s), do primeiro s estável até smax.
%
%   tab = CustoCaixas(lam, mu, c_serv, c_esp)              smax = 10, base = 'Lq'
%   tab = CustoCaixas(lam, mu, c_serv, c_esp, smax, base)  base = 'Lq' ou 'L'
%   tab tem uma linha [s Pw Lq L custo] por s > lam/mu, com
%   custo = c_serv s + c_esp * (Lq ou L, conforme base).
%
%   Complementos de IO — deck 6.2.  J. F. A. Madeira — Licença MIT.
if nargin < 5, smax = 10; end
if nargin < 6, base = 'Lq'; end
tab = zeros(0, 5);
for s = floor(lam / mu) + 1:smax
  m = Mms(lam, mu, s);
  tab(end + 1, :) = [s m.Pw m.Lq m.L c_serv * s + c_esp * m.(base)]; %#ok<AGROW>
end
end
