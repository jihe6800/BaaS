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
    %along with BENCHOP. If not, see <http://www.gnu.org/licenses/>.% This code was originally produced by Jonas Persson and has been modified
% by Lina von Sydow.

function [h_func, Tau_h_smooth] = create_cont_h(Tau_h,hf,tol,factor,max_length)

Tau_h_tmp=zeros(length(Tau_h)-2,1);

for kk=1:10
Tau_h_tmp=(Tau_h(1:end-2)+2.*Tau_h(2:end-1)+Tau_h(3:end))./4;
Tau_h =[Tau_h(1); Tau_h_tmp;  Tau_h(end)];
end


Tau_h_smooth=Tau_h;

  h_func=zeros(length(Tau_h),1);
  h_tmp =zeros(length(Tau_h),1); 
  
  h_tmp(2:end-1)=0.5.*(hf(2:2:end-2)+hf(3:2:end-1)); 
  h_tmp(1)=h_tmp(2); 
  h_tmp(end)=h_tmp(end-1);
  
  for l=2:length(Tau_h)-1   
    h_func(l)=min(h_tmp(l).*sqrt(tol./(factor*tol+...
    (0.25.*( Tau_h(l-1)+2*Tau_h(l)+Tau_h(l+1)) ))),max_length);   
  end
  
  h_func(1) = h_func(2);
  h_func(end) = h_func(end-1);
  h_func=h_func*1.0;
 
    
    
