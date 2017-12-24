function Mat = struct2mat(Struct, i, N)
% This function receives a structure of and a field index and convert it
% into a matrix.

% Struct = Structure
% i = Fiels number to be convereted into mat (The fiels must contain numbers)
% N = number of elements in the field

temp_cell = struct2cell(Struct);
temp_cell_i = temp_cell(i,:,:);
temp_cell_i = reshape(temp_cell_i, N,1);
Mat = cell2mat(temp_cell_i);