function obj = init( obj, scatterer, r, varargin )
%  INIT - Initialize force interpolator for scatterer with polar symmetry.
%
%  Usage for obj = tweezer.griddedScattererPol :
%    obj = init( obj, scatterer, r, PropertyPairs )
%  Input
%    scatterer    -  optical scatterer
%    r            -  radii for interpolation
%  PropertyName
%    z            -  z-values for interpolation
%    lmax         -  maximal order for azimuthal Fourier and multipole expansion
%    fun          -  additional function for gridding

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'z', [] );
addParameter( p, 'lmax', [ 2, 2 ] );
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
obj.ltab = - p.Results.lmax( 1 ) : p.Results.lmax( 1 );
%  quadrature points for azimuthal direction
m = 2 * fix( ( 2 * obj.lmax( 1 ) + 1 ) / 2 ) + 1;
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

%  quadrature points for angular degrees
quad = quadsph( multipole.base( p.Results.lmax( end ) ), 'vector' );
% %  rotate T-matrices 
rot = multipole.rotation( [ quad.t, quad.u ], 'order', 'yz', 'angle', 'rad' );
rot = mat2cell( rot, 3, 3, ones( 1 , size( rot, 3 ) ) );
obj.tmat = cellfun( @( rot ) rotate( scatterer.tmat, rot ), rot, 'uniform', 1 );

%  evaluate force grid ?
if ~isempty( p.Results.z ),  obj = eval( obj, p.Results.z );  end
