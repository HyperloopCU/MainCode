%% Global Variables 
numPoles = 5;
ytop=pp;
Jmag = 4*Hc*sin(wm*B/2)/pp;

%% Original Model

openfemm;
newdocument(0);
mi_getmaterial('Air');

steps=numPoles*4

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
setBoundConds(pp, numPoles, ytop);


mi_saveas('original.fem');
getSolution();
%% Permanent Magnet Halbach Model

newdocument(0);
mi_getmaterial('Air');
mi_getmaterial('N42');

%Draw magnets
angle = 0;

for kk = 1:numPoles
  xl = (kk - 1)*pp;
  xr = kk*pp;
  xm = (xl + xr)/2;
  mi_drawrectangle(xl, 0, xr, ytop);
  mi_addblocklabel(xm, ytop/2);
  mi_selectlabel(xm, ytop/2);
  angle = angle - 90;
  mi_setblockprop('N42', 1, 0, '<None>', angle, 1, 1);
  mi_clearselected;
end

mi_zoomnatural;

drawBoundRect(pp, numPoles, ytop, 3);
% setBoundConds(pp, numPoles, ytop);

mi_saveas('pm_halbach.fem');
getSolution();

%% Backiron alternating array model

newdocument(0);
mi_getmaterial('Air');
mi_addmaterial('Steel', 5000, 5000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1);

steps=numPoles*4

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

%Draw backiron
mi_drawrectangle(0, ytop, numPoles*pp, ytop*2);
mi_addblocklabel(numPoles*pp/2, ytop*3/2);
mi_selectlabel(numPoles*pp/2, ytop*3/2); 
mi_setblockprop('Steel', 1, 0, '<None>', 0, 0, 1);
mi_clearselected;

mi_zoomnatural;

drawBoundRect(pp, numPoles, ytop, 3);

mi_saveas('backiron.fem');
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
setBoundConds(pp, numPoles, ytop);

mi_saveas('cs_halbach.fem');
getSolution();
%% Function Definitions

mi_addboundprop('Normal', 0, 0, 0, 0, 0, 0, 0, 0, 2);
mi_addboundprop('A=0', 0, 0, 0, 0, 0, 0, 0, 0, 0);

function setBoundConds(pp, numPoles, ytop)
    mi_selectsegment(0, 0);
    mi_selectsegment(0, ytop);
    mi_selectsegment(numPoles*pp, 0);
    mi_selectsegment(numPoles*pp, ytop);
    mi_setsegmentprop('Normal', 0, 1, 0, 0);  
    mi_clearselected;
end


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
    mi_addblocklabel(pp*(numPoles+scale-1), ytop+pp*(scale-1));
    mi_selectlabel(pp*(numPoles+scale-1), ytop+pp*(scale-1));
    mi_setblockprop('Air', 1, 0, '<None>', 0, 0, 0);
    mi_clearselected;
end

function getSolution()
    mi_probdef(0, 'meters', 'planar', 10^(-8), 1, 30);
    mi_analyze;
    mi_loadsolution;
end

