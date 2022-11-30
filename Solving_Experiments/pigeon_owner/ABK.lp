%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extra Predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_hole(M) :- hole(M), not hole(M+1).
max_pigeon(P) :- pigeon(P), not pigeon(P+1).
max_color(C) :- color(C), not color(C+1).
max_owner(O) :- owner(O), not owner(O+1).

next_pigeon(P-1,P) :- P>1, max_pigeon(P).
next_pigeon(P-1,P) :- next_pigeon(P,_), P>1.
next_color(C-1,C) :- C>1, max_color(C).
next_color(C-1,C) :- next_color(C,_), C>1. 
next_owner(O-1,O) :- O>1, max_owner(O).
next_owner(O-1,O) :- next_owner(O,_), O>1.

assignGEQ(P,H) :- assign(P,H).
assignGEQ(P,H) :- assignGEQ(P,H+1), H>0.
colorGEQ(P,C) :- assign_color(P,C).
colorGEQ(P,C) :- colorGEQ(P+1,C), P>0.
ownerGEQ(P,O) :- assign_owner(P,O).
ownerGEQ(P,O) :- ownerGEQ(P+1,O), P>0.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SBCs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Iteration n 1
%% From files: o1_c1_p3_h3.lp
 :- assignGEQ(V1,V3), not assignGEQ(V2,V3), next_pigeon(V1,V2).

%% Iteration n 2
%% From files: o1_c2_p3_h5.lp
 :- colorGEQ(V3,V1), not colorGEQ(V3,V2), next_color(V1,V2).

%% Iteration n 3
%% From files: o2_c2_p3_h6.lp
 :- not ownerGEQ(V1,V3), next_owner(V2,V3), ownerGEQ(V1,V2).

