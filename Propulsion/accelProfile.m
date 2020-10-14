%Set parameters (CURRENTLY NOT USED)

t = linspace(0, 10, 1000); %Time
maxA = 1; %Maximum allowed acceleration (human limit)
maxB = 1; %Maximum 
goalAb = 1; %Goal average braking acceleration
goalV = 1; %Goal cruising speed
% maxV = 1; %max cruising speed, limited by Kantrowitz limit
mass = 1; %Mass of pod
launchDist = 1; %Length of launch stage
brakeDist = 1; %length of brake stage

%% Make Sample Profiles

acc_profile(5, 5, 20, 100);
%% fn defs

function [t, acc] = acc_profile(max_a, rampup, rampdown, topspeed)
    %a in m/s^2
    %rampup, rampdown in s
    %topspeed in m/s. 200mph = 90 m/s
    close all;
    
    %Calculate the time to hold the maximum acceleration
    holdtime = topspeed/max_a - 0.5*(rampup + rampdown)
    duration = holdtime + rampup + rampdown;
    
    %Make the acc. vector and plot
    t = linspace(0, 1.5*duration, 1000);
    acc = zeros(1, 1000);
    rampup_ind = t < rampup;
    acc(rampup_ind) = max_a*t(rampup_ind)/rampup;
    acc(rampup <= t & t < (rampup + holdtime)) = max_a;
    rampdown_ind = (rampup + holdtime) <= t & t < duration;
    acc(rampdown_ind) = max_a-max_a*(t(rampdown_ind)-holdtime-rampup)/rampdown;
    
    %Calculate speed vector with numeric integration
    speed = cumsum(acc)*duration/1000; 
    
    %Calculate power in kW (mass of 100 kg assumed)
    mass = 100;
    power = mass*acc.*speed/1000;

    figure;
    subplot(1,3,1);
    plot(t, acc);
    ylim([0, 1.5*max_a]);
    xlabel('Time (s)');
    ylabel('Acc. (m/s^2)');
    title('Acceleration');
    
    subplot(1,3,2);
    plot(t, speed);
    xlabel('Time (s)');
    ylabel('Speed (m/s)');
    title('Speed');
    
    subplot(1, 3, 3);
    plot(t, power);
    xlabel('Time (s)');
    ylabel('Power (kW)');
    title('Power');
    
    sgtitle(['Max. Acc = ', int2str(max_a), ' m/s^2, Top Speed = ', int2str(topspeed), ' m/s, Peak Power = ', int2str(max(power)), ' kW.'])
end