function [ Q, n ] = polquad( obj, k0, m, key )
%  POLQUAD - Evaluate integrals of JQSRT 123, 153 (2013).
%
%  Usage for obj = multipole.polsolver :
%    [ Q, n ] = polquad( obj, k0, m, key )
%  Input 
%    k0     :  wavenumber of light in vacuum
%    m      :  angular orders
%    key    :  spherical Bessel 'j' or Hankel 'h' functions
%  Output
%    Q      :  auxiliary matrices
%    n      :  angular degrees

%  wavenumbers in media
k1 = obj.mat2.k( k0 );
k2 = obj.mat1.k( k0 );
%  ratio of inside and outside wavenumber
s = k2 / k1;
%  outer product of angular degrees 
n = obj.tab.l( obj.tab.m == m );
[ i1, i2 ] = ndgrid( 1 : numel( n ) );
[ n1, n2 ] = deal( reshape( n( i1 ), [], 1 ) , reshape( n( i2 ), [], 1 ) );

%  quadrature points
[ x, w ] = lgwt( obj.nquad, -1, 1 );
t = reshape( acos( x ), 1, [] );
%  size parameter and derivative
eta = 1e-4;
x1 = k1 * obj.rad( t );
x1t = k1 * ( obj.rad( t + 0.5 * eta ) - obj.rad( t - 0.5 * eta ) ) / eta;
%  Riccati-Bessel functions at particle outside
[ xi, xip ]  = arrayfun( @( x ) riccatibessel( n, x, key ), x1, 'uniform', 0 );
[ xi, xip ] = deal( x1 .* horzcat( xi{ : } ), horzcat( xip{ : } ) );
%  Riccati-Bessel functions at particle outside
[ psi, psip ]  = arrayfun( @( x ) riccatibessel( n, x, 'j' ), s * x1, 'uniform', 0 );
[ psi, psip ] = deal( s * x1 .* horzcat( psi{ : } ), horzcat( psip{ : } ) );
%  Wigner d-function, proportional to associated Legendre polynomial
fac = ( -1 ) ^ m * sqrt( 4 * pi ./ ( 2 * n + 1 ) );
d = fac .* spharm( n, 0 * n + m, t, 0 * t );
tau = fac .* ( spharm( n, 0 * n + m, t + 0.5 * eta, 0 * t ) -  ...
               spharm( n, 0 * n + m, t - 0.5 * eta, 0 * t ) ) / eta;
pit = m * d ./ sin( t );

%  perform integration, Eqs. (11-14)
K1 = pit( i1, : ) .* d( i2, : ) .* x1t .* xi ( i1, : ) .* psip( i2, : ) * w;
K2 = pit( i1, : ) .* d( i2, : ) .* x1t .* xip( i1, : ) .* psi ( i2, : ) * w;
L1 = tau( i1, : ) .* d( i2, : ) .* x1t .* xi ( i1, : ) .* psi ( i2, : ) * w;
L2 = tau( i2, : ) .* d( i1, : ) .* x1t .* xi ( i1, : ) .* psi ( i2, : ) * w;
%  Eqs. (21,22)
z1 = xip( i1, : ) .* psip( i2, : );
z2 = xi ( i1, : ) .* psi ( i2, : ) ./ ( s * x1 .^ 2 );
L7 = tau( i1, : ) .* d( i2, : ) .* x1t .* ( z1 + n1 .* ( n1 + 1 ) .* z2 ) * w;
L8 = tau( i2, : ) .* d( i1, : ) .* x1t .* ( z1 + n2 .* ( n2 + 1 ) .* z2 ) * w;
%  Eqs. (18,20)
L5 = n1 .* ( n1 + 1 ) .* L2 - n2 .* ( n2 + 1 ) .* L1;
L6 = n1 .* ( n1 + 1 ) .* L8 - n2 .* ( n2 + 1 ) .* L7;

%  Eqs. (15,16)
A1 = sqrt( ( 2 * n1 + 1 ) ./ ( 2 * n1 .* ( n1 + 1 ) ) );  
A2 = sqrt( ( 2 * n2 + 1 ) ./ ( 2 * n2 .* ( n2 + 1 ) ) );
Q{ 1, 2 } = reshape( A1 .* A2 .* K1 * ( s ^ 2 - 1 ) / s, size( i1 ) );
Q{ 2, 1 } = reshape( A1 .* A2 .* K2 * ( 1 - s ^ 2 ) / s, size( i1 ) );
%  Eqs. (17,19)
fac = 1 ./ ( n1 .* ( n1 + 1 ) - n2 .* ( n2 + 1 ) );
fac( isinf( fac ) ) = 0;
Q{ 1, 1 } = 1i * ( s ^ 2 - 1 ) / s * reshape( fac .* A1 .* A2 .* L5, size( i1 ) );
Q{ 2, 2 } = 1i * ( s ^ 2 - 1 ) / s * reshape( fac .* A1 .* A2 .* L6, size( i1 ) );

%  diagonal elements, Eqs. (25-27)
L1 = ( pit .^ 2 + tau .^ 2 ) .* (     xip .* psi - s * xi .* psip ) * w;
L2 = ( pit .^ 2 + tau .^ 2 ) .* ( s * xip .* psi -     xi .* psip ) * w;
L3 = tau .* d .* x1t .* xi .* psi ./ ( s * x1 .^ 2 ) * w;
%  Eqs. (23,24)
A = sqrt( ( 2 * n + 1 ) ./ ( 2 * n .* ( n + 1 ) ) );
Q{ 1, 1 } = Q{ 1, 1 } - 1i / s * diag( A .^ 2 .* L1 );
Q{ 2, 2 } = Q{ 2, 2 } - 1i / s *  ...
  diag( A .^ 2 .* ( L2 + ( s ^ 2 - 1 ) * n .* ( n + 1 ) .* L3 ) );
