function stop = stopEvaluations(Problem)
    maxFE = Problem.getmFE();
    if maxFE < 1     
        stop = false;      
    else      
        stop = (Problem.FE >= getmFE(Problem) );      
    end 
end