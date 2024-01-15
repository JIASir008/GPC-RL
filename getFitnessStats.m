function fitnessstats = getFitnessStats(Population)    
    % 四个指标：平均，标准差，当前最差，当前最好  
    % 将指标值存储在 fitnessstats 数组中   
    fitnessstats = []; 
    mea = mean(FitnessSingle(Population));   % 平均值
    sum = 0;    
    for i = 1:length(Population)
        sum = sum + (FitnessSingle(Population(i)) - mea).^ 2;    
    end    
    std = sqrt(sum./length(Population));
    fitnessstats(1, :) = mea;
    fitnessstats(2, :) = std;
    fitnessstats(3, :) = max(FitnessSingle(Population));  % 最差  
    fitnessstats(4, :) = min(FitnessSingle(Population));  % 最好  
end  
