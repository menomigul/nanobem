function obj = resize( obj, lmax )
%  RESIZE - Resize incoming multipole elements.
%
%  Usage for obj = multipole.incoming :
%    obj = rescale( obj, lmax )
%  Input
%    lmax     :  maximal degree of spherical harmonics

if lmax ~= obj.lmax
  %  index to selected elements
  tab = obj.tab;
  [ obj.tab.l, obj.tab.m ] = sphtable( lmax );
  ind = tab.l <= min( max( tab.l ), lmax );
  %  resize T-matrix
  siz = size( obj.a );
  siz( 1 ) = numel( obj.tab.l );
  t = zeros( siz );
  for name = [ "a", "b" ]
    t( ind, : ) = obj.( name )( ind, : );
    obj.( name ) = reshape( t, siz );
  end
end
