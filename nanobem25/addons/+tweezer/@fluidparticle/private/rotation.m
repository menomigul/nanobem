function rot = rotation( w )
%  ROTATION - Rotation matrix for given angular velocity.

switch numel( w )
  case 3
    t = norm( w );
    [ u1, u2, u3 ] = deal( w( 1 ) / t, w( 2 ) / t, w( 3 ) / t );
  otherwise
    t = sqrt( dot( w, w, 2 ) );
    [ u1, u2, u3 ] = deal( w( :, 1 ) ./ t, w( :, 2 ) ./ t, w( :, 3 ) ./ t );
end

%  trigonometric functions
[ sint, cost ] = deal( sin( t ), cos( t ) );
%  allocate output
rot = zeros( 3, 3, numel( t ) );
%  rotation matrix
rot( 1, 1, : ) = u1 .* u1 .* ( 1 - cost ) + cost;
rot( 1, 2, : ) = u1 .* u2 .* ( 1 - cost ) - sint .* u3;
rot( 1, 3, : ) = u1 .* u3 .* ( 1 - cost ) + sint .* u2;

rot( 2, 1, : ) = u2 .* u1 .* ( 1 - cost ) + sint .* u3;
rot( 2, 2, : ) = u2 .* u2 .* ( 1 - cost ) + cost;
rot( 2, 3, : ) = u2 .* u3 .* ( 1 - cost ) - sint .* u1;

rot( 3, 1, : ) = u3 .* u1 .* ( 1 - cost ) - sint .* u2;
rot( 3, 2, : ) = u3 .* u2 .* ( 1 - cost ) + sint .* u1;
rot( 3, 3, : ) = u3 .* u3 .* ( 1 - cost ) + cost;
