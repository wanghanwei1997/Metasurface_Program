close all; clear all; clc;

load size_element.mat;
load xmn.mat;
load ymn.mat;

amn = size_element;

[M,N] = size(xmn);

p = 12e-3;
c = 3e8;
f = 12.5e9;
lambda = c/f;

L = 0.24;


fid=fopen('Patch.dxf','w');
fprintf(fid,'0\nSECTION\n2\nENTITIES\n');
%________________________write file body
for m=1:M
     for n=1:N
%          if (abs(xmn(m,n)*1e-3)+p/2)^2+(abs(ymn(m,n)*1e-3)+p/2)^2<(L/2)^2
%          if L/2-(sqrt((xmn(m,n)*1e-3)^2+(ymn(m,n)*1e-3)^2)+p/2)>=0
             a=amn(m,n);
             x1=xmn(m,n)-a/2;
             y1=ymn(m,n)+a/2;
             x2=xmn(m,n)-a/2;
             y2=ymn(m,n)-a/2;
             x3=xmn(m,n)+a/2;
             y3=ymn(m,n)+a/2;
             x4=xmn(m,n)+a/2;
             y4=ymn(m,n)-a/2;
      
             fprintf(fid,'0\nSOLID\n');  
             fprintf(fid,'10\n%f\n20\n%f\n',x1,y1);  
             fprintf(fid,'11\n%f\n21\n%f\n',x2,y2);  
             fprintf(fid,'12\n%f\n22\n%f\n',x3,y3);  
             fprintf(fid,'13\n%f\n23\n%f\n',x4,y4);
%          end
    end
end
%________________________write file end
fprintf(fid,'0\nENDSEC\n0\nEOF\n');
fclose(fid);