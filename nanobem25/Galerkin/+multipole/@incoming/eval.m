function obj = eval( obj, varargin )
%  EVAL - Evaluate multipole coefficients for incoming fields.
%
%  Usage for obj = multipole.incoming :
%    obj = eval( obj, PropertyPairs )
%  PropertyName
%    shift    :  shift of coordinate system
%    rot      :  rotation matrix of coordinate system
%  Output
%    obj      :  incoming multipole coefficients a,b

%  table of angular degrees and orders, wavenumber of light in vacuum
[ tab, k0 ] = deal( obj.tab, obj.k0 );
%  quadrature points for azimuthal direction
lmax = obj.lmax;
n1 = 2 * fix( ( 2 * lmax + 1 ) / 2 ) + 1;
x1 = ( 0 : n1 - 1 ) / n1 * 2 * pi;
%  quadrature points and weights for polar direction
n2 = 2 * ( lmax + 2 );
[ x2, w2 ] = lgwt( n2, -1, 1 );
x2 = acos( x2 );

%  sphere radius and outer product
r = 0.5 * obj.diameter;
outer = @( y1, y2 ) reshape( y1, [], 1 ) * reshape( y2, 1, [] );
%  integration positions
pos = cat( 3, r * outer( cos( x1 ), sin( x2 ) ),  ...
              r * outer( sin( x1 ), sin( x2 ) ),  ...
              r * outer(   x1 .^ 0, cos( x2 ) ) );
%  incoming electromagnetic fields
[ e, h, siz ] = feval( obj, reshape( pos, [], 3 ), varargin{ : } );
n3 = prod( siz );
%  dot product with position vector
e = bsxfun( @times, reshape( e, [], n3 ), pos( : ) );
h = bsxfun( @times, reshape( h, [], n3 ), pos( : ) );
e = reshape( sum( reshape( e, [], 3, n3 ), 2 ), n1, [] );
h = reshape( sum( reshape( h, [], 3, n3 ), 2 ), n1, [] );

%  FFT for azimuthal angle
e = fftshift( fft( e, [], 1 ), 1 ) * 2 * pi / n1;
h = fftshift( fft( h, [], 1 ), 1 ) * 2 * pi / n1;
%  expand to angular degrees
[ ~, ind ] = ismember( tab.m, - fix( 0.5 * n1 ) : fix( 0.5 * n1 ) );
e = reshape( e( ind, : ), [], n3 );
h = reshape( h( ind, : ), [], n3 );
%  Legendre polynomials and prefactors
y = spharm( tab.l, tab.m, x2, 0 * x2 );
y = bsxfun( @times, y, reshape( w2, 1, [] ) );
y = bsxfun( @rdivide, y, sqrt( tab.l( : ) .* ( tab.l( : ) + 1 ) ) );
%  integration with Legendre polynomials
e = sum( reshape( bsxfun( @times, e, y( : ) ), [], n2, n3 ), 2 );
h = sum( reshape( bsxfun( @times, h, y( : ) ), [], n2, n3 ), 2 );

%  material parameters and Bessel function
mat = obj.mat;
[ k, Z ] = deal( mat.k( k0 ), mat.Z( k0 ) );
j = riccatibessel( tab.l, r * k, 'j' );
%  set output
obj.a = - bsxfun( @rdivide, squeeze( e ), j( : ) ) * k / Z;
obj.b =   bsxfun( @rdivide, squeeze( h ), j( : ) ) * k;
%  reshape output array
n = size( obj.a, 1 );
obj.a = reshape( obj.a, [ n, siz ] );
obj.b = reshape( obj.b, [ n, siz ] );
  