%This function returns a realisation (S,f) of a knot K given by a knot in
%Dowker-Thistletwaite notation.

%The function will only work for standard sequences of minimal lexographic
%order as described by Dowker and Thistletwaite in 'Classifying Knot
%Projections'

function [S,f,reducible] = realiseDT(DT)
    n = length(DT);
    l = 1:2*n;
    DTodd = 1:2:2*n; %the odd conterparts of the even numbers in the DT code
    S = zeros(1,length(l)); %contains the values of the involutory function a_i
    f = zeros(1,length(l)); %f is the orientation function defined by Dowker and Thistletwaite
    phi = zeros(1,length(l)); %phi is the funtion phi_i
    for x = 1:2*n %calculate a_i
        if mod(x,2) == 0
            S(x) = DTodd(abs(DT) == x); %finds the even numbers odd counterpart
        else
            S(x) = DT(DTodd == x); %finds the odd numbers even counterpart
        end
    end
    S = abs(S);
    A = [1 S(1)];f(1)=1;f(S(1))=-1;
    while isempty(A) == 0 %while set A is not empty
        i = min(A); %i is minimum member of A
        %caclulate the interval [i,a_i]mod2n
        if S(i) > i
            interval = [i:S(i)];
        elseif i > S(i)
            interval = [i:2*n 1:S(i)];
        end
        phi(:) = 0; %clears phi array for next loop
        phi(i) = 1;
        
        %calculates all values of phi_i()
        for x = i+1:2*n
            if ismember(S(x),interval)
                phi(x) = -phi(x-1);
            else
                phi(x) = phi(x-1);
            end
        end
        if ismember(S(1),interval)
            phi(1) = -phi(2*n);
        else
            phi(1) = phi(2*n);
        end
        for x = 2:i-1
            if ismember(S(x),interval)
                phi(x) = -phi(x-1);
            else
                phi(x) = phi(x-1);
            end
        end
        
        %calculates D_i = {1,..,2n}\[i,a_i]
        D = setdiff(l,interval);
        %while d is not empty
        while isempty(D) == 0
            x = min(D);
            %check if x-1 =0, if so we want x-1 to be 2n so
            %if x-1 is not zero, we just set xm1 to x-1
            if x-1 == 0
                xm1 = 2*n;
            else
                xm1 = x-1;
            end
            %similarly if a(x)-1 = 0 we want it to be 2n
            if S(x)-1 == 0
                sxm1 = 2*n;
            else
                sxm1 = S(x)-1;
            end
            %similarly if a(x)+1 > 2n, we wan
            if S(x)+1 > 2*n
                sxp1 = 1;
            else
                sxp1 = S(x)+1;
            end
            if x<i
                if ismember(S(x),interval) == 0 %a_x is not in interval [i,a_i] 
                    if phi(x)*phi(S(x)) == 1
                        %remove x and a_x from D_i
                        D = setdiff(D,[x S(x)]);
                    elseif phi(x)*phi(S(x)) == -1
                        %reject S, not realisable
                        error('Sequence is not realisable')
                    end
                else
                    if f(x) ~= 0 %if f(x) is defined
                        if phi(x)*phi(S(x))*f(i) == f(x)
                            %remove x from D_i
                            D = setdiff(D,x);
                        elseif phi(x)*phi(S(x))*f(i) == -f(x)
                            %s is not realisable
                            error('Sequence is not realisable')
                        end
                    else %else if f(x) is not defined
                        f(x) = phi(x)*phi(S(x))*f(i);
                        f(S(x)) = -f(x);
                        if (S(xm1)==sxp1)||(S(xm1)==sxm1)%(here a_x + 1 is mod 2n, and taking 0 as 2n for x-1)
                            %remove x from D_i
                            D = setdiff(D,x);
                        else
                            %add x and a_x to A,remove x from D_i
                            A = [A x S(x)];
                            D = setdiff(D,x);
                        end
                    end
                end
            elseif x>S(i)
                if ismember(S(x),interval) == 0 %a_x is not in interval [i,a_i]
                    %remove x and a_x from D_i
                    D = setdiff(D,[x S(x)]);
                else
                    if f(x) ~= 0 %f(x) already defined
                        %remove x from D_i
                        D = setdiff(D,x);
                    else %f(x) is not defined
                        f(x) = phi(x)*phi(S(x))*f(i);
                        f(S(x)) = -f(x);
                        if (S(xm1)==sxp1)||(S(xm1)==sxm1)%(here a_x + 1 is mod 2n, and taking 0 as 2n for x-1)
                            %remove x from D_i
                            D = setdiff(D,x);
                        else
                            %add x and a_x to A,remove x from D_i
                            A = [A x S(x)];
                            D = setdiff(D,x);
                        end
                    end
                end
            end
        end
        %once the loop finishes D_i must be empty so remove i and a_i from
        %A
        A = setdiff(A,[i S(i)]);
    end
        disp('----------')
    
    %Now that the realisation is calculated, we check if 
    %the knot is reducible by checking for any zeros in the vector f.
    if sum(f(:)==0) > 1
        reducible = 1;
        disp('The realisation contains zeros, the DT code is realisable but this knot is likely reducible')
    else
        reducible = 0;
    end
    %This is the same loop used at the start of the function to construct
    %S. We must now reconstruct the vector S as we took its absolute value
    %and the negative numbers are reqiured to tell us information about the
    %crossing
    for x = 1:2*n %calculate a_i
        if mod(x,2) == 0
            S(x) = DTodd(abs(DT) == x); %finds the even numbers odd counterpart
        else
            S(x) = DT(DTodd == x); %finds the odd numbers even counterpart
        end
    end
end
    %now A is empty so S must be realisable
    %and we have [S,f] which can be used to determine handedness