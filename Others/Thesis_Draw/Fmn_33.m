ml = 0:2;
nl = 0:2;
c = 0;
figure
hold on
for i = 1:3
    for j = 1:3
        m = ml(4-i);
        n = nl(j);
        c = c+1;
        subplot(3,3,c)
        run Fmn_sub.m;
        title(['mode',num2str(m),num2str(n)])
    end
end
hold off