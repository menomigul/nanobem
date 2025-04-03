function trans = translation( obj, shift, varargin )
%  TRANSLATION - Translation matrices for shift along z.
%
%  Usage for obj = multipole.base :
%    trans = translation( obj, x, PropertyPairs )
%  Input
%    shift  :  shift vector (k × pos)
%  PropertyName
%    fun    :  'j' for Bessel or 'h' for Hankel function
%    z      :  translate matrices along positive or negative z-direction
%    full   :  return full matrix compatible with full T-matrices
%  Output
%    trans  :  translation matrices
%                M' = M * trans.A + N * trans.B
%                N' = N * trans.A - M * trans.B
%  Literature
%    Bruning and Lo, IEEE Trans. Antennas and Prop. AP-19, 378 (1971).

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'fun', 'j' );
addParameter( p, 'z', [] );
addParameter( p, 'full', 0 );
%  parse input
parse( p, varargin{ : } );

%  length and angles of shift vectors
[ u, t, x ] = cart2sph( shift( :, 1 ), shift( :, 2 ), shift( :, 3 ) );
t = 0.5 * pi - t;
x = reshape( x, 1, [] );
x( x < 1e-10 ) = 1e-10;
%  allocate output
[ nx, tab ] = deal( numel( x ), obj.tab );
[ trans.A, trans.B ] = deal( zeros( numel( tab.l ), numel( tab.l ), nx ) );

%  factorials and double-factorials
nmax = 4 * obj.lmax;
ftab1 = arrayfun( @( n ) prod( n : -1 : 1 ), 0 : nmax, 'uniform', 1 );
ftab2 = arrayfun( @( n ) prod( n : -2 : 1 ), 0 : nmax, 'uniform', 1 );
fac1 = @( n ) reshape( ftab1( n + 1 ), [], 1 );
fac2 = @( n ) reshape( ftab2( n + 1 ), [], 1 );
%  spherical Bessel or Hankel functions
n = reshape( 0 : nmax, [], 1 );
ztab = riccatibessel( n, x, p.Results.fun ); 
z = @( n ) ztab( n + 1, : );

for M = reshape( unique( tab.m ), 1, [] )

  %  table of spherical degrees
  [ l1, l2 ] = ndgrid( tab.l( tab.m == M ) );
  [ l1, l2 ] = deal( l1( : ), l2( : ) );
  %  loop index p1 and allocate output
  p1 = l1 + l2;
  it = 1;
  [ A, B ] = deal( zeros( numel( l1 ), numel( x ) ) );
  
  while any( p1 >= abs( l1 - l2 ) )
    %  summation only over selected elements  
    ind = p1 >= abs( l1 - l2 );
    [ L1, L2, P ] = deal( l1( ind ), l2( ind ), p1( ind ) ); 
    
    %  recursion relation, Eq. (26-28)
    switch it
      case 1
        r1 = fac2( 2 * L1 - 1 ) .* fac2( 2 * L2 - 1 ) ./ fac2( 2 * L1 + 2 * L2 - 1 );
        r2 = fac1( L1 + L2 ) ./ ( fac1( L1 - M ) .* fac1( L2 + M ) );
        a = r1 .* r2;
      case 2
        a2 = a;
        r1 = ( 2 * L1 + 2 * L2 - 3 ) ./  ...
           ( ( 2 * L1 - 1 ) .* ( 2 * L2 - 1 ) .* ( L1 + L2 ) );
        r2 = ( L1 .* L2 - M ^ 2 * ( 2 * L1 + 2 * L2 - 1 ) );
        a( ind ) = r1 .* r2 .* a2( ind );
      otherwise
        [ a4, a2 ] = deal( a2, a );
        fun = @( P ) ( ( L1 + L2 + 1 ) .^ 2 - P .^ 2 ) .*  ...
                 ( P .^ 2 - ( L1 - L2 ) .^ 2 ) ./ ( 4 * P .^ 2 - 1 );
        r1 = fun( P + 2 ) + fun( P + 3 ) - 4 * M ^ 2;
        a( ind ) = ( r1 .* a2( ind ) - fun( P + 4 ) .* a4( ind ) ) ./ fun( P + 1 );
    end
    
    %  update coefficients, Eq. (23) 
    r1 = ( - 1i ) .^ P .* ( L1 .* ( L1 + 1 ) + L2 .* ( L2 + 1 ) - P .* ( P + 1 ) );
    r2 = ( - 1i ) .^ P * ( - 2i * M );
    A( ind, : ) = A( ind, : ) + r1 .* a( ind ) .* z( P );
    B( ind, : ) = B( ind, : ) + r2 .* a( ind ) .* z( P ) .* x;
    %  update summation index and iterator
    p1 = p1 - 2;
    it = it + 1;
  end
  
  %  reversed translation ?
  if ~isempty( p.Results.z ) && p.Results.z == -1
    A =   ( -1 ) .^ ( l1 + l2 ) .* A;
    B = - ( -1 ) .^ ( l1 + l2 ) .* B;
  end
  %  index to translation coefficients
  i1 = tab.m == M;
  n1 = nnz( i1 );
  %  set translation coefficients, Eq. (23)
  r = ( - 1 ) ^ M .* 1i .^ ( l2 - l1 ) .*  ...
                            ( 2 * l2 + 1 ) ./ ( 2 * l2 .* ( l2 + 1 ) );                          
  trans.A( i1, i1, : ) = reshape( r .* A, n1, n1, [] );
  trans.B( i1, i1, : ) = reshape( r .* B, n1, n1, [] );
end

%  missing prefactor of multipole fields, Eq. (5,6)
[ l, m ] = deal( tab.l, tab.m );
fac = sqrt( ( 2 * l + 1 ) / ( 4 * pi ) .* fac1( l - m ) ./  ...
                                          fac1( l + m ) ) ./ sqrt( l .* ( l + 1 ) );
%  correct for different prefactor
fac = fac ./ transpose( fac );
trans.A =      reshape( reshape( trans.A, [], nx ) .* fac( : ), size( trans.A ) );
trans.B = 1i * reshape( reshape( trans.B, [], nx ) .* fac( : ), size( trans.B ) );                                        

%  additional rotation ?
if isempty( p.Results.z )
  %  Wigner matrix for rotation
  rot = multipole.rotation( [ -t, -u ], 'order', 'yz', 'angle', 'rad' );
  d = wignerd( obj, rot ); 
  %  rotate translation vector
  trans.A = pagemtimes( pagemtimes( d, trans.A ), 'none', d, 'ctranspose' );
  trans.B = pagemtimes( pagemtimes( d, trans.B ), 'none', d, 'ctranspose' );
end
%  return full matrix
if p.Results.full
  trans = cat( 1, cat( 2, trans.A, trans.B ), cat( 2, - trans.B, trans.A ) );
end
