function stack = parseSdfFile(fileName)
%PARSESDFFILE Read a Stack Data File from a sdf file
%
%   output = parseSdfFile(input)
%
%   Example
%   parseSdfFile
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2014-03-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2014 INRA - Cepia Software Platform.

f = fopen(fileName, 'rt');
if f < 0
    error(['Could not open the file: ' fileName]);
end

% create the new stack;
stack = FreeDStack();
stack.Slices = [];
stack.Models = [];

currentSlice = [];
currentModel = [];
currentModelItem = [];

relPos = 0;

while true
    % extract current keyword, and the rest of tokens
    [keyword, tokens] = readNextItem(f);
    if isempty(keyword)
        break;
    end

    % parse the tokens depending on the keyword
    switch lower(keyword)
        
        % Stack keywords
        
        case lower('FileFormatVersion')
        case lower('Stack')
            stack.Name = tokens{1};
            
        case lower('LengthUnitScale')
            stack.LengthUnitScale = parseValue(tokens);
        case lower('PixAspect')
            stack.PixelAspect = parseValue(tokens);
        case lower('PixWidth')
            stack.PixelWidth = parseValue(tokens);
        case lower('LastSegmentedSlice')
            stack.LastSegmentedSlice = tokens{1};
        case lower('LastRegisteredSlice') 
            stack.LastRegisteredSlice = tokens{1};
        case lower('AbsoluteImagesPathPolicy') 
            stack.AbsoluteImagesPathPolicy = parseBoolean(tokens);
        case lower('InvertZAxis') 
            stack.InvertZAxis = parseBoolean(tokens);
 
        case lower('RelPosition')
            relPos = str2double(tokens{1});
            if isempty(currentSlice)
                stack.RelPosition = relPos;
            else
                currentSlice.RelPosition = relPos;
            end

        case lower('ImagesPath')
            stack.ImagesPath = tokens{1};
        
        case lower('Annotation')
            stack.Annotation = tokens{1};

            
        % Slice keywords

        case lower('Slice')
            currentSlice = FreeDSlice();
            currentSlice.Name = tokens{1};
            currentSlice.ImageFileName = tokens{2};
            
            % choose default position for current slice
            relPos = relPos + 1;
            currentSlice.RelPosition = relPos;

            stack.Slices = [stack.Slices ; currentSlice];

        case lower('StackSlice')
            currentSlice = FreeDStackSlice();
            currentSlice.Name = tokens{1};
            currentSlice.ImageFileName = tokens{2};
            pos = parseValue(tokens(3));
            currentSlice.SliceIndex = pos;
            
            % choose default position for current slice
            currentSlice.RelPosition = pos;

            stack.Slices = [stack.Slices ; currentSlice];

        case lower('SliceSize1')
            currentSlice.Size(1) = parseValue(tokens);
        case lower('SliceSize2')
            currentSlice.Size(2) = parseValue(tokens);
        case lower('Shift')
            currentSlice.Shift = parseArray(tokens);
        case lower('Rotate')
            currentSlice.Rotate = parseValue(tokens);
            
        % model keywords

        case lower('Model')
            currentModel = FreeDModel();
            currentModel.Name = tokens{1};
            stack.Models = [stack.Models ; currentModel];
            
            
        case lower('Brilliancy')
            currentModel.Brilliancy = parseValue(tokens);
            
        case lower('Color')
            currentModel.Color = parseColor(tokens);

        case lower('EcoRendering')
            currentModel.EcoRendering = parseBoolean(tokens);

        case lower('FilledIn')
            currentModel.FilledIn = parseBoolean(tokens);

        case lower('Hidden3d')
            currentModel.Hidden3d = parseBoolean(tokens);

        case lower('PointSize')
            currentModel.PointSize = parseValue(tokens);

        case lower('Primitive')
            currentModel.Primitive = tokens{1};

        case lower('RenderingMode')
            currentModel.RenderingMode = tokens{1};

        case lower('Resampling')
            currentModel.Resampling = parseArray(tokens);

        case lower('MeshVertexSmoothing')
            currentModel.MeshVertexSmoothing = parseValue(tokens);

        case lower('MeshNormalSmoothing')
            currentModel.MeshNormalSmoothing = parseValue(tokens);

        case lower('Thickness')
            currentModel.Thickness = parseValue(tokens);

        case lower('Transparency')
            currentModel.Transparency = parseValue(tokens);

        case lower('VertexSymbol')
            currentModel.VertexSymbol = tokens{1};

        case lower('BeginCap')
            currentModel.BeginCap = parseBoolean(tokens);

        case lower('EndCap')
            currentModel.EndCap = parseBoolean(tokens);

            
        % Model Item keywords

        case lower('ModelItem')
            model = getModel(stack, tokens{1});
            slice = getSlice(stack, tokens{2});
           	currentModelItem = FreeDModelItem(model, slice);
            
            
        case lower('ModelItemData')
            data = parseCoordinates(tokens);
            currentModelItem.Data = data;

            
        otherwise
            warning('freed:parseSdfFile', ...
                ['Unknown SDF Stack token: ' keyword]);
    end
    
end

fclose(f);

    function [keyWord, tokens] = readNextItem(f)
        % read the next keyword and parse remaining tokens until final ';'

        keyWord = [];
        tokens = {};

        wholeLine = fgetl(f);
        if ~ischar(wholeLine)
            return;
        end
        
        wholeLine = strtrim(wholeLine);
        while isempty(wholeLine) || wholeLine(end) ~= ';'
            line = fgetl(f);
            if ~ischar(line)
                wholeLine = [wholeLine ';']; %#ok<AGROW>
                break;
            end
            
            wholeLine = [wholeLine ' ' strtrim(line)]; %#ok<AGROW>
        end
        wholeLine(end) = [];
        
        [keyWord, remain] = strtok(wholeLine);
        
        tokens = {};
        while ~isempty(remain)
            remain = strtrim(remain);
            if remain(1) == '"'
                inds = find(remain == '"');
                token = remain(inds(1)+1:inds(2)-1);
                remain = remain(inds(2)+1:end);
            else
                [token, remain] = strtok(remain); %#ok<STTOK>
            end
            
            tokens = [tokens {token}]; %#ok<AGROW>
        end
        
    end

    function value = parseValue(tokens)
        % parses a single value, given in the first token
        value = str2double(tokens{1});
    end

    function rgb = parseColor(tokens)
        % Parses a color, given as three tokens
        %
        % returns a 1-by-3 array of double
        
        if length(tokens) < 3
            error('not enough tokens');
        end
        r = str2double(tokens{1});
        g = str2double(tokens{2});
        b = str2double(tokens{3});
        rgb = [r g b];
    end

    function values = parseArray(tokens)
        % Parses an array of value, given as an array of tokens
        %
        % returns an array of double
       
        nv = length(tokens);
        values = zeros(1, nv);
        for i = 1:nv
            values(i) = str2double(tokens{i});
        end
    end

    function b = parseBoolean(tokens)
        % Parses a boolean value, given either as 'true' or 'false' 
        %
        % returns a boolean.
       
        if strcmpi(tokens{1}, 'true')
            b = true;
        elseif strcmpi(tokens{1}, 'false')
            b = false;
        else
            error(['Could not parse boolean: ' tokens{1}]);
        end
    end

    function data = parseCoordinates(tokens)
        % parses a coordinate array, given as space separated pairs of
        % coordinates
        nv = length(tokens);
        data = zeros(nv, 2);
        for i = 1:nv
            [tok1, tok2] = strtok(tokens{i}, ',');
            data(i, 1) = str2double(tok1);
            data(i, 2) = str2double(tok2);
        end
    end

%     function str = parseString(baseString)
%         inds = find(baseString(1:end-1) == '"');
%         if length(inds) < 2
%             error('freed:parseSdfFile', 'missing string terminator');
%         end
%         str = baseString(inds(1)+1:inds(2)-1);
%     end
% 
%     function [str1 str2] = parseTwoStrings(baseString)
%         inds = find(baseString(1:end-1) == '"');
%         if length(inds) < 4
%             error('freed:parseSdfFile', 'missing string terminator');
%         end
%         str1 = baseString(inds(1)+1:inds(2)-1);
%         str2 = baseString(inds(3)+1:inds(4)-1);
%     end


end
