classdef GPC_RL < ALGORITHM
% <multi> <real/integer/label/binary/permutation> <constrained/none>
% Nondominated sorting genetic algorithm II

%------------------------------- Reference --------------------------------
% K. Deb, A. Pratap, S. Agarwal, and T. Meyarivan, A fast and elitist
% multiobjective genetic algorithm: NSGA-II, IEEE Transactions on
% Evolutionary Computation, 2002, 6(2): 182-197.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    methods
        function main(Algorithm,Problem)
            %% Generate random population
            Population = Problem.Initialization();
            [~,FrontNo,CrowdDis] = EnvironmentalSelection(Population,Problem.N);
            format long;
            %% Optimization
            while Algorithm.NotTerminated(Population)
                 Problem.FE = 1000;
                 if Algorithm.pro.FE == 1000
                    
                    x = input('输入次数','s');
                    lo =  [ 'E:\研究生\Literature\Data\experiments\naf\p\WFG1_10_' x '_.txt'];                    f = importdata(lo, ',');
                    for i = 1:numel(f)
                        data = strsplit(f{i},' ');
                        Population(i).obj(1) = str2double(cell2mat(data(1)));
                        Population(i).obj(2) = str2double(cell2mat(data(2)));
                        Population(i).obj(3) = str2double(cell2mat(data(3)));
                        Population(i).obj(4) = str2double(cell2mat(data(4)));
                        Population(i).obj(5) = str2double(cell2mat(data(5)));
                        Population(i).obj(6) = str2double(cell2mat(data(6)));
                        Population(i).obj(7) = str2double(cell2mat(data(7)));
                        Population(i).obj(8) = str2double(cell2mat(data(8)));
                        Population(i).obj(9) = str2double(cell2mat(data(9)));
                        Population(i).obj(10) = str2double(cell2mat(data(10)));
                    end
                 end
            end
        end
    end
end