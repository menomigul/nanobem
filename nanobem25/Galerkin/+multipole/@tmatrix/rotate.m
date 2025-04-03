function obj = rotate( obj, rot )
%  ROTATE - Rotate T-matrix.
%
%  Usage for obj = multipole.tmatrix :
%    obj = rotate( obj, rot )
%  Input
%    rot  :  rotation matrix

%  rotation matrix for spherical harmonics
D = wignerd( multipole.base( obj.lmax ), rot );
%  allocate output
if ndims( D ) == 3,  obj = repelem( obj, 1, size( D, 3 ) );  end

for name = [ "aa", "ab", "ba", "bb" ]
for it = 1 : numel( obj )
  obj( it ).( name ) =   ...    
    conj( D( :, :, it ) ) * obj( it ).( name ) * transpose( D( :, :, it ) );
end
end
