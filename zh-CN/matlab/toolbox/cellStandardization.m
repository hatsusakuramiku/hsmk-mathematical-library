% cellStandardization standardizes the lengths of cells to a common length.
%
% Given an input cell array, and a target length, this function returns a new
% cell array where every cell is padded with zeros to the target length.
% If a cell is already longer than the target length, it is truncated.
%
% @param inputCell Cell array to standardize.
% @param lens Desired length of each cell.
% @return Standardized cell array.
function result = cellStandardization(inputCell, lens)

    % Create a cell array of size 1xlens, where each element is an array of
    % zeros.
    result = cellfun(@(x) zeros(1, lens), cell(1, lens), 'UniformOutput', false);

    % For each cell in the input cell array, assign it to the corresponding
    % position in the result cell array, truncating or padding as needed.
    for j = 1:length(inputCell)
        result{j} = inputCell{j};
    end

end
