%%
a = imread('ILoveTHU_draw.png');
b = a(:,:,1)+a(:,:,2)+a(:,:,3);
c = uint8(b<100);

[m,n] = size(c);
step_x = m/20;
step_y = n/20;
d = zeros(20,20);

for i = 1:20
    for j = 1:20
        x = round(i*step_x - step_x/2);
        y = round(j*step_y - step_y/2);
        d(i,j) = c(x,y);
    end
end
imagesc(d)

ILoveTHU = d;