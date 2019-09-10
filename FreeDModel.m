classdef FreeDModel < handle
% A 3D model (geometry) in a Free-D stack.
%
%   Class FreeDModel
%
%   Example
%   FreeDModel
%
%   See also
%     FreeDStack
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2014-03-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2014 INRA - Cepia Software Platform.


%% Properties
properties
    Name;
    
    % the list of model items in each slice
    Items = [];
    
    Brilliancy = 32;
    Color  = [255 0 0];
    EcoRendering = false;
    FilledIn = true;
    Hidden3d = false;
    PointSize = 3;
    Primitive = 'polyline';
    RenderingMode = 'curve';
    Resampling  = [100 100];
    Thickness = 1;
    Transparency = 255;
    VertexSymbol = 'sphere';
end % end properties


%% Constructor
methods
    function obj = FreeDModel(varargin)
    % Constructor for FreeDModel class

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

