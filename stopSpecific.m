function stop = stopSpecific(Algorithm)      
    % 如果停滞点小于 1，则返回 false      
    % 否则，返回停滞点大于停滞点限制      
       
    if Algorithm.stagnation_limit_ < 1      
        stop = false;      
    else      
        stop = (Algorithm.stagnation_ >= Algorithm.stagnation_limit_);      
    end    

end