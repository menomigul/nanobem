function obj = resize( obj, lmax )
%  RESIZE - Resize T-matrix.
%
%  Usage for obj = multipole.tmatrix :
%    obj = rescale( obj, lmax )
%  Input
%    lmax     :  maximal degree of spherical harmonics

switch numel( obj )
  case 1
    if lmax ~= obj.lmax
      %  index to selected elements
      tab = obj.tab;
      [ obj.tab.l, obj.tab.m ] = sphtable( lmax );
      ind = tab.l <= min( max( tab.l ), lmax );
      %  resize T-matrix
      t = zeros( numel( obj.tab.l ) );
      for name = [ "aa", "ab", "ba", "bb" ]
        t( ind, ind ) = obj.( name )( ind, ind );
        obj.( name ) = t;
      end
    end
  otherwise
    obj = arrayfun( @( x ) resize( x, lmax ), obj, 'uniform', 1 );
end
