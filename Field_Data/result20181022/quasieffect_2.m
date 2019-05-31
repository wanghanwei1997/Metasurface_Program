% angle_list = 40:5:50;
% feature_list = zeros(10,7,length(angle_list));
% for number = 1:length(angle_list)
%     angle = angle_list(number);
%     run field_plot_2.m
%     feature_list(:,:,number) = feature;
% end
%% phase error
load('feature_list.mat')
clear angle
phase_error = reshape(angle(feature_list(5,6,:)),1,length(angle_list));
phase_error = phase_error - phase_error(1);
for i = 1:length(phase_error)
    while(phase_error(i)<-pi)
        phase_error(i) = phase_error(i)+2*pi;
    end
    while(phase_error(i)>pi)
        phase_error(i) = phase_error(i) - pi;
    end
end
phase_error = phase_error*180/pi;

figure
plot(angle_list,phase_error,'o-')
xlabel('Angle of Boundary (degrees)')
ylabel('Phase Error (degrees)')

%% A11, A12, A21, A22
A11_list = reshape(abs(feature_list(5,1,:)),1,length(angle_list));
A12_list = reshape(abs(feature_list(5,2,:)),1,length(angle_list));
A21_list = reshape(abs(feature_list(5,3,:)),1,length(angle_list));
A22_list = reshape(abs(feature_list(5,4,:)),1,length(angle_list));

figure
subplot(2,2,1)
plot(angle_list,A11_list,'o-')
xlabel('Angle of the Boundary (degree)')
ylabel('Reflection Coefficient')
title('A11')
subplot(2,2,2)
plot(angle_list,A22_list,'o-')
xlabel('Angle of the Boundary (degree)')
ylabel('Reflection Coefficient')
title('A22')
subplot(2,2,3)
plot(angle_list,A21_list,'o-')
xlabel('Angle of the Boundary (degree)')
ylabel('Reflection Coefficient')
title('A21')
subplot(2,2,4)
plot(angle_list,A12_list,'o-')
xlabel('Angle of the Boundary (degree)')
ylabel('Reflection Coefficient')
title('A12')
%% co-po and cross-po
Co1 = reshape(abs(feature_list(1,5,:)),1,length(angle_list));
Co2 = reshape(abs(feature_list(2,5,:)),1,length(angle_list));
Co3 = reshape(abs(feature_list(3,5,:)),1,length(angle_list));
Co4 = reshape(abs(feature_list(4,5,:)),1,length(angle_list));
Co5 = reshape(abs(feature_list(5,5,:)),1,length(angle_list));
Co6 = reshape(abs(feature_list(6,5,:)),1,length(angle_list));
Co7 = reshape(abs(feature_list(7,5,:)),1,length(angle_list));
Co8 = reshape(abs(feature_list(8,5,:)),1,length(angle_list));
Co9 = reshape(abs(feature_list(9,5,:)),1,length(angle_list));
Co_element = Co5;
Co_boundary = (Co1 + Co2 + Co3 + Co4 + Co6 + Co7 + Co8 + Co9)/8;
Co_overall = reshape(abs(feature_list(10,5,:)),1,length(angle_list));

Cross1 = reshape(abs(feature_list(1,6,:)),1,length(angle_list));
Cross2 = reshape(abs(feature_list(2,6,:)),1,length(angle_list));
Cross3 = reshape(abs(feature_list(3,6,:)),1,length(angle_list));
Cross4 = reshape(abs(feature_list(4,6,:)),1,length(angle_list));
Cross5 = reshape(abs(feature_list(5,6,:)),1,length(angle_list));
Cross6 = reshape(abs(feature_list(6,6,:)),1,length(angle_list));
Cross7 = reshape(abs(feature_list(7,6,:)),1,length(angle_list));
Cross8 = reshape(abs(feature_list(8,6,:)),1,length(angle_list));
Cross9 = reshape(abs(feature_list(9,6,:)),1,length(angle_list));
Cross_element = Cross5;
Cross_boundary = (Cross1 + Cross2 + Cross3 + Cross4 + Cross6 + Cross7 + Cross8 + Cross9)/8;
Cross_overall = reshape(abs(feature_list(10,6,:)),1,length(angle_list));

figure
subplot(1,2,1)
plot(angle_list,Co1,angle_list,Co2, angle_list,Co3, angle_list, Co4, ...
    angle_list, Co5, angle_list, Co6, angle_list, Co7, angle_list, Co8, angle_list, Co9)
subplot(1,2,2)
plot(angle_list,Cross1,angle_list,Cross2, angle_list,Cross3, angle_list,...
    Cross4, angle_list, Cross5, angle_list, Cross6, angle_list, Cross7, ...
    angle_list, Cross8, angle_list, Cross9)

figure
subplot(1,2,1)
plot(angle_list, Co_element,'o-', angle_list, Co_boundary,'x-', angle_list, Co_overall,'*-')
xlabel('Angle of the Boundary (degree)')
ylabel('Reflection Coefficient')
title('Co-Polarization')
legend('Central Element','Boundary Elements','Overall')
subplot(1,2,2)
plot(angle_list, Cross_element,'o-', angle_list, Cross_boundary,'x-', angle_list, Cross_overall,'*-')
xlabel('Angle of the Boundary (degree)')
ylabel('Reflection Coefficient')
title('Cross-Polarization')
legend('Central Element','Boundary Elements','Overall')
%% efficiency
efficiency = reshape( feature_list(10,7,:), 1, length(angle_list));
figure
plot(angle_list,efficiency,'o-')
xlabel('Angle of Boundary (degrees)')
ylabel('Efficiency')
%% unit phase
phase_unit = reshape(angle(feature_list(3,6,:)),1,length(angle_list));
for i = 1:length(phase_unit)
    while(phase_unit(i)<-pi)
        phase_unit(i) = phase_unit(i)+2*pi;
    end
    while(phase_unit(i)>pi)
        phase_unit(i) = phase_unit(i) - pi;
    end
end
t = linspace(0,180,100);
phase_unit = phase_unit*180/pi;
f = phase_unit(1) + 2*t;
f = f.*(f>-180 & f<180) + (f-360) .* (f>180);
figure
plot(angle_list,phase_unit,'o-',t,f)
xlabel('Angle of Boundary (degrees)')
ylabel('Efficiency')