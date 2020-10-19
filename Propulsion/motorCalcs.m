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

%%
clc;
wheeldia = 0.3; %About a 16 in wheel dia
gear = 1;
max_a = 5;

torque = findtorque(200,max_a,wheeldia,gear)
rpm = findrpm(100,wheeldia,gear)
%% Fn defs

function torque = findtorque(mass,max_a,wheeld,gear)
    %Fn to calculate max torque requirements on motor based on pod mass, maximum
    %acceleration, wheel dia and gear ratio (SI units
    %gear ratio is defined as (rpm load)/(rpm motor)
    %returns value in N*m (Newton-meters)
    %torque contribution of moment of inertia of wheels is assumed negligible
    torque = (wheeld/2)*mass*max_a*gear;
end

function rpm = findrpm(max_s,wheeld,gear)
    %Fn to calculate motor rpm
    %all arguments in SI units
    %gear ratio is again (rpm load)/(rpm motor)
    
    rpm = 60*max_s/(pi*wheeld*gear);
end

function allowed = findSpecs(motor,mass,acc)
    %function to determine allowed wheel sizes & gear ratios based on motor
    %and acceleration/mass estimates
    %result is a 2-row vector. Columns are pairs of gear ratio/wheel size
    %(respectively) that yield max allowed torque
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
