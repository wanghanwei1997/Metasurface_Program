doc_tot = 'result_f.txt';
doc_inc = 'result_empty.txt';
Z = 1300;

[x,y,z,Extotr,Eytotr,~,Extoti,Eytoti,~] = textread(doc_tot,'%f %f %f %f %f %f %f %f %f','headerlines',2);
Etot_x = Extotr + Extoti*1i;
Etot_y = Eytotr + Eytoti*1i;
[~,~,~,Exincr,Eyincr,~,Exinci,Eyinci,~] = textread(doc_inc,'%f %f %f %f %f %f %f %f %f','headerlines',2);
Einc_x = Exincr + Exinci*1i;
Einc_y = Eyincr + Eyinci*1i;
%%
adjust = ((x<=150 & x>-150) & (y <= 150 & y>-150) & (z==1300));
Etot_cut_x = Etot_x(adjust == 1);
Etot_cut_y = Etot_y(adjust == 1);
Einc_cut_x = Einc_x(adjust == 1);
Einc_cut_y = Einc_y(adjust == 1);
Eref_cut_x = Etot_cut_x - Einc_cut_x;
Eref_cut_y = Etot_cut_y - Einc_cut_y;
%%
CPL = [1,-1i];
R = sum(Eref_cut_x*CPL(1) + Eref_cut_y*CPL(2))/sum(Einc_cut_x*CPL(1) + Eref_cut_y*CPL(2));
T = angle(R);
T_degree = T*180/pi;
