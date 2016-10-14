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

function [s_new,error_code]=adapt_grid(s,h_cont)

error_code =0;

ind=1;
next_i=3;
s_new(1)=s(1);
s_new(2)=s_new(1)+h_cont(ind);
s_next=s_new(2);  
while s_next < max(s) & ind<=length(s)
   % findwhich h to use!
   if s_next>=s(ind) & s_next<=s(ind+1) 
     
      h_val=((h_cont(ind+1)-h_cont(ind))/(s(ind+1)-s(ind)))*...
         (s_next-s(ind))+h_cont(ind);

      %ind=ind+1;
      s_new(next_i)=s_next+h_val;
      next_i=next_i+1;
      s_next=s_next+h_val;
            
  else
      ind=ind+1;
  end
  if length(s_new)>20000   % SAFEGUARD FOR LARGE RUNS !!!
     disp('New S-grid has more than 20000 points')
     error_code=1;
    break
  end

end
s_new(next_i-1)=s(end);


