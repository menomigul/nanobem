function rot = eval( obj )
%  EVAL - Evaluate rotation matrix.
%
%  Usage for obj = tweezer.rotation :
%    rot = eval( obj )
%  Output
%    rot    :  rotation matrix

%  quaternions
switch size( obj.q, 1 )
  case 1
    q0 = obj.q( 1 );
    q1 = obj.q( 2 );
    q2 = obj.q( 3 );
    q3 = obj.q( 4 );
  otherwise
    q0 = obj.q( :, 1 );
    q1 = obj.q( :, 2 );
    q2 = obj.q( :, 3 );
    q3 = obj.q( :, 4 );
end
%  allocate output
rot = zeros( 3, 3, size( q0, 1 ) );
s = 1 ./ dot( obj.q, obj.q, 2 ); 

%  transform from quaternions to rotation matrix
%  https://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation
rot( 1, 1, : ) = 1 - 2 * ( q2 .^ 2 + q3 .^ 2 ) .* s;
rot( 1, 2, : ) =   2 * ( q1 .* q2 - q3 .* q0 ) .* s;
rot( 1, 3, : ) =   2 * ( q1 .* q3 + q2 .* q0 ) .* s;

rot( 2, 1, : ) =   2 * ( q2 .* q1 + q3 .* q0 ) .* s;
rot( 2, 2, : ) = 1 - 2 * ( q1 .^ 2 + q3 .^ 2 ) .* s;
rot( 2, 3, : ) =   2 * ( q2 .* q3 - q1 .* q0 ) .* s;

rot( 3, 1, : ) =   2 * ( q3 .* q1 - q2 .* q0 ) .* s;
rot( 3, 2, : ) =   2 * ( q3 .* q2 + q1 .* q0 ) .* s;
rot( 3, 3, : ) = 1 - 2 * ( q1 .^ 2 + q2 .^ 2 ) .* s;
