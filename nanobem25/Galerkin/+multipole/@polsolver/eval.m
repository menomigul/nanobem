function t = eval( obj, k0 )
%  EVAL - Multipole coefficients for Mie theoty.
%
%  Usage for obj = multipole.polsolver :
%    t = eval( k0 )
%  Input
%    k0   :  wavenumber of light in vacuum
%  Output
%    t    :  T-matrix or multipole coefficients

%  table of spherical degrees and orders
tab = obj.tab;
%  initialize T-matrix
t = multipole.tmatrix( obj, k0 );
[ t.aa, t.ab, t.ba, t.bb ] = deal( zeros( numel( tab.l ) ) );

%  loop over angular orders
for m = 0 : max( tab.m )
  %  P,Q matrices, see Sec 2.1 of JQSRT 123, 153 (2013)
  [ P, l ] = polquad( obj, k0, m, 'j' );
  [ Q, ~ ] = polquad( obj, k0, m, 'h' );
  %  compute T-matrix, Eq. (7)
  n = numel( l );
  T = - [ P{ 1, 1 }, P{ 1, 2 }; P{ 2, 1 }, P{ 2, 2 } ] /   ...
        [ Q{ 1, 1 }, Q{ 1, 2 }; Q{ 2, 1 }, Q{ 2, 2 } ];
  T = mat2cell( T, [ n, n ], [ n, n ] );
  %  set T-matrix elements
  [ ~, i1 ] = ismember( [ m + 0 * l, l ], [ tab.m, tab.l ], 'rows' );
  t.aa( i1, i1 ) = T{ 1, 1 };
  t.ab( i1, i1 ) = T{ 1, 2 };
  t.ba( i1, i1 ) = T{ 2, 1 };
  t.bb( i1, i1 ) = T{ 2, 2 };
  %  use symmetry for remaining elements, Eq. (9)
  [ ~, i2 ] = ismember( [ - m + 0 * l, l ], [ tab.m, tab.l ], 'rows' );
  t.aa( i2, i2 ) =   T{ 1, 1 };
  t.ab( i2, i2 ) = - T{ 1, 2 };
  t.ba( i2, i2 ) = - T{ 2, 1 };
  t.bb( i2, i2 ) =   T{ 2, 2 };  
end

%  different definitions between JQSRT 123, 153 (2013) and nanobem
[ t.aa, t.ab, t.ba, t.bb ] = deal( t.bb, - 1i * t.ba, 1i * t.ab, t.aa );
