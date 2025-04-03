function pot = stokespotential( particle, varargin )
%  STOKESPOTENTIAL - Potentials for Stokes flow around a particle.
%
%  Usage :
%    pot = tweezer.stokespotential( particle, PropertyPairs )
%  Input
%    particle   :  discretized particle boundary
%  PropertyName
%    rules      :  default quadrature rules
%  Output
%    pot        :  Stokes potential
%  Literature
%    H. Power and G. Miranda, SIAM J. Appl. Math. 47, 689 (1987).

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'quad', triquad( 11 ) );
%  parse input
parse( p, varargin{ : } );

%  centroid positions, areas, and normal vector of boundary elememts
[ pos, area, nvec ] = norm( particle );
r = vecnorm( pos, 2, 2 );
%  triangle integration points
quad = p.Results.quad;
xi = [ quad.x; quad.y; 1 - quad.x - quad.y ];
%  number of boundary elements and quadrature points
[ n, m ] = deal( numel( area ), numel( quad.w ) );

%  integration points
verts = permute( reshape( particle.verts( particle.faces, : ), n, 3, 3 ), [ 1, 3, 2 ] );
pos2 = permute( reshape( reshape( verts, [], 3 ) * xi, n, 3, m ), [ 1, 3, 2 ] );
pos2 = reshape( pos2, n * m, 3 );
%  distance between positions and inner product, fifth power
r5 = pdist2( pos, pos2 ) .^ 5;
nvec = repmat( nvec, m, 1 );
in = pos * nvec .' - dot( pos2, nvec, 2 ) .';

%  prefactors and allocate output
[ fac1, fac2 ] = deal( - 3 / ( 4 * pi ), 1 / ( 8 * pi ) );
pot = zeros( n, 3, n, 3 );
%  integration function
w = reshape( area * quad.w, 1, n * m );
fun = @( x ) reshape( sum( reshape( x .* w, [], m ), 2 ), n, n );
%  single-layer potential, diagonal term
b = fac2 * fun( 1 ./ r - ( pos * pos2 .' ) ./ r .^ 3 );

%  loop over Cartesian coordinates
for i = 1 : 3
for j = 1 : 3
  %  double-layer potential, set diagonal elements to zero
  A = fac1 * fun( ( pos( :, i ) - pos2( :, i ) .' ) .*  ...
                  ( pos( :, j ) - pos2( :, j ) .' ) .* in ./ r5 );
  A( logical( eye( n ) ) ) = 0;
  A = A - diag( sum( A, 2 ) );
  %  single-layer potential
  B = fac2 * fun( pos( :, j ) .* ( pos( :, i ) + pos2( :, i ) .' ) ./ r .^ 3 );
  if i == j,  B = B + b;  end
  %  set potential
  pot( :, i, :, j ) = A + B;
end
end
