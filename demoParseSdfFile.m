%DEMOPARSESDFFILE  One-line description here, please.
%
%   output = demoParseSdfFile(input)
%
%   Example
%   demoParseSdfFile
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2014-03-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2014 INRA - Cepia Software Platform.


rootDir = fullfile('d:', 'images', 'versailles', 'katia', 'racineIP');
col0Dir = fullfile(rootDir, 'col0', 'temoinTrm7andCo');
fileName = fullfile(col0Dir, 'sdf', 'col0.sdf');

stack = parseSdfFile(fileName);


disp(stack);

