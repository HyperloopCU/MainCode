%% Permanent Magnet Model

openfemm;

newdocument(0);
mi_getmaterial('Air');
mi_getmaterial('N42');

%Draw magnets
numPoles = 12;
angle = 0;
for k = 1:numPoles
  xl = 2*(k - 1)*pp;
  xr = 2*k*pp;
  xm = (xl + xr)/2;
  mi_drawrectangle(xl, tp + g + tm, xr, tp + g);
  mi_addblocklabel(xm, tp + g + tm/2);
  mi_selectlabel(xm, tp + g + tm/2);
  angle = angle - 90;
  mi_setblockprop('N42', 1, 0, '<None>', angle, 1, 1);
  mi_clearselected;
end

farLeft = -2*pp*numPoles;
farRight = 3*pp*numPoles;
mi_addnode(farLeft,(tp+g+tm+tb)/2);
mi_addnode(farRight,(tp+g+tm+tb)/2);
mi_drawarc(farLeft,(tp+g+tm+tb)/2, farRight,(tp+g+tm+tb)/2, 180, 2.5);
mi_drawarc(farRight,(tp+g+tm+tb)/2, farLeft,(tp+g+tm+tb)/2, 180, 2.5);
mi_addblocklabel(xm, ym);
mi_selectlabel(xm, ym);
mi_set