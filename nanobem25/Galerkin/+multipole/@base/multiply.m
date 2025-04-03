function x = multiply( ~, M, x, varargin )
%  Multiply - Multiply arrays.
%
%  Usage for obj = multipole.base :
%    x = multiply( obj, M, x, PropertyPairs )
%  Input
%    M      :  matrix of size n×n or n×n×m
%    x      :  array of size n×(siz) or n×m×siz
%  PropertyName
%    same   :  matching dimension m in M and x 

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'same', 0 );
%  parse input
parse( p, varargin{ : } );    

%  dimensions 
siz = size( x );
m = size( M, 3 );
%  perform multiplication
if ~p.Results.same
  switch m
    case 1
      x = reshape( M * reshape( x, siz( 1 ), [] ), siz );
    otherwise
     x =  pagemtimes( M, reshape( x, siz( 1 ), [] ) );
     x = reshape( permute( x, [ 1, 3, 2 ] ), [ siz( 1 ), m, siz( 2 : end ) ] );
  end
else
  x = reshape( pagemtimes( M, reshape( x, siz( 1 ), 1, [] ) ), siz );
end