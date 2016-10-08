%This function, given a realisation of a DT code, will return a vector
%handed where if handed(i) is 1, the crossing is RH, if handed(i) is -1,
%the crossing is LH.
function handed = handed(S,f)
    n = length(S)/2;
    handed = zeros(1,n);
    %I will follow the convention where the nth crossing is the crossing
    %labeled with the odd number 2*n -1. and also the arc labelled n is given by the
    %sequence a(n)-1,a(n),a(n)+1.
    for c = 1:n
        %if even strand over from R2L => LH
        %elseif even strand under from R2L => RH
        %elseif even strand over from L2R => RH
        %elseif even strand under from L2R => LH
        if ((S(2*c-1) > 0) && (f(abs(S(2*c-1)))==1)) 
            handed(c) = -1;
        elseif ((S(2*c-1) < 0) && (f(abs(S(2*c-1)))==1))
            handed(c) = 1;
        elseif ((S(2*c-1) > 0) && (f(abs(S(2*c-1)))==-1))
            handed(c) = 1;
        elseif ((S(2*c-1) < 0) && (f(abs(S(2*c-1)))==-1))
            handed(c) = -1;
        end
    end
end