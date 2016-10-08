%This function uses the definition of the Alexander Polynomial to calculate
%the determinant of a knot.
function kdet = knot_det(DT)
    syms t;
    A_k = alexander_polynomial_combi(DT);
    kdet = abs(subs(A_k,t,-1));
end