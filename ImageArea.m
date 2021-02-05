%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function calculates the true image area, based on the distance    %
% between two laser dots in an image.                                    %
% The input required is the colour for the Laser-label (an rgb-triplet,  %
% e.g. [0, 18, 255]), the Filename, e.g. 'Dive12_Layer1_Label.tif', and  %
% the true Distance between the laser dots in meters, e.g. 0.1 m.        %
%                                                                        %
% Anna van der Kaaden, May 2019                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ImSize] = ImageArea(Laserlabel, Filename, Distance)

% Read in the image to a matrix
IMG = imread(Filename);
% Convert the uint type to double type
IMG = double(IMG);
% Size of the image
SizeI = size(IMG);

% Identify all the pixels that belong to the laser dots
Laserpixels = ismember(reshape(IMG,[],3),Laserlabel,'rows');
% Reshape the matrix with the identified pixels to the image-shape
Laserpixels = reshape(Laserpixels,SizeI(1),SizeI(2));

% Get the coordinates of the laserpixels
[x,y] = find(Laserpixels);
% Create the empty matrix to store all the distances
Distances = zeros(size(x,1));
% Calculate all the Euclidean distances between the pixels
for i = 1:size(x,1)
    Distances(i,:) = sqrt((x-x(i)).^2) + sqrt((y-y(i)).^2);
end
% Get the maximum distance
maxDist = max(Distances(:));

% The image scale is:
Scale = Distance/maxDist;
% True image size is:
ImSize = SizeI(1)*Scale*SizeI(2)*Scale; % in m2

end