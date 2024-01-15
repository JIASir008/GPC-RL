function ind = newRandomIndividual(Problem,Algorithm)
    ind = Problem.Initialization(1);
    evaluate(Problem,Algorithm,ind);
end