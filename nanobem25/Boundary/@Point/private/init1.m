function obj = init1( obj, mat, imat, pos )
%  INIT1 - Initialize point embedded in dielectric environment.
%
%  Usage for obj = Point :
%    obj = init1( obj, mat, imat, pos )
%  Input
%    mat    :  material parameters
%    imat   :  material index
%    pos    :  point position

if size( pos, 1 ) == 1
  [ obj.mat, obj.imat, obj.pos ] = deal( mat, imat, pos );
else
  %  allocate Point array
  n = size( pos, 1 );
  [ obj.mat, obj.imat ] = deal( mat, imat( 1 ) );
  obj = repelem( obj, 1, n );
  %  set positions and material index
  pos = mat2cell( pos, ones( 1, n ), 3 );
  [ obj.pos ] = deal( pos{ : } );
  if ~isscalar( imat )
    imat = num2cell( imat );
    [ obj.imat ] = deal( imat{ : } );
  end
end
 