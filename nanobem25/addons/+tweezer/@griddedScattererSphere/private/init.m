function obj = init( obj, scatterer, r, varargin )
%  INIT - Initialize force interpolator for spherical scatterer.
%
%  Usage for obj = tweezer.griddedScattererSphere :
%    obj = init( obj, scatterer, r, PropertyPairs )
%  Input
%    scatterer    -  optical scatterer
%    r            -  radii for interpolation
%  PropertyName
%    z            -  z-values for interpolation
%    lmax         -  maximal order for azimuthal Fourier expansion
%    fun          -  additional function for gridding

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'z', [] );
addParameter( p, 'lmax', 2 );
addParameter( p, 'fun', {} );
%  parse input
parse( p, varargin{ : } );

obj.scatterer = scatterer;
obj.r = r;
obj.lmax = p.Results.lmax;
obj.fun = p.Results.fun;
%  make sure that function is a cell array
if ~iscell( obj.fun ),  obj.fun = { obj.fun };  end

%  table of spherical orders
obj.ltab = - p.Results.lmax : p.Results.lmax;
%  quadrature points for azimuthal direction
m = 2 * fix( ( 2 * obj.lmax + 1 ) / 2 ) + 1;
obj.u = 2 * pi * ( 0 : m - 1 ) / m;
%  grid positions
switch numel( p.Results.z )
  case { 0, 1 }
    [ u, r ] = ndgrid( obj.u, obj.r );
    [ x, y ] = pol2cart( u( : ), r( : ) );
    obj.pos = [ x, y ];
  otherwise
    [ u, r, z ] = ndgrid( obj.u, obj.r, p.Results.z );
    [ x, y, z ] = pol2cart( u( : ), r( : ), z( : ) );
    obj.pos = [ x, y, z ];
end

%  evaluate force grid ?
if ~isempty( p.Results.z ),  obj = eval( obj, p.Results.z );  end
