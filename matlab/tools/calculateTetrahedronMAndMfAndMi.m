function M_and_Mf_and_Mi = calculateTetrahedronMAndMfAndMi(degree)
    %CALCULATETETRAHEDRONMANDMFANDMI  Calculate all possible M, Mf and Mi with given degree.
    %
    %   [M_and_Mf_and_Mi] = calculateTetrahedronMAndMfAndMi(degree) returns all possible
    %   combinations of M, Mf and Mi of a tetrahedron with given degree.
    %
    %   The relationship between M, Mf and Mi is:
    %
    %   M + Mi - 2 = degree, degree >= 1, 0 <= M <= Mf <= Mi <= degree
    %
    %
    %   Parameters:
    %       degree - given degree of the tetrahedron.
    %
    %   Returns:
    %       M_and_Mf_and_Mi - matrix of all possible M, Mf and Mi, where each row is a
    %              combination of M, Mf and Mi.
    if degree < 1
        disp('Degree must be greater than or equal to 1');
        return;
    end

    if degree == 1
        M_and_Mf_and_Mi = [1, 1, 1];
        return;
    end

    max_size = 9 * (degree +1) * degree / 2;
    M_and_Mf_and_Mi = zeros(max_size, 3); % M, Mf, Mi

    count = 1;

    for M = 1:degree + 1 % M 的最小值是 1，最大值是 degree+1
        % M is the degree of the base triangle
        for Mi = max(M, 1):degree % Mi 的最小值是 M，最大值是 degree
            % Mi is the degree of the opposite triangle
            if (degree == M + Mi - 2)
                % if M + Mi - 2 = degree, then M, Mf and Mi can form a tetrahedron
                for Mf = M:Mi
                    % Mf is the degree of the other triangle
                    M_and_Mf_and_Mi(count, :) = [M, Mf, Mi];
                    count = count + 1;
                end
            end
        end
    end

    if count > 1
        M_and_Mf_and_Mi = M_and_Mf_and_Mi(1:count - 1, :);
    else
        M_and_Mf_and_Mi = [];
    end
end
