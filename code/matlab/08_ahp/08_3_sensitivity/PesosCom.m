function r = PesosCom(w, k, p)
%PESOSCOM  Pesos com p no critério k; os restantes mantêm as proporções entre si.
%
%   r = PesosCom(w, k, p)
%   w_j(p) = w_j (1 - p) / (1 - w_k), j ~= k;  r(k) = p.  r é uma coluna.
%
%   Complementos de IO — deck 8.3.  J. F. A. Madeira — Licença MIT.
r = double(w(:));
r(k) = 0;
r = r / sum(r) * (1 - p);
r(k) = p;
end
