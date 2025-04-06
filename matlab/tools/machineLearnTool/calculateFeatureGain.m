function gainTable = calculateFeatureGain(dataTable, featrueNameArr, aimAttributeName)
    %CALCULATEFEATUREGAIN  Calculate the information gain of each feature attribute in the data table
    %   gainTable = calculateFeatureGain(dataTable, featrueNameArr, aimAttributeName)
    %   Calculate the information gain of each feature attribute in the data table
    %   Inputs:
    %       dataTable: the data table
    %       featrueNameArr: the names of feature attributes
    %       aimAttributeName: the name of the target attribute
    %   Outputs:
    %       gainTable: a table contains the names of feature attributes, the information gain and the gain ratio
    %

    len = length(featrueNameArr);
    dataTableLen = height(dataTable);
    gainTable = table('VariableNames', {'FeatureName', 'Gain', 'GainRatio'}, 'Size', [len, 3], 'VariableTypes', {'string', 'double', 'double'}); % Calculate the information gain of each feature attribute in the data table
    aimAttributeEntorpy = caculateTableEntory(dataTable, aimAttributeName);

    for i = 1:length(featrueNameArr)
        featrueTableArr = splitData(dataTable, featrueNameArr{i});
        fTAlen = length(featrueTableArr);
        entropyArr = zeros(1, fTAlen);
        heightArr = zeros(1, fTAlen);

        for j = 1:fTAlen
            entropyArr(j) = caculateTableEntory(featrueTableArr{j}, aimAttributeName);
            heightArr(j) = height(featrueTableArr{j});
        end

        [gain_, gainRatio] = gain(dataTableLen, aimAttributeEntorpy, heightArr, entropyArr);

        gainTable.FeatureName{i} = featrueNameArr{i};
        gainTable.Gain(i) = gain_;
        gainTable.GainRatio(i) = gainRatio;
    end

end

function featrueTableArr = splitData(dataTable, featrueName)
    %SPLITDATA Split the data table into sub tables based on the values of the feature attribute
    %   featrueTableArr = splitData(dataTable, featrueName)
    %   Split the data table into sub tables based on the values of the feature attribute
    %   Inputs:
    %       dataTable: the data table
    %       featrueName: the name of the feature attribute
    %   Outputs:
    %       featrueTableArr: an array of sub tables

    uniqueValue = unique(dataTable.(featrueName));
    len = length(uniqueValue);
    featrueTableArr = cell(len, 1);

    for i = 1:len
        featrueTableArr{i} = dataTable(dataTable.(featrueName) == uniqueValue(i), :);
    end

end

function tabbleEntorpy = caculateTableEntory(dataTable, aimAttributeName)
    %CACULATETABLENTORY Calculate the entropy of the data table
    %   tabbleEntorpy = caculateTableEntory(dataTable, aimAttributeName)
    %   Calculate the entropy of the data table
    %   Inputs:
    %       dataTable: the data table
    %       aimAttributeName: the name of the target attribute
    %   Outputs:
    %       tabbleEntorpy: the entropy of the data table

    aimAttributeValues = unique(dataTable.(aimAttributeName));
    len = length(aimAttributeValues);
    tableHeight = height(dataTable);
    temp = zeros(1, len);

    for i = 1:len
        temp(i) = height(dataTable(dataTable.(aimAttributeName) == aimAttributeValues(i), :)) / tableHeight;
    end

    tabbleEntorpy = entropy(temp);
end
