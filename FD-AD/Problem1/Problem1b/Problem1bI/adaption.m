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

function [X_adapted,M]=adaption(A,X_vals,h_fine,saved_sols,no_of_sols,r,sigma,space_tol,space_fac,max_length)

vector_lengths=length(X_vals);

No_dims=1;

start_index=[1 cumsum(vector_lengths(1:end-1))+1]; % Find startend of vectors
end_index=cumsum(vector_lengths);

deltah=A*saved_sols; 

X_adapted=[];
vec_length_adapted=[];

for ii= 1:No_dims % Loop over the dimensions
  X_new=[];% Find the new X-vector with double gridsize in dim ii
  for jj=1:No_dims
    if jj==ii
      X_new=[X_new X_vals(start_index(jj):2:end_index(jj))];
    else
      X_new=[X_new X_vals(start_index(jj):end_index(jj))];
    end
  end
  
  vector_lengths_new=vector_lengths;
  vector_lengths_new(ii)=(vector_lengths(ii)+1)/2;  
  [A,h2tmp]=generatematrix(X_new,sigma,r); % generate new matrix

  vcltmp=vector_lengths-2;					     
  
  for kk=1:No_dims % find the elements in the sol. vector that should remain
    if kk==ii
      rind{kk}=2:2:vcltmp(kk)-1;		
    else
      rind{kk}=1:vcltmp(kk);
    end
  end
  
clear Tau 
  
 for jj=1:no_of_sols 
	if No_dims==1
	  Rsol_matrix=reshape(saved_sols(:,jj),[vcltmp(1) 1]);
	else
	  Rsol_matrix=reshape(saved_sols(:,jj),vcltmp);
    end
		    
    restrVEC=reshape(Rsol_matrix(rind{:}),[prod(vector_lengths_new-2) 1]);
    delta2h=A*restrVEC;
    
    if No_dims==1
      deltah_matrix=reshape(deltah(:,jj),[ vcltmp, 1]);
    else
      deltah_matrix=reshape(deltah(:,jj),vcltmp);
    end
    
   deltahRESTR=reshape(deltah_matrix(rind{:}),[prod(vector_lengths_new-2) 1]);
    
   Tau(:,jj)  = (1/3).*(delta2h-deltahRESTR); %Ändrad 031009->(:,jj)

   if No_dims==1
     TauM2 = reshape(Tau(:,jj),[ vector_lengths_new-2,1]);
   else
     TauM2 = reshape(Tau(:,jj), vector_lengths_new-2);
   end
    
   for kk=1:No_dims 
      if kk==ii
       	rind2{kk}=2:vector_lengths_new(kk)-3;		
      else
	    rind2{kk}=1:vector_lengths_new(kk)-2;
      end    
   end
  
   TauM2=TauM2(rind2{:});% 
         
   for ll=1:No_dims    
	  TauM2=max(abs(TauM2),[],ll);     
   end      
   maxTauBefore(ii,jj)=TauM2;
   
  end 
  
  Tau=max(abs(Tau),[],2);
 
  if No_dims==1
    TauM = reshape(Tau,[ vector_lengths_new-2,1]);
  else
    TauM = reshape(Tau, vector_lengths_new-2);
  end
  
  Tau_tmp=TauM;
  
  for ll=1:No_dims
    if ll~=ii
      Tau_tmp=max(abs(Tau_tmp),[],ll);  
    end
  end
 
  h_fine_tmp=h_fine(ii,1:vector_lengths(ii)-1);
  
  Tau_tmp= Tau_tmp(:);
  
  Tau_tmp(1)=Tau_tmp(2); % extrapolate to the boundaries
  Tau_tmp(end)=Tau_tmp(end-1);
  Tau_tmpLEFT=Tau_tmp(1);
  Tau_tmpRIGHT=Tau_tmp(end);

  Tau_tmp=[Tau_tmpLEFT; Tau_tmp ;Tau_tmpRIGHT ]; % add endpoints Tau

  %Compute new grid
  
  [h_func,Tau_h_smooth]=create_cont_h(abs(Tau_tmp),h_fine_tmp,space_tol,space_fac,max_length);
  
  [S_new,error]=adapt_grid(X_vals(start_index(ii):2:end_index(ii)),h_func);
  
  %ADD_MORE_POINTS 
  
  [S_new]=add_more_points(S_new);
  
  X_adapted=[X_adapted S_new];
  
  M=length(X_adapted);
  
end
