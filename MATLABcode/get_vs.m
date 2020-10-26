%vs‚Ìæ“¾_160204
function vs = get_vs(R, Ds, nu)
%Dietrich (1982) ‚ÉŠî‚Ã‚¢‚ÄA‘ÍÏ•¨‚Ì’¾~‘¬“x‚ğŒvZ‚·‚é

g = 9.8;

Rep = (R .* g .* Ds) .^ 0.5 .* Ds ./ nu;

b1 = 2.891394; b2 = 0.95296; b3 = 0.056835; b4 = 0.002892; b5 = 0.000245;

Rf = exp(-b1+b2.*log(Rep)-b3.*log(Rep).^2 - b4 .* log(Rep) .^3 + b5 .* log(Rep) .^ 4); 

vs = Rf .* (R .* g .* Ds) .^ 0.5;

end