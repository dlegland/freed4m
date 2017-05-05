classdef FreeDStack < handle
%FREEDSTACK A stack object as managed by the Free-D software
%
%   Class FreeDStack
%
%   Example
%   FreeDStack
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
    % the name of  this stack
    name;

    % the set of slices
    slices;
    
    % the set of models
    models;
    
    annotation;

    imagesPath;

    lengthUnitScale = 0;
    pixelAspect = 1;
    pixelWidth = 1;
    relPosition = 1;
    lastSegmentedSlice;
    lastRegisteredSlice;
    absoluteImagesPathPolicy

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
    function this = FreeDStack(varargin)
    % Constructor for FreeDStack class

    end

end % end constructors


%% Methods
methods
    function slice = getSlice(this, sliceName)
        % Returns a slice in the stack from its name
        for i = 1:length(this.slices)
            if strcmp(sliceName, this.slices(i).name)
                slice = this.slices(i);
                return;
            end
        end
        error('Stack "%s" does not contain any slice with name "%d"', ...
            this.name, sliceName);
    end
    
    function model = getModel(this, modelName)
        % Returns a model in the stack from its name
        for i = 1:length(this.models)
            if strcmp(modelName, this.models(i).name)
                model = this.models(i);
                return;
            end
        end
        error('Stack "%s" does not contain any model with name "%d"', ...
            this.name, modelName);
    end
    
end % end methods

end % end classdef

