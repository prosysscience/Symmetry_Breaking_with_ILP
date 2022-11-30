%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extra Predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_hole(M) :- hole(M), not hole(M+1).
max_pigeon(P) :- pigeon(P), not pigeon(P+1).
max_color(C) :- color(C), not color(C+1).

next_pigeon(P-1,P) :- P>1, max_pigeon(P).
next_pigeon(P-1,P) :- next_pigeon(P,_), P>1.
next_color(C-1,C) :- C>1, max_color(C).
next_color(C-1,C) :- next_color(C,_), C>1. 

colorGEQ(P,C) :- assign_color(P,C).
colorGEQ(P,C) :- colorGEQ(P+1,C), P>0.
assignGEQ(P,H) :- assign(P,H).
assignGEQ(P,H) :- assignGEQ(P,H+1), H>0.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SBCs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Iteration n 1
%% From files: c1_p3_h4.lp
 :- assignGEQ(V1,V3), not assignGEQ(V2,V3), next_pigeon(V1,V2).

%% Iteration n 2
%% From files: c2_p3_h4.lp
 :- colorGEQ(V3,V1), not colorGEQ(V3,V2), next_color(V1,V2).

