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

function [S_new]=add_more_points(S_new);

Nnew=length(S_new);

if mod(Nnew,2)==0
   
   if mod(Nnew,4)==2
      addnew=3;
   end
   if mod(Nnew,4)==0
    addnew=1;
 end
elseif mod(Nnew,2)==1
   if mod(Nnew,4)==1 
      addnew=0;
   end
   if mod(Nnew,4)==3
      addnew=2;
   end
end

if addnew~=0
   if addnew==1
   S_new=[S_new(1) 0.5*(S_new(1)+S_new(2)) S_new(2:end)] ;  
elseif addnew==2   
   S_new=[S_new(1) 0.5*(S_new(1)+S_new(2)) S_new(2) 0.5*(S_new(2)+S_new(3)) S_new(3:end)];
elseif addnew==3
   S_new=[S_new(1) 0.5*(S_new(1)+S_new(2)) S_new(2) 0.5*(S_new(2)+S_new(3)) S_new(3) 0.5*(S_new(3)+S_new(4)) S_new(4:end)];
elseif addnew>=4
   disp('ERROR - adding too many points!')
   end
end