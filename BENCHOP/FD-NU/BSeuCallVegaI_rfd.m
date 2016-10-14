 %Copyright (C) 2015 Jari Toivanen

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
    %along with BENCHOP. If not, see <http://www.gnu.org/licenses/>.

function vp = BSeuCallVegaI_rfd(sp,K,T,r,sigma)
n = 0.875*640; m = 0.875*64;
dsigma = 1e-4;
upm = BSeuCallUI_rfd(sp,K,T,r,sigma-0.5*dsigma,n,m);
upp = BSeuCallUI_rfd(sp,K,T,r,sigma+0.5*dsigma,n,m);
vp = (upp - upm)/dsigma;
