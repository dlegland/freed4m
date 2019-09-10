classdef FreeDModelItem < handle
% A ModemItem in a Free-D Stack.
%
%   A FreeDModelItem corresponds to the visible element of a FreeDModel
%   within a specific slice. 
%   It can be used to generate to 3D model corresponding to the FreeDModel.
%
%   Example
%   FreeDModelItem
%
%   See also
%     FreeDStack, FreeDModel
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2014-03-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2014 INRA - Cepia Software Platform.


%% Properties
properties
    % reference to the parent model
    Model;
    
    % reference to the slice that contains obj item
    Slice;
    
    % coordinates
    Data;
    
end % end properties


%% Constructor
methods
    function obj = FreeDModelItem(model, slice)
        % Constructor for FreeDModelItem class
        obj.Model = model;
        obj.Slice = slice;

        addItem(model, obj);
        addItem(slice, obj);
    end

end % end constructors


%% Methods
methods
end % end methods

end % end classdef

