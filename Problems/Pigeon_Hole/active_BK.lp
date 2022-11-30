%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extra Predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_hole(M) :- hole(M), not hole(M+1).
max_pigeon(P) :- pigeon(P), not pigeon(P+1).

next_pigeon(P-1,P) :- P>1, max_pigeon(P).
next_pigeon(P-1,P) :- next_pigeon(P,_), P>1.

assignGEQ(P,H) :- assign(P,H).
assignGEQ(P,H) :- assignGEQ(P,H+1), H>0.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SBCs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Iteration n None
%% From files: p3_h4.lp
 :- assignGEQ(V1,V3), not assignGEQ(V2,V3), next_pigeon(V1,V2).

