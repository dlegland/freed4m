classdef FreeDModelItem < handle
%FREEDMODELITEM  One-line description here, please.
%
%   Class FreeDModelItem
%
%   Example
%   FreeDModelItem
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
    % reference to the parent model
    model;
    
    % reference to the slice that contains this item
    slice;
    
    % coordinates
    data;
    
end % end properties


%% Constructor
methods
    function this = FreeDModelItem(model, slice)
        % Constructor for FreeDModelItem class
        this.model = model;
        this.slice = slice;

        model.addItem(this);
        slice.addItem(this);
    end

end % end constructors


%% Methods
methods
end % end methods

end % end classdef

