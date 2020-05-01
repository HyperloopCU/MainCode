%% Propulsion
clc;clear all;close all

%pod mass - a rough estimate
%later might have to account for differences in weight of motor
%in the future there should be a seperate fn in the same folder to
%calculate mass (or a vector storing the masses of all components in a
%seperate file
m=150; %kg

%required max acceleration
a=2.4*9.81; %m/s

%diameter in mm and peak torque in N*M
motor = struct('name','EMRAX-268','motorD',268,'peakT',500);

%  motorD = 268;
%  t_268_max = 500;

findSpecs(motor,m,a);

%function to determine allowed wheel sizes & gear ratios based on motor
%and acceleration/mass estimates
%result is a 2-row vector. Columns are pairs of gear ratio/wheel size
%(respectively) that yield max allowed torque
function allowed = findSpecs(motor,mass,acc)
    %motor specs
    name = motor.name;
    minDia = motor.motorD;
    peak = motor.peakT;
   
    div=1000;
    %wheel diameter can't be smaller than motor diameter but not bigger than
    %max diameter
    maxDia = 500;
    Wheel_rad=(minDia:1000/div:maxDia);
    Gear_rat=(1:9/div:10);

    [G W] = meshgrid(Gear_rat, Wheel_rad);
    T = mass*acc*(W/1000)./G;
    
    figure
    allowed = contour(G,W,T,[peak peak]);
    allowed(:,1) = [];
    hold on
    x = [allowed(1,:)];
    y = [allowed(2,:)];
    area(x,y)
    title(sprintf("Specs for %s, Max Torque = %d",name,peak))
    ylabel("Allowed Wheel Radii (mm)");
    xlabel('Allowed Gear Ratios');
    xlim([x(1) x(length(x))])
    ylim([y(1) maxDia])
end