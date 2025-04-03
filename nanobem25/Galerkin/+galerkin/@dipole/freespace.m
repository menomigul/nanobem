function P0 = freespace( obj, k0 )
%  FREESPACE - Dissipated power of free-space dipole.
%
%  Usage for obj = galerkin.dipole :
%    P0 = freespace( obj, k0 )
%  Input
%    k0     :  wavenumber of light in vacuum
%  Output
%    P0     :  dissipated power of isolated dipole

%  material properties
eps = arrayfun( @( x ) x.eps( k0 ), obj.pt( 1 ).mat, 'uniform', 1 );
n   = arrayfun( @( x ) x.  n( k0 ), obj.pt( 1 ).mat, 'uniform', 1 );
%  dissipated power of isolated dipoles
P0 = n .^ 3 ./ eps * k0 ^ 4 / ( 12 * pi );
P0 = P0( horzcat( obj.pt.imat ) );
