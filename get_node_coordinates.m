function [node_coordinates] = get_node_coordinates(N_X, N_Y)
    node_number_x = N_X + 1;
    node_number_y = N_Y + 1;
    x = kron(1:node_number_x, repmat([1], node_number_y, 1));
    x = reshape(x', size(x(:)));
    y = repmat(1:node_number_y, node_number_x, 1);
    y = reshape(y, size(y(:)));
    node_coordinates = [x y];
end