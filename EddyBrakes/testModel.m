%High level program flow
%% Initialize important variables 
clear all;
close all;

backiron=true;

%number of different speeds the simulation is run at
numSims=24;

%number of divisions of magnet array (not # of poles)
divisions=12;

%tests counter
tests=0;

%matrix to store data from simulationss
data=[];

%% With/Without Backiron
g=0.001;

eddycurrentbrakeoriginal
data = [data lastData];

backiron=false;
eddycurrentbrakeoriginal
data = [data lastData];
fitModel
legend('With Backiron','Without Backiron')  
%% Air Gap simulations

for g=linspace(0.001,0.005,5)
    eddycurrentbrakeoriginal
    data=[data lastData];
end
fitModel
legend('1 mm air gap','2 mm air gap','3 mm air gap','4 mm air gap','4 mm air gap')

