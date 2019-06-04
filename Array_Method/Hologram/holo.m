classdef holo
    %this program is used to calculate quasi-periodical effect of hologram
    
    properties
        n1 = 40;
        n2 = 40;
        unit_xm = 300e-9; %metasurface unit
        unit_ym = 300e-9;
        unit_xo = 600e-9; %object unit
        unit_yo = 600e-9; 
        freq = 0.375e15;
        k;
        dis = 10e-6; %distance between object and metasurface
    end
    
    methods
        function obj = holo()
            %UNTITLED5 Construct an instance of this class
            %   Detailed explanation goes here
            C = 3e8;
            obj.k = 2*pi*obj.freq/C;
        end
        
        function [Pm] = phaseDis(obj)
            load('THU.mat');
            leftm = -(obj.n1-1)/2;
            rightm = (obj.n1-1)/2;
            downm = -(obj.n2-1)/2;
            upm = (obj.n2-1)/2;
            lefto = -9.5;
            righto = 9.5;
            downo = -9.5;
            upo = 9.5;
            xm = (leftm:rightm)*obj.unit_xm;
            ym = (downm:upm)*obj.unit_ym;
            [XM, YM] = meshgrid(xm,ym);
            xo = (lefto:righto)*obj.unit_xo;
            yo = (downo:upo)*obj.unit_yo;
            [XO, YO] = meshgrid(xo,yo);
            Pm = zeros(obj.n1,obj.n2);
            for i = 1:obj.n1
               for j = 1:obj.n2
               D = ((XO-XM(i,j)).^2+(YO-YM(i,j)).^2+obj.dis^2).^0.5;
               Pm(i,j) = angle(sum(sum(ILoveTHU.*D.^(-0.75).*exp(1i*obj.k*D))));
               end
            end
            figure
            imagesc(xm,ym,Pm)
            xlabel('X (m)')
            ylabel('y (m)')
            colorbar;
            
            figure
            imagesc(Pm)
            xlabel('Unit X Number')
            ylabel('Unit Y Number')
            colorbar
        end
        
        function [W] = calW(obj)
            B1 = -0.3047;
            B2 = -0.1140;
            B3 = 0.1172;
            B4 = -0.1168;
            B5 = 0.0581;
            tot = obj.n1*obj.n2;
            W = sparse(tot, tot);
            for i = 1:tot
               W(i,i) = 2;
               for j = 1:tot
                    x1 = floor((i-1)/obj.n1);
                    y1 = i - x1*obj.n1;
                    x2 = floor((j-1)/obj.n2);
                    y2 = j - x2*obj.n1;
                    d = (x2 - x1)^2 + (y1 - y2)^2;
                 switch d
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
            save('WMatrix','W');
        end
        
        function [phase_Matrix_quasi] = quasiPhase(obj) %calculate phase distribution
            W = obj.calW();
            load('fix_Phase_4040_3.mat')
           % phase_Matrix = obj.phaseDis();
            angle_vector = zeros(obj.n1*obj.n2,1);
            count = 0;
            for i = 1:obj.n1
                for j = 1:obj.n2
                    count = count+1;
                    angle_vector(count) = phase_Matrix(i,j)/2;
                end
            end
            
            phase_vector = W*angle_vector;
            phase_Matrix_quasi = zeros(obj.n1,obj.n2);
            count = 0;
            for i = 1:obj.n1
                for j = 1:obj.n2
                    count = count+1;
                    phase_Matrix_quasi(i,j) = phase_vector(count);
                end
            end
            
            phase_Matrix_quasi = angle(exp(1i*phase_Matrix_quasi));
            save('phaseMatrixQuasi','phase_Matrix_quasi');
            
            subplot(1,2,1)
            imagesc(phase_Matrix)
            xlabel('X Unit Number')
            ylabel('Y Unit Number')
            colorbar
            subplot(1,2,2)
            imagesc(phase_Matrix_quasi)
            xlabel('X Unit Number')
            ylabel('Y Unit Number')
            colorbar
            
        end
        
        function [new_ILoveTHU] = inverse(obj)
            num = 100;
         %   phase_Matrix = obj.quasiPhase();
            phase_Matrix = obj.phaseDis();
            leftm = -(obj.n1-1)/2;
            rightm = (obj.n1-1)/2;
            downm = -(obj.n2-1)/2;
            upm = (obj.n2-1)/2;
            xm = (leftm:rightm)*obj.unit_xm;
            ym = (downm:upm)*obj.unit_ym;
            [XM, YM] = meshgrid(xm,ym);
            
            lefto = -9.5*obj.unit_xo;
            righto = 9.5*obj.unit_xo;
            downo = -9.5*obj.unit_yo;
            upo = 9.5*obj.unit_yo;
            xn = linspace(lefto,righto,num);
            yn = linspace(downo,upo,num);
            [XN,YN] = meshgrid(xn,yn);
            
            new_ILoveTHU = zeros(num,num);
            for i = 1:num
                for j = 1:num
                    D = ((XN(i,j)-XM).^2+(YN(i,j)-YM).^2+obj.dis^2).^0.5;
                    new_ILoveTHU(i,j) = abs(sum(sum(exp(1i*phase_Matrix).*exp(-1i*obj.k*D))));
                %sqrt(obj.dis)*D.^(-0.75).*
                end
            end
            figure
            imagesc(xn,yn,new_ILoveTHU);
            colorbar
            xlabel('X (m)')
            ylabel('Y (m)')
        end
        
        function [phase_Matrix_fixed] = fixPhase(obj) %calculate phase distribution
            W = obj.calW();
          %  phase_Matrix = obj.phaseCont(obj.phaseDis());
            phase_Matrix_quasi = obj.phaseCont(obj.quasiPhase());
            angle_vector = zeros(obj.n1*obj.n2,1);
            count = 0;
            for i = 1:obj.n1
                for j = 1:obj.n2
                    count = count+1;
                    angle_vector(count) = phase_Matrix_quasi(i,j);
                end
            end
            
            phase_vector = 2*W^(-1)*angle_vector;
            phase_Matrix_fixed = zeros(obj.n1,obj.n2);
            count = 0;
            for i = 1:obj.n1
                for j = 1:obj.n2
                    count = count+1;
                    phase_Matrix_fixed(i,j) = phase_vector(count);
                end
            end
            
            save('phaseMatrixQuasi','phase_Matrix_quasi');
            error = angle(exp(1i*phase_Matrix_fixed)) - angle(exp(1i*phase_Matrix_quasi));
            for i = 1:obj.n1
                for j = 1:obj.n2
                    if(error(i,j)>pi)
                        error(i,j) = error(i,j)-2*pi;
                    end
                    if(error(i,j)<-pi)
                        error(i,j) = error(i,j)+2*pi;
                    end
                end
            end
            error2 = error(2:(obj.n1-1),2:(obj.n2-1));
            subplot(1,3,1)
            imagesc(angle(exp(1i*phase_Matrix_quasi))*180/pi/2)
            xlabel('X Unit Number')
            ylabel('Y Unit Number')
            colorbar
            subplot(1,3,2)
            imagesc(angle(exp(1i*phase_Matrix_fixed))*180/pi/2)
            xlabel('X Unit Number')
            ylabel('Y Unit Number')
            colorbar
            subplot(1,3,3)
            imagesc(error2*180/pi/2)
            xlabel('X Unit Number')
            ylabel('Y Unit Number')
            colorbar
            
            fprintf('Max fix angle is %f (%f).\n',max(max(abs(error2)))/2,max(max(abs(error2)))*180/pi/2);
            fprintf('Average fix angle is %f (%f).\n',mean(mean(abs(error2)))/2,mean(mean(abs(error2)))*180/pi/2);
        end
        function [newPhase] = phaseCont(obj,oldPhase)%make phase continious
            [m,n] = size(oldPhase);
            newPhase = zeros(m,n);
            t1 = oldPhase(1,1);
            for i = 1:m
                newPhase(i,1) = oldPhase(i,1);
                while(newPhase(i,1) - t1 > pi)
                    newPhase(i,1) = newPhase(i,1) - 2*pi;
                end
                while(newPhase(i,1) - t1 < - pi)
                    newPhase(i,1) = newPhase(i,1) + 2*pi;
                end
                t1 = newPhase(i,1);
            end
            for i = 1:m
                t1 = newPhase(i,1);
                for j = 1:n
                    newPhase(i,j) = oldPhase(i,j);
                    while(newPhase(i,j) - t1 > pi)
                        newPhase(i,j) = newPhase(i,j) - 2*pi;
                    end
                    while(newPhase(i,j) - t1 < -pi)
                        newPhase(i,j) = newPhase(i,j) + 2*pi;
                    end
                    t1 = newPhase(i,j);
                end
            end
            figure
            subplot(1,2,1)
            imagesc(oldPhase);
            colorbar;
            subplot(1,2,2)
            imagesc(newPhase);
            colorbar
        end
    end
end

