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

r = 0.1;
sig = 0.01;
K = 100;
T = 0.25;

S=[97,98,99]

tic
[U]=BSeuCallUII_FDA(S,K,T,r,sig)
toc

Uref=[0.033913177006141 0.512978189232598 1.469203342553328];

Relerr=(U-Uref)./Uref

tic
[Delta]=BSeuCallDeltaII_FDA(S,K,T,r,sig)
toc

Deltaref=[0.138001659888508 0.831964783803436 0.998616182178259];

Relerr=(Delta-Deltaref)./Deltaref
 
tic
[Gamma]=BSeuCallGammaII_FDA(S,K,T,r,sig)
toc

Gammaref=[0.454451267361807 0.512594211115861 0.009158543351289];


Relerr=(Gamma-Gammaref)./Gammaref

tic
[Vega]=BSeuCallVegaII_FDA(S,K,T,r,sig)
toc

Vegaref=[10.689829936518105 12.307387008891816 0.224407208464969];

Relerr=(Vega-Vegaref)./Vegaref