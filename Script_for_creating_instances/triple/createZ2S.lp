#const n = 3.

zone(1..3*n).

aux(1,I,J+1):- zone(I), I\3 = 1, J = I /3.
aux(2,I,J+1):- zone(I), I\3 = 2, J = I /3.
aux(0,I,J):- zone(I), I\3 = 0, J = I /3.

p(1,2).
p(I,2*J) :- aux(1,I,J), I > 1.
p(I,(2*J)-1) :- aux(1,I,J).
p(I,(2*J)+2) :- aux(1,I,J), J < n.

p(2,2).
p(I,(2*J)-1) :- aux(2,I,J), I > 2.
p(I,(2*n)+J) :- aux(2,I,J).

p(I,(3*n)+J) :- aux(0,I,J).
p(I,(3*n)+J+1) :- aux(0,I,J), J < n.
p(I,(2*n)+J) :- aux(0,I,J).


#show p/2.
