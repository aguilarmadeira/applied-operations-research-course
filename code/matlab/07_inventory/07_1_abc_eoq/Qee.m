function r = Qee(D, Ce, Cp, Ca, TR)
%QEE  Quantidade económica de encomenda (modelo de Wilson).
%
%   r = Qee(D, Ce, Cp)            r = Qee(D, Ce, Cp, Ca, TR)
%   D: procura por período; Ce: custo por encomenda; Cp: custo de posse por unidade e período;
%   Ca: preço unitário (por omissão 0; só entra no custo total); TR: prazo de entrega (no mesmo período).
%   r.Q = sqrt(2 D Ce / Cp), r.n = D/Q, r.T = Q/D, r.Kenc, r.Kpos, r.K (com a compra)
%   e r.Pe = D TR (vazio se não se der TR).
%
%   Complementos de IO — deck 7.1.  J. F. A. Madeira — Licença MIT.
if nargin < 4, Ca = 0; end
Q = sqrt(2 * D * Ce / Cp);
if nargin < 5 || isempty(TR), Pe = []; else, Pe = D * TR; end
r = struct('Q', Q, 'n', D / Q, 'T', Q / D, 'Kenc', D * Ce / Q, 'Kpos', Cp * Q / 2, ...
           'K', D * Ca + D * Ce / Q + Cp * Q / 2, 'Pe', Pe);
end
