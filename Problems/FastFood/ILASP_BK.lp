%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Background Knowledge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

0 { depot(RN,RK) } 1 :- restaurant(RN,RK).
:- number_depots(M), M+1 #count { RN : depot(RN,RK)} .
m:- number_depots(M), M #count { RN : depot(RN,RK)} .
:- not m.
%
serves(N1,|P1-P3|) :-  restaurant(N1,P1), depot(N3,P3), not depot(N2,P2): restaurant(N2,P2), |P1-P3| > |P1-P2|.
%
 :~ serves(RN,D). [D@1,RN]
