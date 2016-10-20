 %Copyright (C) 2015 Lina von Sydow

    %This file is part of BENCHOP.
    %BENCHOP is free software: you can redistribute it and/or modify
    %it under the terms of the GNU General Public License as published by
    %the Free Software Foundation, either version 3 of the License, or
    %(at your option) any later version.

    %BENCHOP is distributed in the hope that it will be useful,
    %but WITHOUT ANY WARRANTY; without even the implied warranty of
    %MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    %GNU General Public License for more details.

    %You should have received a copy of the GNU General Public License
    %along with BENCHOP. If not, see <http://www.gnu.org/licenses/>.clear all
close all

r = 0.03;
sig = 0.15;
K = 100;
T = 1;

S=[90,100,110]

tic
[U]=BSeuCallUI_FDA(S,K,T,r,sig)
toc

Uref=[2.758443856146076 7.485087593912603 14.702019669720769]; 

Relerr=(U-Uref)./Uref

tic
[Delta]=BSeuCallDeltaI_FDA(S,K,T,r,sig)
toc

Deltaref=[0.334542751969886 0.608341880846395 0.818694517094515];

Relerr=(Delta-Deltaref)./Deltaref

tic
[Gamma]=BSeuCallGammaI_FDA(S,K,T,r,sig)
toc

Gammaref=[0.026971755100040 0.025609261020380 0.015975258690289];

Relerr=(Gamma-Gammaref)./Gammaref

tic
[Vega]=BSeuCallVegaI_FDA(S,K,T,r,sig)
toc

Vegaref=[32.770682446548165 38.413891530570481 28.995094522875153];

Relerr=(Vega-Vegaref)./Vegaref