function obj = union( obj, shift, varargin )
%  UNION - Combine multiple T-matrices into single one.
%
%  Usage for obj = multipole.tmatrix :
%    obj = union( obj, shift, PropertyPairs )
%  Input
%    shift        :  translation vector
%  PropertyName
%    interaction  :  consider interaction between scatterers

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'interaction', 1 );
%  parse input
parse( p, varargin{ : } );

switch p.Results.interaction
  case 0
    %  no interaction, translate and combine T-matrices
    fun = @( obj, i ) translate( obj, shift( i, : ), varargin{ : } );
    obj = arrayfun( fun, obj, 1 : numel( obj ), 'uniform', 1 );
    for name = [ "aa", "ab", "ba", "bb" ]
    for i = 2 : numel( obj )
      obj( 1 ).( name ) = obj( 1 ).( name ) + obj( i ).( name ); 
    end
    end    
    
  case 1
    %  number of T-matrices and multipole elements
    [ m, n ] = deal( numel( obj ), numel( obj( 1 ).tab.l ) );
    %  wavenumber of light in embedding medium and multipole base
    k = obj( 1 ).embedding.k( obj.k0 );
    base = multipole.base( obj( 1 ).lmax );
    %  relative shift vectors
    [ i1, i2 ] = find( ~eye( m ) );
    x = k * ( shift( i1, : ) - shift( i2, : ) );
    
    %  translation matrices
    trans = translation( base, x, 'fun', 'h', 'full', 1 );
    %  off-diagonal elements of interaction matrix 
    t = cell( m );
    for it = 1 : numel( i1 )
      t{ i1( it ), i2( it ) } = - trans( :, :, it );
    end  
    %  diagonal elements of interaction matrix
    for it = 1 : m
      t{ it, it } = inv( full( obj( it ) ) );
    end
        
    %  translation matrix for multipoles
    trans = translation( base, k * shift, 'fun', 'j', 'full', 1 );
    trans = reshape( permute( trans, [ 1, 3, 2 ] ), [], 2 * n );
    %  solve for interacting system and translate multipoles
    t = trans' * ( cell2mat( t ) \ trans );
    
    %  update T-matrix
    t = mat2cell( t, [ n, n ], [ n, n ] );
    obj( 1 ).aa = t{ 1, 1 };  
    obj( 1 ).ab = t{ 1, 2 };
    obj( 1 ).ba = t{ 2, 1 };
    obj( 1 ).bb = t{ 2, 2 };
end

%  set output
obj = obj( 1 );
