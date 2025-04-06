function ent = entropy(p, varargin)
    %ENTROPY Compute the entropy of a probability distribution
    %   Inputs:
    %       p: A probability distribution, where each element is a non-negative
    %           real number and the sum of all elements is 1.
    %       'aix': The index of the axis to sum over. (default: 0)
    %           0: Compute the entropy of the entire distribution
    %           1: Compute the entropy of each row
    %           2: Compute the entropy of each column
    %   Outputs:
    %       ent: The entropy of the given probability distribution.
    %
    %   The entropy is a measure of the amount of uncertainty in the
    %   probability distribution. It is defined as the negative sum of the
    %   product of each probability and its logarithm base 2.
    %
    %   Example:
    %       p = [0.5 0.5];
    %       ent = entropy(p);
    %       % ent is 1
    ip = inputParser;
    addParameter(ip, 'aix', 0, @isreal);
    parse(ip, varargin{:});
    aix = ip.Results.aix;

    if any(p < 0)
        error('The input probability distribution must be non-negative');
    end

    % If probability is 0, set it to a small value to avoid log(0)
    p(p == 0) = eps;

    % Compute the entropy
    if aix == 0
        sum_temp = sum(p, "all");
        % Check if the input is a valid probability distribution
        if sum_temp - 1 > eps || sum_temp < 1 - eps
            error('The sum of the input probability distribution must be 1');
        end

        % Compute the entropy of the entire distribution
        ent = -sum(p .* log2(p), "all");

        return
    end

    if aix == 1 || aix == 2
        sum_temp = abs(sum(p, aix) - 1);
        % Check if the input is a valid probability distribution
        if any(sum_temp > eps)
            error('The sum of the input probability distribution must be 1');
        end

        % Compute the entropy of the entire distribution
        ent = -sum(p .* log2(p), aix);
        return
    else
        error('aix must be 0, 1, or 2');
    end

end
