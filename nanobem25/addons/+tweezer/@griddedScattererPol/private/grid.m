function y = grid( obj, x )
%  GRID - Transform data for gridding.
%
%  Usage for obj = tweezer.griddedScattererPol :
%    y = grid( obj, x )
%  Input
%    x    :  data for gridding
%  Output
%    y    :  gridded data

%  Fourier transform data along azimuthal direction 
n1 = numel( obj.ltab );
y = exp( - 1i * obj.ltab( : ) * obj.u ) * reshape( x, numel( obj.u ), [] );
y = y / n1;

%  bring rotation degrees of freedom to front
[ n2, n3 ] = deal( numel( obj.r ) * numel( obj.z ), numel( obj.tmat ) );
y = permute( reshape( y, n1, n2, n3, [] ), [ 3, 1, 2, 4 ] );
%  spherical harmonics transform
base = multipole.base( obj.lmax( end ) );
quad = quadsph( base, 'vector' );
[ l, m ] = deal( [ 0; base.tab.l ], [ 0; base.tab.m ] );
y = conj( spharm( l, m, quad.t, quad.u ) ) * ( quad.w( : ) .* reshape( y, n3, [] ) );
%  push back rotation degrees
y = permute( reshape( y, numel( l ), n1, n2, [] ), [ 2, 3, 1, 4 ] );
