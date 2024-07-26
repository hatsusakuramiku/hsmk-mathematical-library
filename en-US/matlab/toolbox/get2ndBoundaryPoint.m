function matrix = get2ndBoundaryPoint(xrange, gamma, phi, psi, tStep, tNum, more)
    narginchk(6, 7);
    if nargin == 7
        tNum = tNum + more;
    end
    vector_1 = func(phi, [tStep / 2, tStep:tStep:(tNum - 1) * tStep]);
    vector_2 = func(psi, [tStep / 2, tStep:tStep:(tNum - 1) * tStep]);
    matrix = zeros(tNum + 1, 2);
    matrix(1, 1) = func(gamma, xrange(1));
    matrix(1, 2) = func(gamma, xrange(2));
    matrix(2, 1) = tStep * func(phi, vector_1(1)) + matrix(1, 1);
    matrix(2, 2) = tStep * func(psi, vector_2(1)) + matrix(1, 2);

    for i = 3:1:tNum + 1
        matrix(i, 1) = 2 * tStep * func(phi, vector_1(i - 1)) + matrix(i - 1, 1);
        matrix(i, 2) = 2 * tStep * func(psi, vector_2(i - 1)) + matrix(i - 1, 2);
    end

end
