function obj = rotate( obj, rot, varargin )
%  ROTATE - Rotate spherical multipoles.
%
%  Usage for obj = multipole.incoming :
%    obj = rotate( obj, rot, PropertyPairs )
%  Input
%    rot    :  rotation matrix of size 3×3 or 3×3×n
%  PropertyName
%    same   :  leading dimensions of multipole coefficients match n

%  Wigner matrix for rotation
d = wignerd( obj, permute( rot, [ 2, 1, 3 ] ) );
%  rotate multipole coefficients
obj.a = multiply( obj, conj( d ), obj.a, varargin{ : } );
obj.b = multiply( obj, conj( d ), obj.b, varargin{ : } );
