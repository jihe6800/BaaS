 %Copyright (C) 2015 Jeremy Levesley

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

function [x1, varargout]=coarserefine1(g,x1,err,cg,maxdis,e,f)

I1 = true;
N=length(x1);
while any(I1)
 
dx=diff(x1);
c=cg*min([Inf;1./dx],[1./dx;Inf]);

Phi=zeros(N,N);
for j=1:N
   
    Phi(:,j)=mq(x1,x1(j),c(j));
end


lambda=Phi\feval(g,x1);

mq_aprox=Phi*lambda;
spline_aprox = residuals(x1,mq_aprox);

mq_aprox(1)=[];
mq_aprox(end)=[];


%===========Max residual===========

indx1=find(x1>e,1,'first');
indx2=find(x1<f,1,'last');

resid= abs(mq_aprox-spline_aprox);

% Max_resid=max(resid);


%===========Refine=================

I1=find(resid(indx1:indx2)>err(1));
if isempty(I1)==0


 ref=I1+1+indx1;
 if isempty(ref)==0
     
     midpts=mid_points_amend1(x1,ref);
       
     x11=sortrows([x1;midpts]);

     QQ=length(x11)-length(x1);

%      fprintf('Adding %i centers.',QQ);


 end
 
else
    break
end

%===========Coarsening==================


 
I= find(resid < err(2));

x1=x1(I+1);
%----------------

% ---Find suitable coarsening points
  z=zeros(length(x1),1);
  for jj=1:length(z)
      z(jj)=find(x1(jj)==x11);
      if z(jj)<=3 || z(jj)>=length(x11)-2
         z(jj)=0;
       elseif (x11(z(jj)+1)-x11(z(jj)-1))>maxdis
         z(jj)=0;
      end
      
  end
  I2= z==0;
  z(I2)=[];
  L=zeros(4,1);
  for jj=1:length(z)
      L(1,1)=x11(z(jj)-2);
      L(2,1)=x11(z(jj)-1);
      L(3,1)=x11(z(jj)+1);
      L(4,1)=x11(z(jj)+2);
      DX=diff(L);
      if 2*DX(2)>=DX(1) || DX(2)<=2*DX(1)
          if 2*DX(2)>=DX(3) || DX(2)<=2*DX(3)
              z(jj)=z(jj);
          end
      else
          z(jj)=0;
      end

  end
  I2= z==0;
  z(I2)=[];

%------------------------------------------------

  N1=length(z);
% ---Method 2 reorder by indexs
  q=round(0.2*QQ);
  if N1<q
      q=N1;
  end
  if N1==0
      q=0;
  else
   del=round(0.5*q); %deleting first half points
   rem=q-del; %second half points
   x11(z(end-rem:end))=[];
   x11(z(1:del))=[];    

  x1=x11;    
  end

%------------------------------------------------ 
%   fprintf('Removing %i centers.',q);

N=length(x1);


end




if nargout>1
       
       varargout(1) ={c};
    if nargout>2
        
         
        varargout(2)={feval(g,x1)};
    end
end