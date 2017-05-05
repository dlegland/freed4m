classdef FreeDSlice < handle
%FREEDSLICE  One-line description here, please.
%
%   Class FreeDSlice
%
%   Example
%   FreeDSlice
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2014-03-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2014 INRA - Cepia Software Platform.


%% Properties
properties
    % the name of the slice
    name;
    
    % the name of the file that contains the image
    imageFileName;
    
    % an instance of image
    image;
    
    relPosition;
    
    annotation;
    
    pixelCalibration;
    
    % a list of model items for this slice
    items = [];
    
end % end properties


%% Constructor
methods
    function this = FreeDSlice(varargin)
    % Constructor for FreeDSlice class

    end

end % end constructors


%% Model items management
methods
    function addItem(this, item)
        if ~isa(item, 'FreeDModelItem')
            error('item must be an instance of FreeDModelItem');
        end
        this.items = [this.items item];
    end
    
end % end methods

end % end classdef

