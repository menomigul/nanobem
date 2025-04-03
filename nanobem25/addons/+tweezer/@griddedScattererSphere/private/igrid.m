function x = igrid( obj, y, pos )
%  IGRID - Interpolate gridded data.
%
%  Usage for obj = tweezer.griddedScattererSphere :
%    x = igrid( obj, y, pos )
%  Input
%    y    :  gridded data
%    pos  :  requested positions for interpolation
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
x = sum( reshape( x, numel( r ), numel( obj.ltab ), [] ), 2 );
%  avoid rounding errors
x = squeeze( real( x ) );
if numel( x ) == 3,  x = reshape( x, 1, 3 );  end
