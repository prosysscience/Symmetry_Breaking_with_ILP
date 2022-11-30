%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extra Predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_cabinet(X) :- cabinet(X), not cabinet(X+1).
max_person(X) :- person(X), not person(X+1).
max_thing(X) :- thing(X), not thing(X+1).

next_cabinet(C-1,C) :- C>1, max_cabinet(C).
next_cabinet(C-1,C) :- next_cabinet(C,_), C>1. 
next_person(P-1,P) :- P>1, max_person(P).
next_person(P-1,P) :- next_person(P,_), P>1.
next_thing(T-1,T) :- T>1, max_thing(T).
next_thing(T-1,T) :- next_thing(T,_), T>1.  

cabinetGEQ(C,T) :- cabinetTOthing(C,T).
cabinetGEQ(C,T) :- cabinetGEQ(C+1,T), C>0.
personGEQ(P,T) :- personTOthing(P,T).
personGEQ(P,T) :- personGEQ(P+1,T), P>0.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SBCs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Iteration n 1
%% From files: p1_c2_t4.lp
 :- cabinetGEQ(V3,V1), not cabinetGEQ(V3,V2), next_thing(V1,V2).

%% Iteration n 2
%% From files: p2_c2_t3.lp
 :- not personGEQ(V1,V3), next_thing(V2,V3), personGEQ(V1,V2).

