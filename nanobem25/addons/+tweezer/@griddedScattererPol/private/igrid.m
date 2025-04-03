function x = igrid( obj, y, pos, rot )
%  IGRID - Interpolate gridded data.
%
%  Usage for obj = tweezer.griddedScattererPol :
%    x = igrid( obj, y, pos )
%  Input
%    y    :  gridded data
%    pos  :  requested positions for interpolation
%    rot  :  requested rotation matrices for interpolation
%  Output
%    x    :  interpolated data

%  convert positions to polar coordinates
[ u, r, z ] = cart2pol( pos( :, 1 ), pos( :, 2 ), pos( :, 3 ) );
% number of grid dimensions
[ n1, nr, nz ] = deal( numel( obj.ltab ), numel( obj.r ), numel( obj.z ) );

%  perform interpolation
switch nz
  case 1
    %  interpolation of r-values
    y = permute( reshape( y, n1, nr, [] ), [ 2, 1, 3 ] );
    y = interp1( obj.r, y, r, obj.method, obj.extrapolation );
  otherwise
    %  permute dimensions to y(r,z,ltab,:)
    y = permute( reshape( y, n1, nr, nz, [] ), [ 2, 3, 1, 4 ] );
    y = reshape( y, nr, nz, [] );
    %  interpolation of rz-values   
    fun = @( it ) interpn(  ...
      obj.r, obj.z, y( :, :, it ), r, z, obj.method, obj.extrapolation );
    y = arrayfun( fun, 1 : size( y, 3 ), 'uniform', 0 );
    y = horzcat( y{ : } ); 
end

%  perform inverse Fourier transform
fac = exp( 1i * u( : ) * obj.ltab );
x = reshape( y, numel( fac ), [] ) .* fac( : );
x = sum( reshape( x, size( pos, 1 ), numel( obj.ltab ), [] ), 2 );

%  extract rotation angles from rotation matrix
dir = squeeze( pagemtimes( rot, [ 0; 0; 1 ] ) ) .';
[ u, t ] = cart2sph( dir( :, 1 ), dir( :, 2 ), dir( :, 3 ) );
[ u, t ] = deal( pi + u, 0.5 * pi - t );
%  spherical harmonics evaluation
[ l, m ] = sphtable( obj.lmax( end ) );
[ l, m ] = deal( [ 0; l ], [ 0; m ] );
y = transpose( spharm( l, m, t, u ) );
x = reshape( x, size( pos, 1 ) * numel( l ), [] ) .* y( : );
x = sum( reshape( x, size( pos, 1 ), numel( l ), [] ), 2 );
%  avoid rounding errors
x = real( squeeze( x ) );
if numel( x ) == 3,  x = reshape( x, 1, 3 );  end
