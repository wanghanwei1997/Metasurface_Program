%% parameters
B1 = 0.5;
B2 = 0.4;
B3 = 0.3;
B4 = 0.2;
B5 = 0.1;
nx = 20;
ny = 20;

%% 
W = sparse(nx*ny, nx*ny);
for i = 1:nx*ny
    W(i,i) = 2;
    for j = 1:nx*ny
        x1 = floor((i-1)/nx);
        y1 = i - x1*nx;
        x2 = floor((j-1)/ny);
        y2 = j - x2*nx;
        dis = (x2 - x1)^2 + (y1 - y2)^2;
        switch dis
            case 1
               W(i,j) = 2*B1;
               W(i,i) = W(i,i) - 2*B1;
            case 2
                W(i,j) = 2*B2;
                W(i,i) = W(i,i) - 2*B2;
            case 4
                W(i,j) = 2*B3;
                W(i,i) = W(i,i) - 2*B3;
            case 5
                W(i,j) = 2*B4;
                W(i,i) = W(i,i) - 2*B4;
            case 8
                W(i,j) = 2*B5;
                W(i,i) = W(i,i) - 2*B5;
        end       
    end
end

%%
figure
mesh(W)
