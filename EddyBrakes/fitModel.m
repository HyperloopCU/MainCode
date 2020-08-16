%% Fit Simulation points
% Model used is Fd = p1*v/(v^2 + q2) where v is the velocity of magnet
% array
% Must have column vectors x, data loaded into workspace
% Must have cftool add-on installed

%Set coefficients of unnecessary terms to 0, and make sure q2 is positive
options = fitoptions('rat12','Lower',[-Inf 0 0 0],'Upper',[Inf 0 0 Inf]);
f = fit(x, data, 'rat12', options);
plot(f, x, data);