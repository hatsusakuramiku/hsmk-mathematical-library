function result = standardization(data)
    [row, ~] = size(data);
    minmax_vec = minmax(data');

    for i = 1:row
        data(i, :) = (data(i, :) - minmax_vec(i, 1)) ./ (minmax_vec(i, 2) - minmax_vec(i, 1));
    end

    result = data;
end
