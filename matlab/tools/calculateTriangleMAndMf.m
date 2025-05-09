function [M_and_Mf] = calculateTriangleMAndMf(degree)
    %CALCULATETRIANGLEMANDMF  Calculate all possible M and Mf with given degree.
    %
    %   [M_and_Mf] = calculateTriangleMAndMf(degree) returns all possible
    %   combinations of M and Mf of a triangle with given degree.
    %
    %   The relationship between M and Mf is:
    %
    %   M + Mf - 2 = degree, degree >= 1, 0 <= M <= Mf <= degree
    %
    %
    %   Parameters:
    %
    %   degree - given degree of the triangle.
    %
    %   Returns:
    %
    %   M_and_Mf - matrix of all possible M and Mf, where each row is a
    %              combination of M and Mf.
    if degree < 1
        disp('Degree must be greater than or equal to 1');
        return;
    end

    if degree == 1
        M_and_Mf = [1, 1];
        return;
    end

    max_size = degree + 2;
    M_and_Mf = zeros(max_size, 2);

    count = 1;

    for M = 1:max_size % M 的最大值是 q+2
        Mf = max_size - M;

        if Mf >= M && Mf <= degree
            M_and_Mf(count, :) = [M, Mf];
            count = count + 1;
        end

    end

    if count > 1
        M_and_Mf = M_and_Mf(1:count - 1, :);
    else
        M_and_Mf = [];
    end

end
