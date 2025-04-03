function d = wignerd( obj, rot )
%  WIGNERD - Rotation matrix for spherical harmonics.
%
%  Usage for obj = multipole.base :
%    d = wignerd( obj, rot )
%  Input
%    rot    :  rotation matrix of size 3×3 or 3×3×n
%  Output
%    d      :  rotation matrix for spherical harmonics of size m×m or m×m×n
%  Literature
%    https://en.wikipedia.org/wiki/Wigner_D-matrix

%  convert from rotation matrix to angles, use ZYZ sequence
a = reshape( atan2( rot( 2, 3, : ), + rot( 1, 3, : ) ), 1, [] );
c = reshape( atan2( rot( 3, 2, : ), - rot( 3, 1, : ) ), 1, [] );
b = reshape( acos(  rot( 3, 3, : ) ), 1, [] );

%  allocate output
tab = obj.tab;
d = zeros( numel( tab.l ), numel( tab.l ), numel( a ) );
%  factorials
nmax = 4 * obj.lmax;
ftab = [ 1, cumprod( 1 : nmax ) ];
factorial = @( n ) ftab( n + 1 );
%  trigonometric functions
n = reshape( 0 : nmax, [], 1 );
stab = sin( 0.5 * b ) .^ n;  sinb = @( n ) stab( n + 1, : );
ctab = cos( 0.5 * b ) .^ n;  cosb = @( n ) ctab( n + 1, : );

%  loop over angular degrees
for l = 1 : obj.lmax
  %  grid of angular orders
  [ m1, m2 ] = ndgrid( tab.m( tab.l == l ) );
  [ m1, m2 ] = deal( m1( : ), m2( : ) );
  %  summation variable
  s = repmat( 0 : 2 * l, numel( m1 ), 1 );
  ind = s >= max( 0, - m1 + m2 ) & s <= min( l - m1, l + m2 );
  %  factorials
  n1 =  l - m1 - s;
  n2 =  l + m2 - s;
  n3 = m1 - m2 + s;
  fac = zeros( size( s ) );
  fac( ind ) = 1 ./ ( factorial( n1( ind ) ) .* factorial( n2( ind ) ) .*  ...
                      factorial( n3( ind ) ) .* factorial(  s( ind ) ) );
  %  powers
  n1 =   m1 - m2 + s;
  n2 = - m1 + m2 - 2 * s + 2 * l;
  n3 =   m1 - m2 + 2 * s;
  %  perform summation
  s = zeros( [ numel( s ), numel( a ) ] );
  s( ind, : ) = fac( ind ) .*  ...
    ( - 1 ) .^ n1( ind ) .* cosb( n2( ind ) ) .* sinb( n3( ind ) );
  s = squeeze( sum( reshape( s, size( ind, 1 ), size( ind, 2 ), [] ), 2 ) );
  %  multiply with remaining factorials and Euler angles
  fac = sqrt( factorial( l + m1 ) .* factorial( l - m1 ) .*  ...
              factorial( l + m2 ) .* factorial( l - m2 ) );
  s = fac( : ) .* exp( 1i * ( m1 * a + m2 * c ) ) .* s;
  s = reshape( s, 2 * l + 1, 2 * l + 1, [] );
  %  set output
  ind = tab.l == l;
  d( ind, ind, : ) = s;
end


% %  quadrature points and weights
% quad = quadsph( obj, 'vector' );
% tab = obj.tab;
% %  angles for original and rotated spherical harmonics
% [ u1, t1 ] = deal( quad.u, quad.t );
% pos = [ cos( u1 ) .* sin( t1 ), sin( u1 ) .* sin( t1 ), cos( t1 ) ];
% pos = pagemtimes( pos, rot );
% [ u2, t2 ] = cart2sph( pos( :, 1, : ), pos( :, 2, : ), pos( :, 3, : ) );
% t2 = 0.5 * pi - t2;
% 
% %  spherical harmonics
% y1 = spharm( tab.l, tab.m, t1, u1 );
% y2 = spharm( tab.l, tab.m, t2, u2 );
% y2 = reshape( y2, size( y1, 1 ), size( y1, 2 ), [] );
% %  perform integration
% d = pagemtimes( y1 .* quad.w .', permute( conj( y2 ), [ 2, 1, 3 ] ) );
% d( abs( d ) < 1e-8 ) = 0;
