function gini_Index = giniIndex_s(totalSampleSize, eachSampleSetSize, eachSampleSetAimFeatrueVauleCount, varargin)
    %GiniIndex_s Compute the Gini index of a given distribution
    %   Inputs:
    %       totalSampleSize: The total sample size of the distribution.
    %       eachSampleSetSize: A vector containing the sample size of each subset.
    %       eachSampleSetAimFeatrueVauleCount: A vector containing the count of each value of the target feature in each subset.
    %       'aix': The index of the axis to sum over. (default: 1)
    %           1: Compute the Gini index of each row
    %           2: Compute the Gini index of each column
    %   Outputs:
    %       gini_Index: The Gini index of the distribution.

    arguments
        totalSampleSize {mustBeScalarOrEmpty, mustBeInteger, mustBePositive}
        eachSampleSetSize {mustBeNonnegative}
        eachSampleSetAimFeatrueVauleCount {mustBeNonnegative}
    end

    arguments (Repeating)
        varargin
    end

    ip = inputParser;
    addParameter(ip, 'aix', 1, @isreal);
    parse(ip, varargin{:});
    aix = ip.Results.aix;

    % Check if the sum of eachSampleSetSize is equal to totalSampleSize
    if totalSampleSize ~= sum(eachSampleSetSize, "all")
        error("The sum of 'eachSampleSetSize' must be equal to 'totalSampleSize'")
    end

    % Check if aix is 1 or 2
    if aix ~= 1 && aix ~= 2
        error('aix must be 1 or 2');
    end

    % Check if the sum of eachSampleSetAimFeatrueVauleCount is equal to totalSampleSize
    temp = sum(eachSampleSetAimFeatrueVauleCount, aix);

    if size(temp) ~= size(eachSampleSetSize)
        error("As a vector, the size of 'eachSampleSetAimFeatrueVauleCount' must be equal to 'eachSampleSetSize'")
    end

    if temp ~= totalSampleSize
        error("The sum of 'eachSampleSetAimFeatrueVauleCount' must be equal to 'eachSampleSetSize'")
    end

    delete temp

    len = length(eachSampleSetSize);
    giniVec = zeros(size(eachSampleSetSize));

    % Calculate the Gini index for the aimFeature of each subset
    for i = 1:len
        giniVec(i) = giniIndex(eachSampleSetSize(i), eachSampleSetAimFeatrueVauleCount(i), 'aix', aix);
    end

    gini_Index = sum(giniVec .* eachSampleSetSize ./ totalSampleSize, "all");
end
