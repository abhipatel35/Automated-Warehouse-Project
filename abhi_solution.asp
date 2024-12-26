#include "parsing.asp".
#include "convert_input.asp".

#const n=50.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%    GENERATING ACTIONS     %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

move(0,1;0,-1;-1,0;1,0).

{robo_vehicleMove(R,move(DX,DY),T):move(DX,DY)}1:- R=1..NR, numrobo_vehicles(NR), T=0..TN,TN=n-1.
{pickupPoint(R,SI,T):storageUnit(SI)}1:- R=1..NR, numrobo_vehicles(NR), T=0..TN,TN=n-1.
{putDownstorageUnit(R,SI,T):storageUnit(SI)}1:- R=1..NR, numrobo_vehicles(NR), T=0..TN,TN=n-1.
{deliver(R,OI,with(SI,PR,DQ),T):shipmentAt(OI,object(cell,ND),contains(PR,OQ),T), itemOn(PR,object(storageUnit,SI),with(quantity,PQ),T), DQ=1..PQ}1:- R=1..NR, numrobo_vehicles(NR), T=0..TN,TN=n-1.

%converting them to the necessary output
occurs(object(robo_vehicle,R),move(DX,DY),T):-robo_vehicleMove(R,move(DX,DY),T).
occurs(object(robo_vehicle,R),pickup,T):-pickupPoint(R,_,T).
occurs(object(robo_vehicle,R),putdown,T):-putDownstorageUnit(R,_,T).
occurs(object(robo_vehicle,R),deliver(OI,PRI,DQ),T):-deliver(R,OI,with(SI,PRI,DQ),T).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%    ACTION CONSTRAINTS     %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Two actions cannot occur at the same time
:- occurs(object(robo_vehicle,R),A1,T), occurs(object(robo_vehicle,R),A2,T), A1!=A2.

%%%%%%%%%%%%        robo_vehicle MOVING        %%%%%%%%%%%%
% robo_vehicle cannot move outside of the grid
:- robo_vehicleAt(RI,object(cell,ND),T), robo_vehicleMove(R,move(DX,DY),T), cellAt(ND,pair(X,Y)), X+DX<1.
:- robo_vehicleAt(RI,object(cell,ND),T), robo_vehicleMove(R,move(DX,DY),T), cellAt(ND,pair(X,Y)), Y+DY<1.
:- robo_vehicleAt(RI,object(cell,ND),T), robo_vehicleMove(R,move(DX,DY),T), cellAt(ND,pair(X,Y)), X+DX>NC, numColumns(NC).
:- robo_vehicleAt(RI,object(cell,ND),T), robo_vehicleMove(R,move(DX,DY),T), cellAt(ND,pair(X,Y)), Y+DY>NR, numRows(NR).


%%%%%%%%%%%%      PICKING UP storageUnit      %%%%%%%%%%%%
% A storageUnit cant be picked up by 2 robo_vehicles
:- 2{pickupPoint(R,S,T): robo_vehicle(R)}, storageUnit(S).

% A robo_vehicle cannot pickup a storageUnit if it already has one.
:- pickupPoint(RI,S1,T), storageUnitOn(S2,object(robo_vehicle,RI),T).

% A robo_vehicle cannot pickup a storageUnit a storageUnit is already on a robo_vehicle
:- pickupPoint(R1,S,T), storageUnitOn(S,object(robo_vehicle,R2),T).

% A robo_vehicle can pick up storageUnit only if it is on the cell containing that storageUnit
:- pickupPoint(RI,S,T), storageUnitOn(S,object(cell,ND),T), not robo_vehicleAt(RI,object(cell,ND),T). 


%%%%%%%%%%%%     PUTTING DOWN storageUnit     %%%%%%%%%%%%
% A storageUnit cant be putDown by 2 robo_vehicles
:- 2{putDownstorageUnit(R,S,T): robo_vehicle(R)}, storageUnit(S).

% A robo_vehicle can put down a storageUnit only if it has one.
:- putDownstorageUnit(RI,S,T), not storageUnitOn(S,object(robo_vehicle,RI),T).

% A robo_vehicle cannot putdown a storageUnit on a lane
:- putDownstorageUnit(RI,S,T), robo_vehicleAt(RI,object(cell,ND),T), lane(ND). 


%%%%%%%%%%%%         DELIVERING         %%%%%%%%%%%%

% Can only deliver if robo_vehicle is on picking station
:- deliver(R,OI,with(_,PR,_),T), shipmentAt(OI,object(cell,ND),contains(PR,_),T), not robo_vehicleAt(R,object(cell, ND),T).

% Can only deliver if robo_vehicle has the storageUnit containing item
:- deliver(R,OI,with(SI,PR,_),T), itemOn(PR,object(storageUnit,SI),with(quantity,_),T), not storageUnitOn(SI,object(robo_vehicle,R),T).

% Cannot deliver more quantities than the shipment.
:- deliver(R,OI,with(SI,PR,DQ),T), shipmentAt(OI,object(cell,ND),contains(PR,OQ),T), DQ>OQ.

% Cannot deliver more quantities than the item.
:- deliver(R,OI,with(SI,PR,DQ),T), itemOn(PR,object(storageUnit,SI),with(quantity,PQ),T), DQ>PQ.




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%    STATES CONSTRAINTS     %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Picking Station cannot be a lane
:- pickingStationAt(_,NDI), lane(NDI).

% storageUnit cannot be on a lane.
:- storageUnitOn(S,object(cell,NDI),_), lane(NDI).

%%%%%%%%%%%%        robo_vehicle        %%%%%%%%%%%%
% No robo_vehicle on 2 cells
:- 2{robo_vehicleAt(R,object(cell,ND),T):cell(ND)}, robo_vehicle(R), T=0..n.

% No 2 robo_vehicles on the same cell
:- 2{robo_vehicleAt(R,object(cell,ND),T):robo_vehicle(R)}, cell(ND), T=0..n.

% robo_vehicles cant swap places
:- robo_vehicleAt(R1,object(cell,ND1),T), robo_vehicleAt(R1,object(cell,ND2),T+1), robo_vehicleAt(R2,object(cell,ND2),T), robo_vehicleAt(R2,object(cell,ND1),T+1), R1!=R2.


%%%%%%%%%%%%        storageUnit        %%%%%%%%%%%%

% No storageUnit on 2 robo_vehicles
:- 2{storageUnitOn(S,object(robo_vehicle,NR),T): robo_vehicle(NR)}, storageUnit(S), T=0..n.

% No 2 shelves on the same robo_vehicle
:- 2{storageUnitOn(S,object(robo_vehicle,NR),T): storageUnit(S)}, robo_vehicle(NR), T=0..n.

% No storageUnit on 2 cells
:- 2{storageUnitOn(S,object(cell,ND),T): cell(ND)}, storageUnit(S), T=0..n.

% No 2 shelves on the same cell
:- 2{storageUnitOn(S,object(cell,ND),T): storageUnit(S)}, cell(ND), T=0..n.

% No storageUnit on 2 locations (robo_vehicle, cell)
:- storageUnitOn(S,object(cell,_),T), storageUnitOn(S,object(robo_vehicle,_),T).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%      ACTIONS EFFECTS      %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Effect of moving a robo_vehicle
robo_vehicleAt(R,object(cell,NEW_ND),T+1):- robo_vehicleAt(R,object(cell,ND),T), cellAt(ND,pair(X,Y)), cellAt(NEW_ND, pair(X+DX,Y+DY)), robo_vehicleMove(R,move(DX,DY),T).

% Effect of picking up a storageUnit
storageUnitOn(S,object(robo_vehicle,RI),T+1):- pickupPoint(RI,S,T), storageUnitOn(S,object(cell,ND),T), robo_vehicleAt(RI,object(cell,ND),T).

%Effect of putting down a storageUnit
storageUnitOn(S,object(cell,ND),T+1):- putDownstorageUnit(RI,S,T), storageUnitOn(S,object(robo_vehicle,RI),T), robo_vehicleAt(RI,object(cell,ND),T).

%Effect of delivering a item
shipmentAt(OI,object(cell,ND),contains(PR,OU-DQ),T+1):- deliver(R,OI,with(SI,PR,DQ),T), shipmentAt(OI,object(cell,ND),contains(PR,OU),T).
itemOn(PR,object(storageUnit,SI),with(quantity,PQ-DQ),T+1):- deliver(R,OI,with(SI,PR,DQ),T), itemOn(PR,object(storageUnit,SI),with(quantity,PQ),T).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%      LAW OF INERTIA       %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

robo_vehicleAt(R,object(cell,ND),T+1):- robo_vehicleAt(R,object(cell,ND),T), not robo_vehicleMove(R,move(_,_),T), T<n.
storageUnitOn(S,object(cell,ND),T+1):-storageUnitOn(S,object(cell,ND),T), not pickupPoint(_,S,T), T<n.
storageUnitOn(S,object(robo_vehicle,RI),T+1):-storageUnitOn(S,object(robo_vehicle,RI),T), not putDownstorageUnit(RI,S,T), T<n.
shipmentAt(OI,object(cell,ND),contains(PR,OU),T+1):- shipmentAt(OI,object(cell,ND),contains(PR,OU),T), itemOn(PR,object(storageUnit,SI),with(quantity,PQ),T), not deliver(_,OI,with(SI,PR,_),T), T<n.
itemOn(PR,object(storageUnit,SI),with(quantity,PQ),T+1):- itemOn(PR,object(storageUnit,SI),with(quantity,PQ),T), not deliver(_,_,with(SI,PR,_),T), T<n.

% Goal state
:- not shipmentAt(OI,object(cell,_),contains(PR,0),n), shipmentAt(OI,object(cell,_),contains(PR,_),0).

numActions(N):-N=#sum{1,O,A,T:occurs(O,A,T)}.
timeTaken(N-1):-N=#count{T:occurs(O,A,T)}.
#minimize{1,O,A,T:occurs(O,A,T)}.
#minimize{T:occurs(O,A,T)}.

%#show cell/1.
%#show robo_vehicle/1.
%#show storageUnit/1.
%#show item/1.
%#show shipment/1.
%#show cellAt/2.
%#show robo_vehicleAt/3.
%#show storageUnitOn/3.
%#show itemOn/4.
%#show shipmentAt/4.

%#show robo_vehicleMove/3.

#show occurs/3.
#show numActions/1.
#show timeTaken/1.