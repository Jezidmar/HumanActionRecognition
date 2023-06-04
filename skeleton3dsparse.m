%sparse 3d skeleton

%trebaju mi ulazne dimenzije.
%pp da imas 20x20x20 tenzor
%

function [kocka]=skeleton3dsparse(X,min_x,max_x,min_y,max_y,min_z,max_z,dim1,dim2,dim3)


%dim1 dim2 dim3 govore o dimenzijama 
%konstruiramo sve skupa dim1*dim2*dim3 kockica

a1=abs(max_x-min_x)/dim1 ;
a2=abs(max_y-min_y)/dim2 ;
a3=abs(max_z-min_z)/dim3 ;

%hoce li biti kockice onda?
%da
%uzmimo maksimum

a=max([a1,a2,a3]);
kocka=zeros(dim1,dim2,dim3);

%
%

posx1=1:dim1;
posx1(1)=min_x;
for i=2:dim1
    posx1(i)=min_x+i*a;
end

%
posy1=1:dim2;
posy1(1)=min_y;
for i=2:dim2
    posy1(i)=min_y+i*a;
end


posz1=1:dim3;
posz1(1)=min_z; 
%
for i=2:dim3
    posz1(i)=min_z+i*a;
end

%
broj_tocaka=size(X,2);
%
%index=1:broj_tocaka;
%indey=1:broj_tocaka;
%indez=1:broj_tocaka;

for i=1:broj_tocaka
    %index(i)=pronadji_ind(posx1,X(1,i) );
    %indey(i)=pronadji_ind(posy1,X(2,i) );
    %indez(i)=pronadji_ind(posz1,X(3,i) );
    kocka(pronadji_ind(posx1,X(1,i)),pronadji_ind(posy1,X(2,i)),pronadji_ind(posz1,X(3,i) ))=1;
end

%gotovo. 

