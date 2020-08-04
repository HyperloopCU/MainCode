%% Permanent Magnet Model

openfemm;

newdocument(0);
mi_getmaterial('Air');
mi_getmaterial('N42');

%Draw magnets
numPoles = 8;
angle = 0;
steps = 10;
for k = 1:steps
  xl = numPoles*(k - 1)*pp/steps;
  xr = numPoles*k*pp/steps;
  xm = (xl + xr)/2;
  mi_drawrectangle(xl, 0, xr, pp*numPoles/steps);
  mi_addblocklabel(xm, pp*numPoles/(2*steps));
  mi_selectlabel(xm, pp*numPoles/(2*steps));
  angle = angle - numPoles*360/steps;
  mi_setblockprop('N42', 1, 0, '<None>', angle, 1, 1);
  mi_clearselected;
end

mi_zoomnatural;

farLeft = -2*pp*numPoles;
farRight = 4*pp*numPoles;
middle = pp*numPoles/(2*steps);
mi_addnode(farLeft,middle);
mi_addnode(farRight,middle);
mi_drawarc(farLeft,middle, farRight,middle, 180, 2.5);
mi_drawarc(farRight,middle, farLeft,middle, 180, 2.5);
mi_addblocklabel(xm, ym);
mi_selectlabel(xm, ym);
mi_setblockprop('Air', 1, 0, '<None>', 0, 0, 0);
mi_clearselected; 

mi_selectarcsegment(farLeft,middle);
mi_selectarcsegment(farRight,middle);
mi_setarcsegmentprop(0, 'A=0', 0, 0);
mi_clearselected; 

mi_saveas('temp.fem');

mi_probdef(0, 'meters', 'planar', 10^(-8), heff, 30);
mi_analyze;
mi_loadsolution;

%%
openfemm;
newdocument(0);

Jmag = 4*Hc*sin(wm*B/2)/pp;

ny = 4
cntr=0;
for k = 1:steps
  xl = numPoles*(k - 1)*pp/steps;
  xr = numPoles*k*pp/steps;
  xm = (xl + xr)/2;
  for l = 1:ny
      yb = tp+g+(l-1)*tm/ny;
      yt = tp+g+l*tm/ny;
      ym = (yb + yt)/2;
      mi_addmaterial(['J',num2str(cntr)], 1, 1, 0, (Jmag/MA)*exp(I*(B*xm + pi*ym/(tm*ny) - pi/2)),0 ,0 ,0 ,1 ,0 ,0 ,0 ,1 ,1);
      mi_drawrectangle(xl, yt, xr, yb);
      mi_addblocklabel(xm, ym);
      mi_selectlabel(xm, ym);
      mi_setblockprop(['J',num2str(cntr)], 1, 0, '<None>', 0, 1, 1);
      mi_clearselected;
      cntr = cntr + 1;
  end
end

mi_zoomnatural;

farLeft = -2*pp*numPoles;
farRight = 4*pp*numPoles;
middle = pp*numPoles/(2*steps);
mi_addnode(farLeft,middle);
mi_addnode(farRight,middle);
mi_drawarc(farLeft,middle, farRight,middle, 180, 2.5);
mi_drawarc(farRight,middle, farLeft,middle, 180, 2.5);
mi_addblocklabel(xm, ym);
mi_selectlabel(xm, ym);
mi_setblockprop('Air', 1, 0, '<None>', 0, 0, 0);
mi_clearselected;

mi_selectarcsegment(farLeft,middle);
mi_selectarcsegment(farRight,middle);
mi_setarcsegmentprop(0, 'A=0', 0, 0);
mi_clearselected; 

mi_saveas('temp2.fem');

mi_probdef(0, 'meters', 'planar', 10^(-8), heff, 30);
mi_analyze;
mi_loadsolution;
