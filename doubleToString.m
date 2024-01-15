function res = doubleToString(d)
    leng = length(d);
    if(leng == 0)
        res = '';
    elseif(leng > 13)
        leng = 13;
    end
    if(leng ~= 0)
        res = " " + d(1);
        for i = 2:leng
            res = res + ["," + d(i)];
        end
    end
end