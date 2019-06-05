doc_tot = 'result_meta.txt';
Z = 6250;

[x,y,z,Extotr,Eytotr,~,Extoti,Eytoti,~] = textread(doc_tot,'%f %f %f %f %f %f %f %f %f','headerlines',2);
Etot = [Extotr + Extoti*1i, Eytotr + Eytoti*1i];

%%
plot(abs(Etot*[1, 1i]'))

%%
CPL = [1, 1i]';
R = (Etot_cut*CPL);

plot(R)