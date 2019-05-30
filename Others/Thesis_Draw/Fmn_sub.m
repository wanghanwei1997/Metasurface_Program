
% This document is to draw mn mode field
x = linspace(0,1);
y = linspace(0,1);
[X, Y] = meshgrid(x,y);
F = real(exp(1i*(2*pi*m*X + 2*pi*n*Y)));

imagesc(x,y,F)
xlabel('X (a.u.)')
ylabel('Y (a.u.)')