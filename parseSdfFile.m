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
% e-mail: david.legland@grignon.inra.fr
% Created: 2014-03-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2014 INRA - Cepia Software Platform.

f = fopen(fileName, 'rt');
if f < 0
    error(['Could not open the file: ' fileName]);
end

% create the new stack;
stack = FreeDStack();
stack.slices = [];
stack.models = [];

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
        case lower('FileFormatVersion')
        case lower('Stack')
            stack.name = tokens{1};
            
        case lower('LengthUnitScale')
            stack.lengthUnitScale = parseValue(tokens);
        case lower('PixAspect')
            stack.pixelAspect = parseValue(tokens);
        case lower('PixWidth')
            stack.pixelWidth = parseValue(tokens);
        case lower('LastSegmentedSlice')
            stack.lastSegmentedSlice = tokens{1};
        case lower('LastRegisteredSlice') 
            stack.lastRegisteredSlice = tokens{1};
        case lower('AbsoluteImagesPathPolicy') 
            stack.absoluteImagesPathPolicy = parseBoolean(tokens);
        case lower('InvertZAxis') 
            stack.InvertZAxis = parseBoolean(tokens);
 
        case lower('RelPosition')
            relPos = str2double(tokens{1});
            if isempty(currentSlice)
                stack.relPosition = relPos;
            else
                currentSlice.relPosition = relPos;
            end

        case lower('ImagesPath')
            stack.imagesPath = tokens{1};
            
        case lower('Slice')
            currentSlice = FreeDSlice();
            currentSlice.name = tokens{1};
            currentSlice.imageFileName = tokens{2};
            
            % chosse default position for current slice
            relPos = relPos + 1;
            currentSlice.relPosition = relPos;

            stack.slices = [stack.slices ; currentSlice];

        case lower('SliceSize1')
            currentSlice.size(1) = parseValue(tokens);
        case lower('SliceSize2')
            currentSlice.size(2) = parseValue(tokens);
            
        case lower('Model')
            currentModel = FreeDModel();
            currentModel.name = tokens{1};
            stack.models = [stack.models ; currentModel];
            
        case lower('ModelItem')
            model = getModel(stack, tokens{1});
            slice = getSlice(stack, tokens{2});
           	currentModelItem = FreeDModelItem(model, slice);
            
            
        case lower('ModelItemData')
            data = parseCoordinates(tokens);
            currentModelItem.data = data;

            
        case lower('Annotation')

            
        case lower('Brilliancy')
            currentModel.brilliancy = parseValue(tokens);
            
        case lower('Color')
            currentModel.color = parseColor(tokens);

        case lower('EcoRendering')
            currentModel.ecoRendering = parseBoolean(tokens);

        case lower('FilledIn')
            currentModel.filledIn = parseBoolean(tokens);

        case lower('Hidden3d')
            currentModel.hidden3d = parseBoolean(tokens);

        case lower('PointSize')
            currentModel.pointSize = parseValue(tokens);

        case lower('Primitive')
            currentModel.primitive = tokens{1};

        case lower('RenderingMode')
            currentModel.renderingMode = tokens{1};

        case lower('Resampling')
            currentModel.resampling = parseArray(tokens);

        case lower('Thickness')
            currentModel.thickness = parseValue(tokens);

        case lower('Transparency')
            currentModel.transparency = parseValue(tokens);

        case lower('VertexSymbol')
            currentModel.vertexSymbol = tokens{1};


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
        value = str2double(tokens{1});
    end

    function rgb = parseColor(tokens)
        if length(tokens) < 3
            error('not enough tokens');
        end
        r = str2double(tokens{1});
        g = str2double(tokens{2});
        b = str2double(tokens{3});
        rgb = [r g b];
    end

    function values = parseArray(tokens)
        nv = length(tokens);
        values = zeros(1, nv);
        for i = 1:nv
            values(i) = str2double(tokens{i});
        end
    end

    function b = parseBoolean(tokens)
        if strcmpi(tokens{1}, 'true')
            b = true;
        elseif strcmpi(tokens{1}, 'false')
            b = false;
        else
            error(['Could not parse boolean: ' tokens{1}]);
        end
    end

    function data = parseCoordinates(tokens)
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
