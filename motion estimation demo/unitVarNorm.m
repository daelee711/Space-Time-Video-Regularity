function output = unitVarNorm(matrix)
    mm=mean(matrix(:));
    ss=std(matrix(:));

    output=(matrix-mm)./(ss+eps); % zero-centered unit variance
end

