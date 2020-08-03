%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                             %%%
%%% Analysis of an Eddy Current Brake with FEMM %%%
%%%                                             %%%
%%% David Meeker                                %%%
%%% dmeeker@ieee.org                            %%%
%%%                                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Preliminary Definitions 

mm = 0.001;    %conversion of meter to mm
Inch = 0.0254;  %conversion of inch to meter
MS = 10^6;     %megasiemens 
MA = 10^6;
m = 1;  %meter is the base unit of length
Pi = pi;  %pi :)
I = 1j;
muo = 4.*Pi*10^(-7);  %permeability constant in henries
Hz = 2*Pi;   %some reason freqeuncy is multiples of 2pi
 
%% Problem Parameters
 %here is where we input the data
% A conductive plate moves within a double-sided array of steel-backed
% permanent magnets. This notebook computes the force of the brake vs.
% plate velocity.
% Refer to http://www.femm.info/wiki/EddyCurrentBrake for a figure

BHmax = 40;         % Energy product of the magnet  in MGOe ???
pp = 25*mm;         % Pole pitch of the magnets  ???
wm = 20*mm;         % Magnet width 
tm = 5*mm;          % Magnet thickness 
tb  = 5*mm;         % Back iron thickness 
tp = 2.5*mm;        % Conductive plate half-thickness  (1/2 the thickness of aluminum)
g = 1*mm;           % Air gap length between magnet and plate 
sigma = 30;         % Plate conductivity in MS/m (megasiemens per meter, for 6061 t6 al its 24.59 MS/m)
h = 100*mm;         % Depth of magnet array 
epsilon = 20*mm;    % Plate overhang on either side of the magnets 

%% Derived Quantities

% Mechanical frequency of the magnet array

B = Pi/pp;

% A big problem with using a 2D solver to analyze this sort of machine is
% that 3D transverse edge effects can significantly influence the 
% performance of the brake.  Fringing near the transverse edge means that 
% some of the PM flux doesn't link the plate, lessening the maximum force 
% produced by the brake.  The resistance of the edge of the plate, where 
% the currents 'turn around', makes the plate look more resistive and 
% pushes out the speed at which the peak force occurs.  Here, we will put
% in some kludgy corrections to account for these effects.  
%
% The total stack-up of unit permeability materials between plate 
% centerline and iron is gtot:

gtot = (tp + g + tm);

% Use this distance to get an appoximate derating to account for fringing
% at the transverse edges. This is an approximate kludge that is probably
% no good for an array that isn't wide compared to gtot. Say that the width
% of a fringing region is hf:

hf = gtot/2;

% Shorten the active region by a bit, snipping off the fringing region of
% width hf on each side of the stator:

heff = h - 2*hf;

% Add the width of the fringing region to the width of the 'end turn' 
% region of the plate

epsilonEff = epsilon + hf;

% Correct the conductivity to account for the transverse edges of the plate

sigmaEff = sigma/(1 + 2/(B^2 * heff * epsilonEff));

% Remanence of the PMs in Tesla (see http://www.femm.info/Archives/misc/BarMagnet.pdf)

Br = sqrt(BHmax)/5.;

% Coercivity of the PMs in A/m

Hc = Br/muo;

% You can replace a permanent magnet by an equivalent current sheet that
% produces the same external fields.
%
% We want to replace the current sheet by a sinusoidally distributed band of
% current density.  Most of the force in an eddy current brake is due to the
% fundamental, and if we just consider the fundamental, we can make a 
% simulation in FEMM that includes 'motion'.
% 
% Find amplitude of the fundamental in a Fourier Series representation
% (see http://en.wikipedia.org/wiki/Fourier_series)  of the equivalent current
% density of the PMs in units of A/m^2.
%
% There is a + current sheet of strenght Hc located at (pp-wm)/2 and 
% a - current sheet located at  (pp+wm)/2.  The result, Jmag, is in units of A/m^2

Jmag = 4*Hc*sin(wm*B/2)/pp;

% The analysis approach is to analyze the brake from the point of view of an
% observer attached to the plate.  From the point of view of this observer,
% the magnet's sinusoidally distributed current bands look like simple AC 
% currents.  We can analyze the problem in FEMM by defining a distribution of 
% currents in the region where the permanent magnets live that looks like 
% Jmag*exp(I*B*x) where x indexes the position down the array.  The apparent
% frequency is omega = B*v, where v is the plate's velocity.

%% Draw Domain

% This section uses the MathFEMM interface betwen Mathematica and FEMM to 
% programmatically draw the brake geometry.

openfemm;
newdocument(0);

% Define Materials

mi_getmaterial('Air');
mi_addmaterial('Steel', 5000, 5000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1);
mi_addmaterial('Plate', 1, 1, 0, 0, sigmaEff , 0, 0, 1, 0, 0, 0, 1, 1);

% Draw Plate

mi_drawrectangle(0, 0, 2*pp, tp);
mi_addblocklabel(pp, tp/2);
mi_selectlabel(pp, tp/2);
mi_setblockprop('Plate', 1, 0, '<None>', 0, 1, 1);
mi_clearselected;

% Draw Air Gap

mi_drawrectangle(0, tp, 2*pp, tp + g);
mi_addblocklabel(pp, tp + g/2);
mi_selectlabel(pp, tp + g/2);
mi_setblockprop('Air', 1, 0, '<None>', 0, 0, 1);
mi_clearselected;

% Draw Magnets

nx = 12;
ny = 4;
cntr = 0;
for k = 1:nx
  xl = 2*(k - 1)*pp/nx;
  xr = 2*k*pp/nx;
  xm = (xl + xr)/2;
  for l = 1:ny
      yb = tp+g+(l-1)*tm/ny;
      yt = tp+g+l*tm/ny;
      ym = (yb + yt)/2;
      mi_addmaterial(['J',num2str(cntr)], 1, 1, 0, (Jmag/MA)*exp(I*(B*xm + pi*ym/(tm*ny) - pi/2)),0 ,0 ,0 ,1 ,0 ,0 ,0 ,1 ,1);
      mi_drawrectangle(xl, yt, xr, yb);
      mi_addblocklabel(xm, ym);
      mi_selectlabel(xm, ym);
      mi_setblockprop(['J',num2str(cntr)], 1, 0, '<None>', 0, 0, 1);
      mi_clearselected;
      cntr = cntr + 1;
  end
end

% Draw Backiron

mi_drawrectangle(0, tp + g + tm, 2*pp, tp + g + tm + tb);
mi_addblocklabel(pp, tp + g + tm + tb/2);
mi_selectlabel(pp, tp + g + tm + tb/2);
mi_setblockprop('Steel', 1, 0, '<None>', 0, 0, 1);
mi_clearselected;

% Add Boundary Conditions

mi_addboundprop('A=0', 0, 0, 0, 0, 0, 0, 0, 0, 0);
% mi_addboundprop('pbc1', 0, 0, 0, 0, 0, 0, 0, 0, 4);
% mi_addboundprop('pbc2', 0, 0, 0, 0, 0, 0, 0, 0, 4);
% mi_addboundprop('pbc3', 0, 0, 0, 0, 0, 0, 0, 0, 4);
% mi_addboundprop('pbc4', 0, 0, 0, 0, 0, 0, 0, 0, 4);

mi_selectsegment(pp, tp + g + tm + tb);
mi_setsegmentprop('A=0', 0, 1, 0, 0);
mi_clearselected;

% mi_selectsegment(0, tp + g + tm + tb/2);
% mi_selectsegment(2*pp, tp + g + tm + tb/2);
% mi_setsegmentprop('pbc1', 0, 1, 0, 0);
% mi_clearselected;
% 
% mi_selectsegment(0, tp + g + tm/2);
% mi_selectsegment(2*pp, tp + g + tm/2);
% mi_setsegmentprop('pbc2', 0, 1, 0, 0);
% mi_clearselected;
% 
% mi_selectsegment(0, tp + g/2);
% mi_selectsegment(2*pp, tp + g/2);
% mi_setsegmentprop('pbc3', 0, 1, 0, 0);
% mi_clearselected;
% 
% mi_selectsegment(0, tp/2);
% mi_selectsegment(2*pp, tp/2);
% mi_setsegmentprop('pbc4', 0, 1, 0, 0);
% mi_clearselected;

mi_zoomnatural;

%% Calculate Force vs Speed

% Expected speed at which maximum braking force occurs in m/s, 
% based on 1D linear induction motor theory:

wc = (B^2 * gtot)/((sigmaEff*MA/m)*muo*tp);
vopt1d = wc/B;

% We can use the quick analytical estimate of vopt to select 
% the range over which we evaluate the performance of the brake.

mi_saveas('temp.fem');
mi_probdef(B*v/Hz, 'meters', 'planar', 10^(-8), heff, 30);
mi_analyze;
mi_loadsolution;

n=floor(2*vopt1d);
data=zeros(n+1,1);
x=0:n;
for v = 0:n
  mi_probdef(B*v/Hz, 'meters', 'planar', 10^(-8), heff, 30);
  mi_analyze;
  mi_loadsolution;
  mo_groupselectblock(1);
  data(v+1) = mo_blockintegral(11)
end

%closefemm; %uncomment to close window after script runs

plot(x,data);
xlabel('Shuttle Velocity, m/s');
ylabel('Braking Force, N');
title('Braking Force vs Velocity');
grid on;

