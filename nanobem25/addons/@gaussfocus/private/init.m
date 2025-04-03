function obj = init( obj, mat, varargin )
%  INIT - Initialize focused Gaussian with azimuthal polarization.
%
%  Usage :
%    obj = gaussfocus( mat, PropertyPairs )
%  Input
%    mat    :  material properties of embedding medium
%  PropertyName
%    w0     :  beam waist in focal plane
%    pow    :  laser power (W)

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'w0', [] );
addParameter( p, 'pow', 1 );
%  parse input
parse( p, varargin{ : } );

obj.mat = mat;
obj.w0 = p.Results.w0;
obj.pow = p.Results.pow;
