classdef FreeDModel < handle
%FREEDMODEL  One-line description here, please.
%
%   Class FreeDModel
%
%   Example
%   FreeDModel
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
    name;
    
    % the list of model items in each slice
    items = [];
    
    brilliancy = 32;
    color  = [255 0 0];
    ecoRendering = false;
    filledIn = true;
    hidden3d = false;
    pointSize = 3;
    primitive = 'polyline';
    renderingMode = 'curve';
    resampling  = [100 100];
    thickness = 1;
    transparency = 255;
    vertexSymbol = 'sphere';
end % end properties


%% Constructor
methods
    function this = FreeDModel(varargin)
    % Constructor for FreeDModel class

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

