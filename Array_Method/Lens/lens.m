classdef lens
    % this class is use to generate metasurface lens
    
    properties
        f = 10e-6; %focus
        n1 = 40; %row unit number
        n2 = 40; %colum unit number
        unit_x = 300e-9;
        unit_y = 300e-9;
        freq = 0.375e15;
        k;
    end
    
    methods
        function obj = lens()
            C = 3e8;
            obj.k = 2*pi*obj.freq/C;
        end
        
        function [] = phaseDis(obj,n)
            %generate area n times larger then metasurface area
            left = -obj.n1/2*obj.unit_x*n;
            right = obj.n1/2*obj.unit_x*n;
            down = -obj.n2/2*obj.unit_y*n;
            up = obj.n2/2*obj.unit_y*n;
            x = linspace(left,right);
            y = linspace(down,up);
            [X , Y] = meshgrid(x,y);
            P_d = rem(obj.k*((X.^2 + Y.^2 + obj.f^2).^0.5 - obj.f),2*pi);
            
            imagesc(x,y,P_d)
            colorbar
            xlabel('X(m)')
            ylabel('Y(m)')
        end
        
        function [phase_Matrix] = phaseMatrix(obj,figonoff)
            x = (-(obj.n1-1)/2:(obj.n1-1)/2)*obj.unit_x;
            y = (-(obj.n2-1)/2:(obj.n2-1)/2)*obj.unit_y;
            [X,Y] = meshgrid(x,y);
            phase_Matrix = obj.k*((X.^2 + Y.^2 + obj.f^2).^0.5 - obj.f);
            save('phaseMatrix','phase_Matrix');
            if(strcmp(figonoff,'on'))
                imagesc(phase_Matrix)
                colorbar
            end  
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
            save('WMatrix','W');
        end
        function [phase_Matrix_quasi] = quasiPhase(obj) %calculate phase distribution
            W = obj.calW();
            phase_Matrix = obj.phaseMatrix('off');
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
            
            save('phaseMatrixQuasi','phase_Matrix_quasi');
            error = angle(exp(1i*phase_Matrix_quasi)) - angle(exp(1i*phase_Matrix));
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
            figure
            subplot(1,3,1)
            imagesc(angle(exp(1i*phase_Matrix)))
            xlabel('X Unit Number')
            ylabel('Y Unit Number')
            colorbar
            subplot(1,3,2)
            imagesc(angle(exp(1i*phase_Matrix_quasi)))
            xlabel('X Unit Number')
            ylabel('Y Unit Number')
            colorbar
            subplot(1,3,3)
            imagesc(error2)
            xlabel('X Unit Number')
            ylabel('Y Unit Number')
            colorbar
        end
        
        function [] = fieldZ_quasi(obj)
            phase_Matrix_quasi = obj.quasiPhase;
            disp_x = 10e-6;
            disp_y = 10e-6;
            dis = obj.f;
            inc = 1e-6;
            x = (-(obj.n1-1)/2:(obj.n1-1)/2)*obj.unit_x;
            y = (-(obj.n2-1)/2:(obj.n2-1)/2)*obj.unit_y;
            [X,Y] = meshgrid(x,y);
            rec_x = -disp_x/2:inc:disp_x/2;
            rec_y = -disp_y/2:inc:disp_y/2;
            intensity = zeros(length(rec_x),length(rec_y));
            for i = 1:length(rec_x)
               for j = 1:length(rec_y)
                 d = (dis^2+ (X-rec_x(i)).^2 + (Y-rec_y(j)).^2).^0.5; 
                 phase =  obj.k * d - phase_Matrix_quasi ;
                 a = sqrt(obj.unit_x*obj.unit_y / (2*pi) *dis)*(d).^(-1.5);
                 intensity(i,j) = abs(sum(sum( a .* exp(1i * phase) )))^2;
               end
            end
            
            intensity_dB = 10*log(intensity)/log(10);
            subplot(1,2,1)
            imagesc(rec_x,rec_y,intensity)
            xlabel('X (m)')
            ylabel('Y (m)')
            colorbar
            
            subplot(1,2,2)
            imagesc(rec_x,rec_y,intensity_dB)
            xlabel('X (m)')
            ylabel('Y (m)')
            colorbar
            
            fprintf('The maximum gain is %f (%f dB)\n',max(max(intensity)),...
                max(max(intensity_dB)));
        end
        
        function [] = fieldZ(obj)
            phase_Matrix = obj.phaseMatrix('off');
            disp_x = 10e-6;
            disp_y = 10e-6;
            dis = obj.f;
            inc = 1e-6;
            x = (-(obj.n1-1)/2:(obj.n1-1)/2)*obj.unit_x;
            y = (-(obj.n2-1)/2:(obj.n2-1)/2)*obj.unit_y;
            [X,Y] = meshgrid(x,y);
            rec_x = -disp_x/2:inc:disp_x/2;
            rec_y = -disp_y/2:inc:disp_y/2;
            intensity = zeros(length(rec_x),length(rec_y));
            for i = 1:length(rec_x)
               for j = 1:length(rec_y)
                 d = (dis^2+ (X-rec_x(i)).^2 + (Y-rec_y(j)).^2).^0.5; 
                 phase =  obj.k * d - phase_Matrix ;
                 a = sqrt(obj.unit_x*obj.unit_y / (2*pi) *dis)*(d).^(-1.5);
                 intensity(i,j) = abs(sum(sum( a .* exp(1i * phase) )))^2;
               end
            end
            
            intensity_dB = 10*log(intensity)/log(10);
            subplot(1,2,1)
            imagesc(rec_x,rec_y,intensity)
            xlabel('X (m)')
            ylabel('Y (m)')
            colorbar
            
            subplot(1,2,2)
            imagesc(rec_x,rec_y,intensity_dB)
            xlabel('X (m)')
            ylabel('Y (m)')
            colorbar
            
            fprintf('The maximum gain is %f (%f dB)\n',max(max(intensity)),...
                max(max(intensity_dB)));
        end
        
        function [phase_Matrix_fixed,error2] = fixPhase(obj) %calculate phase distribution
            W = obj.calW();
            phase_Matrix = obj.phaseMatrix('off');
            phase_Matrix_quasi = obj.quasiPhase();
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
            figure
            subplot(1,3,1)
            imagesc(angle(exp(1i*phase_Matrix))*180/pi/2)
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
            
            fprintf('Max fix angle is %f (%f).\n',max(max(error2))/2,max(max(error2))*180/pi/2);
            fprintf('Average fix angle is %f (%f).\n',mean(mean(error2))/2,mean(mean(error2))*180/pi/2);
        end
    end
end

