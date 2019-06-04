clear; close all; clc
%%
load('THU.mat');
%% plot 
%imagesc(ILoveTHU);
%%
n1 = 200; %row unit number
n2 = 200; %column unit number
unit_x = 0.3e-6;
unit_y = 0.3e-6;
freq = 0.375e15;
dis = 1e-4;

C = 3e8;
k = 2*pi*freq/C;

P = zeros(n1,n2);

x = 0.5*unit_x:unit_x:(n1-0.5)*unit_x;
y = 0.5*unit_y:unit_y:(n2-0.5)*unit_y;
[X,Y] = meshgrid(x,y);

coe = 10; % ratio of object size and metasurface size
x2 = coe*(0.5*unit_x:unit_x:19.5*unit_x);
y2 = coe*(0.5*unit_x:unit_x:19.5*unit_x);
[X2,Y2] = meshgrid(coe*(0.5*unit_x:unit_x:19.5*unit_x),...
    coe*(0.5*unit_x:unit_x:19.5*unit_x));
ILovePKU = zeros(20,20);
ILovePKU(1,1) = 1;

%% 
for i = 1:n1
    for j = 1:n2
        D = ((X2-X(i,j)).^2+(Y2-Y(i,j)).^2+dis^2).^0.5;
        P(i,j) = angle(sum(sum(ILoveTHU.*exp(1i*k*D))));
    end
end

figure
imagesc(P)
colorbar

%%
num = 30;
new_ILoveTHU = zeros(num,num);
x3 = linspace(coe*0.5*unit_x,coe*19.5*unit_x,num);
y3 = linspace(coe*0.5*unit_y,coe*19.5*unit_y,num);
[X3,Y3] = meshgrid(x3,y3);
for i = 1:num
    for j = 1:num
        D = ((X3(i,j)-X).^2+(Y3(i,j)-Y).^2+dis^2).^0.5;
        new_ILoveTHU(i,j) = abs(sum(sum(exp(1i*P).*exp(-1i*k*D))));
        disp([i,j]);
    end
end
figure
imagesc(new_ILoveTHU)
        

