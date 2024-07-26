function result = isStepOk(range, steps)
    len = range(2) - range(1);
    result = sum(steps) == len;
end