classdef FreeDStack < handle
% A stack object as managed by the Free-D software.
%
%   Class FreeDStack
%
%   Example
%   FreeDStack
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2014-03-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2014 INRA - Cepia Software Platform.


%% Properties
properties
    % The name of this stack
    Name;

    % The set of slices
    Slices;
    
    % the set of models
    Models;
    
    % A comment associated to the stack
    Annotation;

    ImagesPath;

    LengthUnitScale = 0;
    PixelAspect = 1;
    PixelWidth = 1;
    RelPosition = 1;
    LastSegmentedSlice;
    LastRegisteredSlice;
    AbsoluteImagesPathPolicy

    % for display of the stack (boolean)
    InvertZAxis = false;
    
% Some features not yet managed
%     float _defaultSliceThickness; 
%     float _defaultSliceSpacing;   //!< Espacement par défaut des coupes
%     PixelCalibration _defaultPixelCalibration; //! Calibration par défaut des images
%     vector<StandardImage*> _standards;

end % end properties


%% Constructor
methods
    function obj = FreeDStack(varargin)
    % Constructor for FreeDStack class

    end

end % end constructors


%% Methods
methods
    function slice = getSlice(obj, sliceName)
        % Returns a slice in the stack from its name
        for i = 1:length(obj.Slices)
            if strcmp(sliceName, obj.Slices(i).Name)
                slice = obj.Slices(i);
                return;
            end
        end
        error('Stack "%s" does not contain any slice with name "%d"', ...
            obj.Name, sliceName);
    end
    
    function model = getModel(obj, modelName)
        % Returns a model in the stack from its name
        for i = 1:length(obj.Models)
            if strcmp(modelName, obj.Models(i).Name)
                model = obj.Models(i);
                return;
            end
        end
        error('Stack "%s" does not contain any model with name "%d"', ...
            obj.Name, modelName);
    end
    
end % end methods

end % end classdef

