function giniIndex = giniIndex(totalSampleSize, aimFeatrueEachValueCount, varargin)
    %Gini index
    %   Compute the Gini index of a given distribution.
    %
    %   Inputs:
    %       totalSampleSize: The total sample size of the distribution.
    %       aimFeatrueEachValueCount: A vector containing the count of each value of the
    %           target feature.
    %       'aix': The index of the axis to sum over. (default: 0)
    %           0: Compute the Gini index of the entire distribution
    %           1: Compute the Gini index of each row
    %           2: Compute the Gini index of each column
    %
    %   Outputs:
    %       giniIndex: The Gini index of the distribution.

    arguments
        totalSampleSize {mustBeScalarOrEmpty, mustBeInteger, mustBePositive}
        aimFeatrueEachValueCount {mustBeNonnegative}
    end

    arguments (Repeating)
        varargin
    end

    ip = inputParser;
    addParameter(ip, 'aix', 0, @isreal);
    parse(ip, varargin{:});
    aix = ip.Results.aix;

    if aix == 0

        % Check if the sum of aimFeatrueEachValueCount is equal to totalSampleSize
        if sum(aimFeatrueEachValueCount, "all") ~= totalSampleSize
            error("The sum of aimFeatrueEachValueCount must be equal to totalSampleSize")
        end

        % Compute the Gini index
        giniIndex = 1 - sum((aimFeatrueEachValueCount ./ totalSampleSize) .^ 2, "all");
    elseif aix == 1 || aix == 2
        % Check if the sum of aimFeatrueEachValueCount is equal to totalSampleSize
        if sum(aimFeatrueEachValueCount, "all") ~= totalSampleSize
            error("The sum of aimFeatrueEachValueCount must be equal to totalSampleSize")
        end

        % Compute the Gini index
        giniIndex = 1 - sum((aimFeatrueEachValueCount ./ totalSampleSize) .^ 2, aix);
    else
        error('aix must be 0, 1, or 2');
    end

end
