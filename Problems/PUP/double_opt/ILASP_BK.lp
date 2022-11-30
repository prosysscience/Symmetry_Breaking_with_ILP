%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Background Knowledge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

zone(Z) :- zone2sensor(Z,D).
sensor(D) :- zone2sensor(Z,D).

0{unit2zone(U,Z)}1 :- zone(Z), comUnit(U).
0{ unit2sensor(U,S) }1 :- sensor(S), comUnit(U).
:- unit2zone(U1,Z), unit2zone(U2,Z), comUnit(U1), comUnit(U2), U1 != U2.
:- unit2sensor(U1,S), unit2sensor(U2,S), comUnit(U1), comUnit(U2), U1 != U2.
:- not unit2zone(_,Z), zone(Z).
:- not unit2sensor(_,S), sensor(S).
:- comUnit(U), maxElements(M), M+1 #count { Z : unit2zone(U,Z)}.
:- comUnit(U), maxElements(M), M+1 #count { S : unit2sensor(U,S) }.
partnerunits(U,P) :- unit2zone(U,Z), zone2sensor(Z,S), unit2sensor(P,S), U!=P.
partnerunits(U,P) :- partnerunits(P,U), comUnit(U), comUnit(P).
:- comUnit(U), maxPU(M), M+1 #count { P : partnerunits(U,P)}.

 :~ unit2sensor(U,S). [U@1]
 :~ unit2zone(U,S). [U@1]
