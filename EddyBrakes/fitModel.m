%% Fit Simulation points
% Model used is Fd = p1*v/(v^2 + q2) where v is the velocity of magnet
% array and p1, q2 are fit parameters

% Must have column vectors x, lastData loaded into workspace
% Must have cftool add-on installed

figure;
% fits = fittype.empty([0 tests])
hold on;
colors=['r','b','g','m','c'];
% colors=[0, 0.4470, 0.7410 ; 0.8500, 0.3250, 0.0980]
for ii = 1:tests
    curData = data(:,ii);
    %Set coefficients of unnecessary terms to 0, and make sure q2 is positive
    options = fitoptions('rat12','Lower',[-Inf 0 0 0],'Upper',[Inf 0 0 Inf]);
    f = fit(x, curData, 'rat12', options);
    %Plot the data with the model
    plot(x,curData,'*','Color',colors(ii),'HandleVisibility','off')
    plot(f,colors(ii))
end
xlabel('Shuttle Velocity, m/s');
ylabel('Braking Force, N');
title('Braking Force vs Velocity');
grid on;