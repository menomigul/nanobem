function [ e, h ] = fields( obj, q, pos )
%  FIELDS - Scattered electromagnetic fields.
%
%  Usage for obj = multipole.miesolver :
%    [ e, h ] = fields( obj, qinc, pos )
%  Input
%    q    :  Mie coefficients for incoming fields
%    pos  :  positions where fields are evaluated
%  Output
%    e    :  scattered electric field
%    h    :  scattered magnetic field

%  Mie coefficients
k0 = q.k0;
[ a, b, c, d ] = miecoefficients( obj, k0, obj.tab.l );
%  scattered Mie coefficients
a = - a .* q.a;  
b = - b .* q.b;
c =   c .* q.a;
d =   d .* q.b;

%  material parameters
[ k1, Z1 ] = deal( obj.mat1.k( k0 ), obj.mat1.Z( k0 ) );
[ k2, Z2 ] = deal( obj.mat2.k( k0 ), obj.mat2.Z( k0 ) );
%  allocate output
[ e, h ] = deal( zeros( size( pos, 1 ), 3, size( a, 2 ) ) );
  
%  index to positions inside and outside of sphere
r = sqrt( dot( pos, pos, 2 ) );
ind1 = r <  0.5 * obj.diameter;  
ind2 = r >= 0.5 * obj.diameter;

%  fields inside of sphere
if nnz( ind1 )
  %  convert to spherical coordinates
  [ u, t, r ] = cart2sph( pos( ind1, 1 ), pos( ind1, 2 ), pos( ind1, 3 ) );
  t = 0.5 * pi - t;
  %  Bessel function and vector spherical harmonics
  r( r < 1e-10 ) = 1e-10;
  x = r * k1;
  [ z, zp ] = riccatibessel( obj.tab.l, x, 'j' );
  [ xm, xe, x0 ] = vsh( obj.tab.l, obj.tab.m, t, u );
  %  electromagnetic fields
  [ e( ind1, :, : ), h( ind1, :, : ) ] = fun( obj, x, Z1, z, zp, xm, xe, x0, c, d );
end
  
%  fields outside of sphere 
if nnz( ind2 )
  %  convert to spherical coordinates
  [ u, t, r ] = cart2sph( pos( ind2, 1 ), pos( ind2, 2 ), pos( ind2, 3 ) );
  t = 0.5 * pi - t;
  %  Bessel function and vector spherical harmonics
  x = r * k2;
  [ z, zp ] = riccatibessel( obj.tab.l, x, 'h' ); 
  [ xm, xe, x0 ] = vsh( obj.tab.l, obj.tab.m, t, u );
  %  electromagnetic fields
  [ e( ind2, :, : ), h( ind2, :, : ) ] = fun( obj, x, Z2, z, zp, xm, xe, x0, a, b );
end


function [ e, h ] = fun( obj, x, Z, z, zp, xm, xe, x0, a, b )
%  FUN - Electromagnetic fields

%  dummy indices for tensor class
[ i, j, k, m ] = deal( 1, 2, 3, 4 );
%  convert positions and radial functions to tensor class
x = tensor( x, i );
z = tensor(  z,  [ m, i ] );
zp = tensor( zp, [ m, i ] );
%  prefactor
fac = tensor( sqrt( obj.tab.l .* ( obj.tab.l + 1 ) ), m );
xm = tensor( xm, [ m, i, k ] );
xe = tensor( xe, [ m, i, k ] );
x0 = tensor( x0, [ m, i, k ] );
%  Mie coefficients
a = tensor( a, [ m, j ] );
b = tensor( b, [ m, j ] );

%  expansion functions
M = z * xm;
N = - ( fac * z * x0 + zp * xe ) ./ x;
%  electromagnetic fields
e = ( b * M + a * N ) * Z;
h = ( a * M - b * N );

%  convert to numeric
e = double( sum( e, m ), [ i, k, j ] );
h = double( sum( h, m ), [ i, k, j ] );
  