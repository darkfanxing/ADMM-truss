function [Z] = initialize_Z(node_number, m)
    Z = zeros(node_number, m);
    count = 2;
    
    for node_index = 1:node_number - 1
        Z( ...
            node_index, ...
            (count - 1):(count + node_number - node_index - 2) ...
        ) = 1;
        
        for row_index = node_index:node_number-1
            Z( ...
                row_index + 1, ...
                count + row_index - node_index - 1 ...
            ) = 1;
        end
        
        count = count + node_number - node_index;
    end

    Z = sparse(Z);
end