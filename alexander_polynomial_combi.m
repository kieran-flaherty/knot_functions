%This function computes the Alexander polynomial of a knot using the
%combinatorial method
function A = alexander_polynomial_combi(DT)
    n = length(DT); %number of crossings
    [S,f] = realiseDT(DT); %calculate a realisation of the knot
    h = handed(S,f); %obtain handedness of each crossing
    syms t; %symbolic variable for polynomial
    amatrix = sym(zeros([n n])); %alexander matrix
    nextlabel = 1;
    %Now we will store the labels along each arc in a cell array
    Arc = {};
    %There are n crossings, so there will be n arcs.
    newarc = [1];
    while length(Arc) < n
        if nextlabel+1>2*n
            nextlabel = 1;
        else
            nextlabel = nextlabel +1;
        end
        if mod(nextlabel,2) == 0 %label is even
            %now check if label is 'over' or 'under' the crossing
            if S(abs(S(nextlabel))) > 0 %over crossing
                %add label to arc
                newarc = [newarc nextlabel];
            else %under crossing
                %add arc to list
                newarc = [newarc nextlabel];
                Arc{end+1} = newarc;
                newarc = [nextlabel];
            end  
        else %label is odd
            if S(nextlabel) > 0 %under crossing
                %add arc to list
                newarc = [newarc nextlabel];
                Arc{end+1} = newarc;
                newarc = [nextlabel];
            else %over crossing
                newarc = [newarc nextlabel];
            end
        end
    end
    %Again, here i follow the convention that crossing n is the crossin
    %with odd DT label 2n-1.
    for c = 1:n %loop over each crossing
        cpair = [2*c-1,abs(S(2*c-1))];
        %loop over arcs and label i,j,k
        for p = 1:length(Arc)
            %find j the arc with cpair at its end
            if (Arc{p}(end) == cpair(1))||(Arc{p}(end) == cpair(2))
                j = p;
            %find k the arc with cpair at its start
            elseif (Arc{p}(1) == cpair(1))||(Arc{p}(1) == cpair(2))
                k = p;
            end
            %find i the arc with cpair labeling in the middle (anywhere)
            %from 2:v-1 where v is the number of crossings on the arc
            if length(Arc{p})>2 %checks if arc goes over any crossing
                 for v=2:length(Arc{p})-1
                     if (Arc{p}(v) == cpair(1))||(Arc{p}(v) == cpair(2))
                         i=p;
                     end
                 end
            end
        end
        %i is the row with the over arc label []
        %First we must check the handedness of the crossing
        if h(c) == 1 %RH
            amatrix(c,i) = 1-t;
            amatrix(c,j) = -1;
            amatrix(c,k) = t;
        else %LH
            amatrix(c,i) = 1-t;
            amatrix(c,j) = t;
            amatrix(c,k) = -1; 
        end
    end
    %amatrix
    amatrix(:,n) = [];
    amatrix(n,:) = [];
    A = det(amatrix);
end

