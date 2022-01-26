% lower = max( |sensors|, |zones| ) / unitcap (round up)

zone(Z) :- zone2sensor(Z,D).
sensor(D) :- zone2sensor(Z,D).

%comUnit(1..L) :- lower(L).
1 { unit2zone(U,Z) : comUnit(U) } 1 :- zone(Z).
1 { unit2sensor(U,S) : comUnit(U) } 1 :- sensor(S).
:- comUnit(U), maxElements(M), M+1 { unit2zone(U,Z): zone(Z) }.
:- comUnit(U), maxElements(M), M+1 { unit2sensor(U,S): sensor(S) }.
partnerunits(U,P) :- unit2zone(U,Z), zone2sensor(Z,S), unit2sensor(P,S), U!=P.
partnerunits(U,P) :- partnerunits(P,U), comUnit(U), comUnit(P).
:- comUnit(U), maxPU(M), M+1 { partnerunits(U,P): comUnit(P) }.
