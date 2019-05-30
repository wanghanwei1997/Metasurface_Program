fid = fopen('Silicon.txt','wt');
phns = 'Silicon_2.txt';
fpn = fopen(phns,'rt');
while feof(fpn) ~= 1
    file = fgetl(fpn);
    new_str = file;
    fprintf(fid,'%s\n',new_str);
end
fclose(fid)