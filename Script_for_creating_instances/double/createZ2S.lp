#const n = 6.

zone(2..2*n).

p(1,1).
p(1,2).

p(I,2*I) :- zone(I), I<n.
p(I,2*I-1) :- zone(I), I<=n.
p(I,2*I-3) :- zone(I), I<=n.

p(n+1,2).
p(n+1,2*n).

p(I,2*(I-n)) :- zone(I), I>n+1, I<2*n.
p(I,I+n-1) :- zone(I), I>n+1, I<2*n.
p(I,I+n-2) :- zone(I), I>n+1.

p(2*n,2*n-1).
#show p/2.
