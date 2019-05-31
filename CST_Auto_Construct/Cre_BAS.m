classdef Cre_BAS
    %UNTITLED2 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        glofilename = 'Matlab_Micros.txt';
        fileID;
    end
    
    methods
        function [ obj ] = Cre_BAS()
            obj.fileID = fopen( obj.filename, 'w');
        end
        function [] = plottest(obj,Name)
            fprintf(obj.fileID,[Name,'\n']);
        end
        function [] = rotate(obj, componant,Center, Angle)
            fprintf(obj.fileID,' With Transform\n');
            fprintf(obj.fileID,'  .Reset\n');
            fprintf(obj.fileID,['  .Name "',componant,'"\n']);
            fprintf(obj.fileID,'  .Origin "Free"\n');
            fprintf(obj.fileID,['  .Center "',num2str(Center(1)),'", "',...
                num2str(Center(2)),'", "',num2str(Center(3)),'"\n']);
            fprintf(obj.fileID,['  .Angle "',num2str(Angle(1)),'", "',...
                num2str(Angle(2)),'", "',num2str(Angle(3)),'"\n']);
            fprintf(obj.fileID,'  .MultipleObjects "False"\n');
            fprintf(obj.fileID,'  .GroupObjects "False"\n');
            fprintf(obj.fileID,'  .Repetitions "1"\n');
            fprintf(obj.fileID,'  .MultipleSelection "False"\n');
            fprintf(obj.fileID,'  .Transform "Shape","Rotate"\n');
            fprintf(obj.fileID,' End With\n');
        end
        function [] = translate(obj, component, vector)
            fprintf(obj.fileID,' With Transform\n');
            fprintf(obj.fileID,['  .Name "',component,'"\n']);
            fprintf(obj.fileID,['  .Vector "',num2str(vector(1)),'", "',num2str(vector(2)),'", "',...
                num2str(vector(3)),'"\n']);
            fprintf(obj.fileID,'  .UsePickedPoints "False"\n');
            fprintf(obj.fileID,'  .InvertPickedPoints "False"\n');
            fprintf(obj.fileID,'  .MultipleObjects "False"\n');
            fprintf(obj.fileID,'  .GroupObjects "False"\n');
            fprintf(obj.fileID,'  .Repetitions "1"\n');
            fprintf(obj.fileID,'  .MultipleSelection "False"\n');
            fprintf(obj.fileID,'  .Transform "Shape", "Translate"\n');
            fprintf(obj.fileID,' End With\n');
        end
        function [] = square(obj,Name, Component, Material, Xrange, Yrange, Zrange)
            fprintf(obj.fileID,' With Brick \n');
            fprintf(obj.fileID,'  .Reset\n');
            fprintf(obj.fileID,['  .Name "',Name,'"\n']);
            fprintf(obj.fileID,['  .Component "',Component,'"\n']);
            fprintf(obj.fileID,['  .Material "',Material,'"\n']);
            fprintf(obj.fileID,['  .Xrange "',num2str(Xrange(1)),'", "',num2str(Xrange(2)),'"\n']);
            fprintf(obj.fileID,['  .Yrange "',num2str(Yrange(1)),'", "',num2str(Yrange(2)),'"\n']);
            fprintf(obj.fileID,['  .Zrange "',num2str(Zrange(1)),'", "',num2str(Zrange(2)),'"\n']);
            fprintf(obj.fileID,'  .Create\n');
            fprintf(obj.fileID,' End With\n');
        end
        function [] = subtract( obj, componant1, componant2 )
            fprintf(obj.fileID,[' Solid.Subtract "',componant1,'", "',componant2,'"\n']);
        end
        function [] = defMaterial( obj, material )
            fpn = fopen([material,'.txt'],'rt');
            while feof(fpn) ~= 1
                 file = fgetl(fpn);
                 new_str = file;
                 fprintf(obj.fileID,' %s\n',new_str);
            end
        end
    end
end

