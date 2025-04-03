function y = grid( obj, x )
%  GRID - Fourier transform data along azimuthal direction for gridding.
%
%  Usage for obj = tweezer.griddedScattererSphere :
%    y = grid( obj, x )
%  Input
%    x    :  data for gridding
%  Output
%    y    :  gridded data

y = exp( - 1i * obj.ltab( : ) * obj.u ) * reshape( x, numel( obj.u ), [] );
y = y / numel( obj.ltab );
