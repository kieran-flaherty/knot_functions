%This function calculates the writhe of a knot from its DT code
%This function will not work for reducible DT codes as the function
%realiseDT() does also not work for reducible DT codes.
function writhe = writhe(DT)
    [S,f] = realiseDT(DT);
    h = handed(S,f);
    RH = sum(h==-1);
    LH = sum(h==1);
    writhe = abs(RH-LH);
end