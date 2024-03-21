function out_cell = cellTranspose(input_cell, value)

    % If input_cell is a scalar, just return it
    if(numel(input_cell) == 1)
        out_cell = input_cell;
        return;
    end

    % Transpose the input cell based on value
    out_cell = cellfun(@(x){x.'}, input_cell, 'UniformOutput', false).';
end

