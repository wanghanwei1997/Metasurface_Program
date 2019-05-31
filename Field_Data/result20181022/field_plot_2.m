% %% angle
 angle = 0;

%% loading
% inclined
doc_ref_1 = [num2str(angle),',1.txt'];
doc_inc_1 = 'inc,1.txt';
doc_ref_2 = [num2str(angle),',2.txt'];
doc_inc_2 = 'inc,2.txt';
thick = 55;

% read dir 1(x) propogated light
global x; global y; global z; global Exr_1; global Eyr_1; global Exi_1;
global Eyi_1;global Exr1_inc, global Eyr1_inc; global Exi1_inc; global Eyi1_inc;

[x,y,z,Exr_1,Eyr_1,Ezr1,Exi_1,Eyi_1,Ezi1] = textread(doc_ref_1,'%f %f %f %f %f %f %f %f %f','headerlines',2);
[~,~,~,Exr1_inc,Eyr1_inc,Ezr1_inc,Exi1_inc,Eyi1_inc,Ezi1_inc] = textread(doc_inc_1,'%f %f %f %f %f %f %f %f %f','headerlines',2);

% read dir 2(y) propogated light
global Exr_2; global Eyr_2; global Exi_2;
global Eyi_2;global Exr2_inc, global Eyr2_inc; global Exi2_inc; global Eyi2_inc;

[~,~,~,Exr_2,Eyr_2,Ezr2,Exi_2,Eyi_2,Ezi2] = textread(doc_ref_2,'%f %f %f %f %f %f %f %f %f','headerlines',2);
[~,~,~,Exr2_inc,Eyr2_inc,Ezr2_inc,Exi2_inc,Eyi2_inc,Ezi2_inc] = textread(doc_inc_2,'%f %f %f %f %f %f %f %f %f','headerlines',2);

%% calculate features as A11, A12, A21, A22, rco, rcross and eta
feature = zeros(10,7);
for i = 1:10
    [ ~, ~, EX_1, EY_1, EX_I, EX_2, EY_2, EY_I ] = CUT ( i );
    feature(i,:) = FEA ( EX_1, EY_1, EX_I, EX_2, EY_2, EY_I );
end
fprintf('The calculated feature of boundary of %d degrees is: \n', angle);
disp( feature )

%% function to cut field of selected area
function [ X, Y, EX_1, EY_1, EX_I, EX_2, EY_2, EY_I ] = CUT ( numArea ) %incpude nember of area
global x; global y; global z; global Exr_1; global Eyr_1; global Exi_1;
global Eyi_1;global Exr1_inc, global Eyr1_inc; global Exi1_inc; global Eyi1_inc;
global Exr_2; global Eyr_2; global Exi_2;
global Eyi_2;global Exr2_inc, global Eyr2_inc; global Exi2_inc; global Eyi2_inc;

switch numArea
    case 1 %Left Up
        mask = ((x <= -150)+(y >= 150))==2;
    case 2 %M U
        mask = ((x >= -150) + (x <= 150 ) + (y >= 150))==3;
    case 3 %R U
        mask = ((x >= 150) +  (y >= 150))==2;
    case 4 %L
        mask = ((x <= -150) +  (y <= 150) + (y >= -150))==3;
    case 5 %Center
        mask = ((x >= -150) + (x <= 150) +  (y <= 150) + (y >= -150))==4;
    case 6 %R
        mask = ((x >= 150) +  (y <= 150) + (y >= -150))==3;
    case 7 %L Down
        mask = ((x <= -150)+(y <= -150))==2;
    case 8 %M D
        mask = ((x >= -150) + (x <= 150)+(y <= -150))==3;
    case 9 %R D
        mask = ((x >= 150) +(y <= -150))==2;
    case 10 % All 9
        mask = ( (z==100) == 1 );
end
nonzeros = length(find(mask==1));
X = zeros(1,nonzeros);
Y = zeros(1,nonzeros);
EX_1 = zeros(sqrt(nonzeros),sqrt(nonzeros));
EY_1 = zeros(sqrt(nonzeros),sqrt(nonzeros));
EX_I = zeros(sqrt(nonzeros),sqrt(nonzeros));
EX_2 = zeros(sqrt(nonzeros),sqrt(nonzeros));
EY_2 = zeros(sqrt(nonzeros),sqrt(nonzeros));
EY_I = zeros(sqrt(nonzeros),sqrt(nonzeros));

num = 1;
for i = 1:length(x)
    if(mask(i)==1)
        row = floor((num-1)/sqrt(nonzeros))+1;
        col = num - (row-1)*sqrt(nonzeros);
        X(num) = x(i);
        Y(num) = y(i);
        EX_1(row,col) = Exr_1(i)+Exi_1(i)*1i;
        EY_1(row,col) = Eyr_1(i)+Eyi_1(i)*1i;
        EX_I(row,col) = Exr1_inc(i)+Exi1_inc(i)*1i;
        EX_2(row,col) = Exr_2(i)+Exi_2(i)*1i;
        EY_2(row,col) = Eyr_2(i)+Eyi_2(i)*1i;
        EY_I(row,col) = Eyr2_inc(i)+Eyi2_inc(i)*1i;
        num = num+1;
    end
end
% figure
% subplot(2,2,1)
% imagesc(real(EX_1-EX_I))
% colorbar
% title('Co-Polarization of dir1 Inclined')
% subplot(2,2,2)
% imagesc(real(EY_1))
% colorbar
% title('Cross-Polarization of dir1 Inclined')
% subplot(2,2,3)
% imagesc(real(EX_2))
% colorbar
% title('Cross-Polarization of dir2 Inclined')
% subplot(2,2,4)
% imagesc(real(EY_2-EY_I))
% colorbar
% title('Co-Polarization of dir2 Inclined')
end

%% function to calculate all features from the field information
function [ feature ] = FEA ( EX_1, EY_1, EX_I, EX_2, EY_2, EY_I )
A11 = sum(sum(EX_1-EX_I))/sum(sum(EX_I));
A21 = sum(sum(EY_1))/sum(sum(EX_I));
A12 = sum(sum(EX_2))/sum(sum(EY_I));
A22 = sum(sum(EY_2-EY_I))/sum(sum(EY_I));
co_handed = 0.5*(A11+A22);
cross_handed = 0.5*((A11-A22)+1i*(A12+A21));
efficiency = abs(cross_handed)^2;
feature = [A11, A21, A12, A22, co_handed, cross_handed, efficiency];
end
