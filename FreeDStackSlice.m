classdef FreeDStackSlice < handle
% A StackSlice in a Free-D stack model.
%
%   A StackSlice corresponds to a 2D slice within a 3D stack stored as a
%   single tif file.
%
%   Example
%   FreeDStackSlice
%
%   See also
%     FreeDStack, FreeDSlice, FreeDModel
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2014-03-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2014 INRA - Cepia Software Platform.


%% Properties
properties
    % the name of the slice
    Name;
    
    % the name of the file that contains the image
    ImageFileName;
    
    % the index of the slice within the 3D image 
    SliceIndex;
    
    % an instance of image
    Image;
    
    RelPosition;
    
    Annotation;
    
    PixelCalibration;
    
    % number of pixels in x and y directions, or [0 0] if not initialized
    Size = [0 0];
    
    % a list of model items for obj slice
    Items = [];
    
    % if registration was performed, contains two fields ROTATE and SHIFT
    Shift = [0 0];
    Rotate = 0;
    
end % end properties


%% Constructor
methods
    function obj = FreeDStackSlice(varargin)
    % Constructor for FreeDSlice class

    end

end % end constructors


%% Model items management
methods
    function addItem(obj, item)
        if ~isa(item, 'FreeDModelItem')
            error('item must be an instance of FreeDModelItem');
        end
        obj.Items = [obj.Items item];
    end
    
end % end methods

end % end classdef

