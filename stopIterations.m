function stop = stopIterations(Problem)      
    if Problem.iterationsLimit_ < 1      
        stop = false;      
    else      
        stop = (Problem.iterations_>=Problem.iterationsLimit_);      
    end
end    
