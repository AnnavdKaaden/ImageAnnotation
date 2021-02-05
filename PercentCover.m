%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function calculates the percentage that a certain     %
% class covers in a picture ('Cover'). The class is          %
% previously defined by the user, it can be a species or %
% a group of species. It also gives presence/absence ('PA')  %
% data, where a '1' means 'present' and a '0' means 'absent' %
%                                                            %
% Input required into the function are 1) the label colours  %
% which are defined by 3-digit vectors. So, 'Labels' is a    %
% matrix of size nx3, where n is the number of labels. The   %
% type is RGB colours, ranging from 0 to 255. It should be   %
% constructed manually using the Labels psd-file.            %
% Example: Labels = [255,255,255; 0,255,240; 252,0,255; etc] %
%                                                            %
% And 2) the file name, which is a character string. File    %
% type is png24 or tif. Type jpg is not preferable.          %
% Example: Filename = 'ROV_Dive12_Layer18_Label.tif'         %
%                                                            %
% A. van der Kaaden, May 2019.                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Cover, PA] = PercentCover(Labels, Filename)

% Read in the image to a matrix
IMG = imread(Filename);
% Convert the uint type to double type
IMG = double(IMG);
% Size of the image- and Labels-matrices
SizeI = size(IMG);
SizeL = size(Labels);

% Create empty Cover-matrix
Cover = zeros(SizeL(1),1);

% For all classes in the matrix 'Labels', do:
for class = 1:SizeL(1)
    % Check which rows from 'Labels' also appear in the image
    Pixels_in_class = ismember(reshape(IMG,[],3),Labels(class,:),'rows');
    % Calculate the percentage of pixels in that class
    Cover(class) = 100*(sum(Pixels_in_class)/(SizeI(1)*SizeI(2)));
end

% Calculate presence/absence, based on the fact that all classes for which
% cover>0 are present and otherwise they are absent. 
PA = Cover>0;

end