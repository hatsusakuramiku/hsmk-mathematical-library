function [gain, gainRatio] = gain(totalSampleSize, aimFeatureEntropy, eachSampleSetSIze, eachSampleSetAimFeatrueEntropy, varargin)
    %GAIN 计算信息增益
    %   输入参数:
    %   totalSampleSize: 整个数据集的样本数
    %   aimFeatureEntropy: 目标特征在整个数据集中的熵
    %   eachSampleSetSIze: 每个划分出的子集中的样本数
    %   eachSampleSetAimFeatrueEntropy: 目标特征在每个划分出的子集中的熵
    %
    %   可选参数:
    %   'ratio':一个布尔值，指示是否计算增益率（默认值：true）
    %
    %   输出参数:
    %   gain:信息增益
    %   gainRatio:增益率
    %
    %   使用示例:
    %   gain = gain(totalSampleSize, eachFeatureSampleSize, eachFeatureSampleEntropy)
    %   [gain, gainRatio] = gain(totalSampleSize, eachFeatureSampleSize, eachFeatureSampleEntropy)

    arguments
        totalSampleSize {mustBeScalarOrEmpty, mustBeInteger, mustBePositive}
        aimFeatureEntropy {mustBeScalarOrEmpty, mustBeReal, mustBeNonnegative}
        eachSampleSetSIze {mustBeNonnegative}
        eachSampleSetAimFeatrueEntropy {mustBeReal, mustBeNonnegative}
    end

    arguments (Repeating)
        varargin
    end

    p = inputParser;
    addParameter(p, 'ratio', true, @islogical);
    parse(p, varargin{:});
    ratio = p.Results.ratio;

    if totalSampleSize ~= sum(eachSampleSetSIze, "all")
        error('The sum of eachFeatureSampleSize must be equal to totalSampleSize');
    end

    if size(eachSampleSetAimFeatrueEntropy) ~= size(eachSampleSetSIze)
        error('eachFeatureSampleEntropy and eachFeatureSampleSize must have the same size');
    end

    gain = aimFeatureEntropy - sum(eachSampleSetSIze .* eachSampleSetAimFeatrueEntropy ./ totalSampleSize, "all");

    if ratio
        gainRatio = gain ./ entropy(eachSampleSetSIze ./ totalSampleSize);
    else
        gainRatio = [];
    end

end
