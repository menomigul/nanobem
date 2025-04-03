function obj = translate( obj, shift, varargin )
%  TRANSLATE - Translate origin for T-matrix.
%
%  Usage for obj = multipole.tmatrix :
%    obj = translate( obj, shift, PropertyPairs )
%  Input
%    shift        :  translation vector

%  shift vector (k × pos)
x = obj.solver.embedding.k( obj.k0 ) * shift;
%  translation matrices
base = multipole.base( obj.lmax );
trans = translation( base, x, 'full', 1, varargin{ : } );
n = 0.5 * size( trans, 1 );
%  translate T-matrix
t = repmat( full( obj ), 1, 1, size( shift, 1 ) );
t = pagemtimes( pagemtimes( trans, 'ctranspose', t, 'none' ), trans );
t = mat2cell( t, [ n, n ], [ n, n ], ones( 1, size( shift, 1 ) ) );

%  set output
obj = repelem( obj, 1, size( shift, 1 ) );
%  loop over shift vectors
for it = 1 : size( shift, 1 )
  obj( it ).aa = t{ 1, 1, it };
  obj( it ).ab = t{ 1, 2, it };
  obj( it ).ba = t{ 2, 1, it };
  obj( it ).bb = t{ 2, 2, it };
end
