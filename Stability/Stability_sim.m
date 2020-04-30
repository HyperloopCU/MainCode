%Hyperloop Stability sim (V1)
clc; clear all; close all;
%% Calculate degree of curvature
% calibrated using https://www.hsr.ca.gov/docs/programs/eir_memos/Proj_Guidelines_TM1_1_6R0.pdf
L=10000; %(m) Track length
E=0; %track bank elevation (in)
u=3; %amount of underbalence
V_track_max=200; %mph
ft2m=0.3048; %ft/m
mph2mps=0.44704;%mph/mps

D=(E+u)/(0.0007*V_track_max^2); %(deg) degree curviture 
Rmin=360*100/(2*pi*D)*ft2m; %m
track_angle=L/Rmin; %(rad) portion of circle swept out by track
%% calc x,v,a 
omega=V_track_max*mph2mps/Rmin;
tf=L/V_track_max;
t=linspace(0,tf,10000);
X_track(1,:)=Rmin*cos(omega*t);
X_track(2,:)=Rmin*sin(omega*t);

V_track(1,:)=Rmin*omega*(-sin(omega*t));
V_track(2,:)=Rmin*omega*(cos(omega*t));

A_track(1,:)=-omega^2*X_track(1,:);
A_track(2,:)=-omega^2*X_track(2,:);



%% pod
m=150; %kg
w=m*9.81;
Vpod=175; %mph
Cmh=0.5; %m
mu=0.2;
Lpod=6*ft2m; %m lenght of pod
wheelf2cg=(Lpod-0.5*ft2m)/2;
wheelr2cg=(Lpod-0.5*ft2m)/2;
width=4*ft2m; %(m) width of pod
Cmx=width/2;

%weight tranfer

for i=(1:1:length(A_track))
magA(i)=sqrt(A_track(1,i)^2+A_track(2,i)^2);
end
Win=w/2-w*Cmh*(magA/9.81)/width;
Wout=w/2+w*Cmh*(magA/9.81)/width;
cmXNew=(Win*width/(w));
%https://racingcardynamics.com/weight-transfer/
%https://asawicki.info/Mirror/Car%20Physics%20for%20Games/Car%20Physics%20for%20Games.html
Mo=(Win-Wout)*width/2+(Win+Wout)*mu*Cmh-(Cmx-cmXNew)*w;
%displays absolute value of moment (-=restoring)


COFmin=(Vpod*mph2mps)^2/(9.81*Rmin); %statics Ff=mv^2/r
ke=0.5*m*(V_track(1,:).^2+V_track(2,:).^2);
Vpodmax_flat=sqrt(9.81*(width/2)*Rmin/Cmh)/mph2mps; %mph max speed of pod without tipping on flat curve
%http://www.schoolphysics.co.uk/age16-19/Mechanics/Circular%20motion/text/Cars_cornering/index.html
%% plot cuve
% %positon
% figure
% plot(X_track(1,:),X_track(2,:))
% axis equal
% 
% %velocity
% figure
% plot(V_track(1,:),V_track(2,:))
% axis equal
% 
% %accel
% figure
% plot(A_track(1,:),A_track(2,:))
% axis equal
%% Propulsion
m=150 %kg
div=1000;
Wheel_rad=(0:(1000)/div:1000);
Gear_rat=(1:9/div:10);
a=2.4*9.81; %m/s

for(i=1:1:div+1)
    for (n=1:1:div+1)
torque(i,n)=m*a*(Wheel_rad(n)/1000)/Gear_rat(i);
t_268_max(i,n)=500;
    end
end
mesh(Wheel_rad,Gear_rat,torque)
hold on
surf(Wheel_rad,Gear_rat,t_268_max)
xlabel("wheel rad");
ylabel('gear ratio');
zlabel('minimum torque required');
