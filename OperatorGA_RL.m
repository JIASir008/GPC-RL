function Offspring = OperatorGA_RL(Parent,Parameter,Algorithm)
%OperatorGA - Crossover and mutation operators of genetic algorithm.
%
%   Off = OperatorGA(P) uses genetic operators to generate offsprings based
%   on the parents P. If P is an array of SOLUTION objects, then Off is
%   also an array of SOLUTION objects; while if P is a matrix of decision
%   variables, then Off is also a matrix of decision variables, i.e., the
%   offsprings are not evaluated. P is split into two subsets P1 and P2
%   with the same size, where each object or row of P1 and P2 is used to
%   generate two offsprings. Different operators are used for real, binary,
%   and permutation based encodings.
%
%   Off = OperatorGA(P,{proC,disC,proM,disM}) specifies the parameters of
%   operators, where proC is the probability of crossover, disC is the
%   distribution index of simulated binary crossover, proM is the
%   expectation of the number of mutated variables, and disM is the
%   distribution index of polynomial mutation.
%
%   Example:
%       Offspring = OperatorGA(Parent)
%       Offspring = OperatorGA(Parent.decs,{1,20,1,20})
%
%   See also OperatorGAhalf

%------------------------------- Reference --------------------------------
% [1] K. Deb, K. Sindhya, and T. Okabe, Self-adaptive simulated binary
% crossover for real-parameter optimization, Proceedings of the Annual
% Conference on Genetic and Evolutionary Computation, 2007, 1187-1194.
% [2] K. Deb and M. Goyal, A combined genetic adaptive search (GeneAS) for
% engineering design, Computer Science and informatics, 1996, 26: 30-45.
% [3] L. Davis, Applying adaptive algorithms to epistatic domains,
% Proceedings of the International Joint Conference on Artificial
% Intelligence, 1985, 162-164.
% [4] D. B. Fogel, An evolutionary approach to the traveling salesman
% problem, Biological Cybernetics, 1988, 60(2): 139-144.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    %% Parameter setting
    if nargin > 1
        [proC,disC,proM,disM,Crossover,Mutation] = deal(Parameter{:});
    else
        [proC,disC,proM,disM,Crossover,Mutation] = deal(1,20,1,20,4,2);
    end
    if isa(Parent(1),'SOLUTION')
        calObj = true;
        Parent = Parent.decs;
    else
        calObj = false;
    end
    Parent1 = Parent(1:floor(end/2),:);
    Parent2 = Parent(floor(end/2)+1:floor(end/2)*2,:);
    [N,D]   = size(Parent1);
    Problem = PROBLEM.Current();
    Offspring = zeros(2*N,D);
    
    switch Crossover
        case 1
           %%
            %Single-point crossover
            for i = 1:N
                if rand < proC/2
                    crossoverPoint = randi(D - 1);
                    Offspring1 = [Parent1(i,1:crossoverPoint)  Parent2(i,crossoverPoint+1:end)];
                    Offspring2 = [Parent2(i,1:crossoverPoint)  Parent1(i,crossoverPoint+1:end)];
                    Offspring(i,:) = Offspring1;
                    Offspring(i + N,:) = Offspring2;
                else
                    Offspring(i,:) = Parent1(i,:);
                    Offspring(i + N,:) = Parent2(i,:);
                end
            end
            
        case 2
            %Multi-point crossover
            numPoints = randi(D - 1);
            crossoverPoints = sort(randperm(D - 1, numPoints));
            Offspring1 = Parent1;
            Offspring2 = Parent2;
            for k = 1:N
                if rand < proC/2
                    for i = 1:length(crossoverPoints)
                        start = crossoverPoints(i);
                        Offspring1(k,start) = Parent2(k,start);
                        Offspring2(k,start) = Parent1(k,start);
                    end
                end
            end
            Offspring  = [Offspring1;Offspring2];
            
        case 3
            %Uniform crossover
            Offspring1 = Parent1;
            Offspring2 = Parent2;
            Site = rand(N, D) < proC/2;
            temp = Offspring1(Site);
            Offspring1(Site) = Offspring2(Site);
            Offspring2(Site) = temp;
            Offspring = [Offspring1;Offspring2];
            
        case 4
            % Simulated binary crossover
            beta = zeros(N,D);
            mu   = rand(N,D);
            beta(mu<=0.5) = (2*mu(mu<=0.5)).^(1/(disC+1));
            beta(mu>0.5)  = (2-2*mu(mu>0.5)).^(-1/(disC+1));
            beta = beta.*(-1).^randi([0,1],N,D);
            beta(rand(N,D)<0.5) = 1;
            beta(repmat(rand(N,1)>proC/2,1,D)) = 1;
            Offspring = [(Parent1+Parent2)/2+beta.*(Parent1-Parent2)/2
                         (Parent1+Parent2)/2-beta.*(Parent1-Parent2)/2];
    end
    
    switch Mutation
        case 1
            % Uniform-mutation
            Lower = repmat(Problem.lower,2*N,1);
            Upper = repmat(Problem.upper,2*N,1);
            Site = rand(2*N, D) < proM/2;
            randomMutation = rand(2*N, D);
            Offspring = Parent;
            Offspring(Site) = Lower(Site) + randomMutation(Site) .* (Upper(Site) - Lower(Site));
    
        case 2
            % Polynomial mutation
            Lower = repmat(Problem.lower,2*N,1);
            Upper = repmat(Problem.upper,2*N,1);
            Site  = rand(2*N,D) < proM/2;
            mu    = rand(2*N,D);
            temp  = Site & mu<=0.5;
            Offspring       = min(max(Offspring,Lower),Upper);
            Offspring(temp) = Offspring(temp)+(Upper(temp)-Lower(temp)).*((2.*mu(temp)+(1-2.*mu(temp)).*...
                              (1-(Offspring(temp)-Lower(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1))-1);
            temp = Site & mu>0.5; 
            Offspring(temp) = Offspring(temp)+(Upper(temp)-Lower(temp)).*(1-(2.*(1-mu(temp))+2.*(mu(temp)-0.5).*...
                              (1-(Upper(temp)-Offspring(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1)));
                          
        case 3
            %Guass-mutation
            Lower = repmat(Problem.lower,2*N,1);
            Upper = repmat(Problem.upper,2*N,1);
            Site  = rand(2*N,D) < proM/2;
            gaussianMutation = randn(2*N, D) .* disM;
            Offspring = Parent;
            Offspring(Site) = Offspring(Site) + gaussianMutation(Site);
            if Offspring < Lower
                Offspring = Lower;
            end
            if Offspring > Upper
                Offspring = Upper;
            end
            
        case 4
            %Inversion Mutation
            Threshold  = rand(2*N,1) < proM/2;
            Offspring = Parent;
            if ~any(Threshold)
                Offspring = Parent;
            else
                for i = 1: 2*N
                    if Threshold(i)
                        Site = sort(randi([1,D],1,2));
                        Offspring(i,Site(1):Site(2)) = fliplr(Parent(i,Site(1):Site(2)));
                    end
                end
            end
            
        %otherwise 
    end
    
    if calObj
         Offspring = SOLUTION(Offspring);
    end
end