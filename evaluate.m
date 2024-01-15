function  evaluate(Problem,Algorithm,x)
    % If evaluations limit is reached then ignore
    if( Problem.FE >= getmFE(Problem) )
    else
        % Evaluate point
        fitness = FitnessSingle(x);
        if length(x) ~= 1
            for i = 1:length(x)
                x(i).fit = fitness(i);
            end
        else
            x.fit = fitness;
        end
        % Check if better than the best found so far
        if isempty(Algorithm.best_fit_)
            Algorithm.best_fit_ = fitness ;
        elseif min(fitness) < Algorithm.best_fit_
            Algorithm.best_fit_ = min(fitness);
        end
    end
end
