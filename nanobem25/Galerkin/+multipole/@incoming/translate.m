function obj = translate( obj, shift, varargin )
%  TRANSLATE - Translate origin for incoming multipoles.
%
%  Usage for obj = multipole.incoming :
%    obj = translate( obj, shift, PropertyPairs )
%  Input
%    shift   :  shift of size 1×3 or n×3
%  PropertyName
%    same   :  leading dimensions of multipole coefficients match n

%  translation matrix
x = obj.mat.k( obj.k0 ) * shift;
M = translation( obj, x, varargin{ : } );
%  shift multipole coefficients
fun = @( M, x ) multiply( obj, M, x, varargin{ : } );
[ obj.a, obj.b ] = deal( fun( M.A, obj.a ) + fun( M.B, obj.b ),  ...
                         fun( M.A, obj.b ) - fun( M.B, obj.a ) );
