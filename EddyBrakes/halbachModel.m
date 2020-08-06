%% Global Variables 
numPoles = 8;
steps = numPoles*4;
ytop=pp*numPoles/steps;
Jmag = 4*Hc*sin(wm*B/2)/pp;

%% Original Model

openfemm;
newdocument(0);
mi_getmaterial('Air');


for kk = 1:steps
  xl = numPoles*(kk - 1)*pp/steps;
  xr = numPoles*kk*pp/steps;
  xm = (xl + xr)/2;
  mi_addmaterial(['J',num2str(kk)], 1, 1, 0, (Jmag/MA)*exp(I*B*xm), 0 , 0, 0, 1, 0, 0, 0, 1, 1);
  mi_drawrectangle(xl, 0, xr, ytop);
  mi_addblocklabel(xm, ytop/2);
  mi_selectlabel(xm, ytop/2);
  mi_setblockprop(['J',num2str(kk)], 1, 0, '<None>', 0, 0, 1);
  mi_clearselected;
end

mi_zoomnatural;

drawBoundRect(pp, numPoles, ytop, 3);
mi_saveas('original.fem');
getSolution();
%% Permanent Magnet Halbach Model

newdocument(0);
mi_getmaterial('Air');
mi_getmaterial('N42');

%Draw magnets
angle = 0;

for kk = 1:steps
  xl = numPoles*(kk - 1)*pp/steps;
  xr = numPoles*kk*pp/steps;
  xm = (xl + xr)/2;
  mi_drawrectangle(xl, 0, xr, ytop);
  mi_addblocklabel(xm, ytop/2);
  mi_selectlabel(xm, ytop/2);
  angle = angle - numPoles*360/steps;
  mi_setblockprop('N42', 1, 0, '<None>', angle, 1, 1);
  mi_clearselected;
end

mi_zoomnatural;

drawBoundRect(pp, numPoles, ytop, 3);
mi_saveas('pm_halbach.fem');
getSolution();
%% Current Sheet Halbach Model 
openfemm;
newdocument(0);
mi_getmaterial('Air');

ny = 2;
cntr=0;

Make functions for Br

for kk = 1:steps
  xl = numPoles*(kk - 1)*pp/steps;
  xr = numPoles*kk*pp/steps;
  xm = (xl + xr)/2;
  for jj = 1:ny
      yb = (jj-1)*ytop/ny;
      yt = jj*ytop/ny;
      ym = (yb + yt)/2;
      mi_addmaterial(['J',num2str(cntr)], 1, 1, 0, (Jmag/MA)*exp(I*(B*xm + pi*ym/(ytop*ny) - pi/2)),0 ,0 ,0 ,1 ,0 ,0 ,0 ,1 ,1);
      mi_drawrectangle(xl, yt, xr, yb);
      mi_addblocklabel(xm, ym);
      mi_selectlabel(xm, ym);
      mi_setblockprop(['J',num2str(cntr)], 1, 0, '<None>', 0, 1, 1);
      mi_clearselected;
      cntr = cntr + 1;
  end
end

mi_zoomnatural;

drawBoundRect(pp, numPoles, ytop, 3);
mi_saveas('cs_halbach.fem');
getSolution();
%% Function Definitions

function drawBoundCirc(pp, numPoles, ytop)
    farLeft = -2*pp*numPoles;
    farRight = 3*pp*numPoles;
    mi_addnode(farLeft,ytop/2);
    mi_addnode(farRight,ytop/2);
    mi_drawarc(farLeft,ytop/2, farRight,ytop/2, 180, 2.5);
    mi_drawarc(farRight,ytop/2, farLeft,ytop/2, 180, 2.5);
    mi_addblocklabel(farLeft/2, ytop/2);
    mi_selectlabel(farLeft/2, ytop/2);
    mi_setblockprop('Air', 1, 0, '<None>', 0, 0, 0);
    mi_clearselected; 

    mi_selectarcsegment(farLeft,ytop/2);
    mi_selectarcsegment(farRight,ytop/2);
    mi_setarcsegmentprop(0, 'A=0', 0, 0);
    mi_clearselected; 
end

function drawBoundRect(pp, numPoles, ytop, scale)
    %scale argument is how many pole pitches to add to each dimension
    mi_drawrectangle(-pp*scale, -pp*scale, pp*(numPoles+scale), ytop+(pp*scale));
    mi_addblocklabel(pp*(numPoles+scale)/2, (ytop+pp*scale)/2);
    mi_selectlabel(pp*(numPoles+scale)/2, (ytop+pp*scale)/2);
    mi_setblockprop('Air', 1, 0, '<None>', 0, 0, 0);
    mi_clearselected;
end

function getSolution()
    mi_probdef(0, 'meters', 'planar', 10^(-8), 1, 30);
    mi_analyze;
    mi_loadsolution;
end