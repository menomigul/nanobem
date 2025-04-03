function drag = stokesdrag( particle, varargin )
%  STOKESDRAG - Drag tensor for Stokes flow around a particle.
%
%  Usage :
%    drag = tweezer.stokesdrag( particle, PropertyPairs )
%  Input
%    particle   :  discretized particle boundary
%  PropertyName
%    rules      :  default quadrature rules
%  Output
%    drag       :  drag tensor for translation and rotation

%  particle positions
[ pos, area ] = norm( particle );
[ x, y, z ] = deal( pos( :, 1 ), pos( :, 2 ), pos( :, 3 ) );
%  zero and one vectors
n = numel( x );
[ nul, one ] = deal( zeros( n, 1 ), ones( n, 1 ) );
%  inhomogeneities for unit flow and unit angular momentum
U = [ one, nul, nul; nul, one, nul; nul, nul, one ];
M = [ nul, z, -y; -z, nul, x; y, -x, nul ];

%  solve Stokes flow velocity
pot = reshape( tweezer.stokespotential( particle, varargin{ : } ), 3 * n, 3 * n );
u = - pot \ [ U, M ];
%  force and torque  <-->  translation and rotation
t = reshape( area' * reshape( u, n, [] ), 3, 6 );
r = - reshape( ( repmat( area, 3, 1 ) .* M ) .' * u, 3, 6 );
%  drag tensor
drag = struct( 'tt', t( :, 1 : 3 ), 'tr', t( :, 4 : 6 ),  ...
               'rt', r( :, 1 : 3 ), 'rr', r( :, 4 : 6 ) );

