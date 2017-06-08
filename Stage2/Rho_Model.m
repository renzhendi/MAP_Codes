% This function implements our latest model, predicting the height of Row
% at the higher rank from that at the base rank.
%
% Row_b: the vector containing the height (rho) of 50%Succ at base rank
% r1: base rank
% r2: predicted rank
% n1: matrix size at r1
% n2: matrix size at r2

function Rho_p = Rho_Model(Rho_b, r1, r2, n1, n2)

alpha = r2/r1;
beta = 0;
numerator = r2*(log2(sqrt(2)*n1)+r1);
denominator = r1*(log2(sqrt(2)*n2)+r2);
coefficient = alpha^beta*(numerator/denominator);

Rho_p = coefficient * Rho_b;