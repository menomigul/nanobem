function rot = rotation( t, varargin )
%  ROTATION - Rotation matrices for Euler angles.
%
%  Usage :
%    rot = multipole.rotation( t, PropertyPairs )
%  Input
%    t        :  Euler angles of size n×m, to be applied from left to right
%  PropertyName
%    axes     :  sequence of rotation axes of size 1×m, 'zxz' on default
%    angle    :  'rad' or 'deg' (default)
%    trans    :  transpose of matrix, 0 on default
%  Output
%    rot      :  rotation matrix of size 3×3×m

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'order', 'zxz' );
addParameter( p, 'angle', 'deg' );
addParameter( p, 'trans', 0 );
%  parse input
parse( p, varargin{ : } );

%  rotation angles
switch p.Results.angle
  case 'deg'
    [ sint, cost ] = deal( sind( t ), cosd( t ) );
  case 'rad'
    [ sint, cost ] = deal( sin( t ), cos( t ) );
end

%  allocate output
n = size( t, 1 );
r1 = arrayfun( @( ~ ) eye( 3 ), ones( n, 1 ), 'uniform', 0 );
%  loop over sequence of rotation axes
for it = 1 : size( t, 2 )
  r2 = arrayfun( @( s, c ) fun( s, c, p.Results.order( it ) ),  ...
                               sint( :, it ), cost( :, it ), 'uniform', 0 );
  r1 = cellfun( @( r1, r2 ) r2 * r1, r1, r2, 'uniform', 0 );
end
%  assemble final rotation matrix
rot = cat( 3, r1{ : } );

%  transpose of matrix ?
if p.Results.trans,  rot = permute( rot, [ 2, 1, 3 ] );  end



function rot = fun( s, c, dir )
%  FUN - Single rotation matrix.

switch dir
  case 'x'
    rot = [ 1, 0, 0; 0, c, -s; 0, s, c ];
  case 'y'
    rot = [ c, 0, -s; 0, 1, 0; s, 0, c ];
  case 'z'
    rot = [ c, -s, 0; s, c, 0; 0, 0, 1 ];
end
