function y = deriv( obj, w )
%  DERIV - Derivative of quaternions for given angular velocity.
%
%  Usage for obj = tweezer.rotation :
%    y = deriv( obj, w )
%  Input
%    w    :  angular velocity
%  Output
%    y    :  derivative of quaternions

%  quaternions and angular velocity components
switch size( obj.q, 1 )
  case 1
    q0 = obj.q( 1 );
    q1 = obj.q( 2 );  w1 = w( 1 );
    q2 = obj.q( 3 );  w2 = w( 2 );
    q3 = obj.q( 4 );  w3 = w( 3 );    
  otherwise
    q0 = obj.q( :, 1 );
    q1 = obj.q( :, 2 );  w1 = w( :, 1 );
    q2 = obj.q( :, 3 );  w2 = w( :, 2 );
    q3 = obj.q( :, 4 );  w3 = w( :, 3 );
end
%  derivative of quaternions, Eq. (16), correct signs
%  https://rotations.berkeley.edu/other-representations-of-a-rotation/
y = 0.5 * [ - q1 .* w1 - q2 .* w2 - q3 .* w3,  ...
              q0 .* w1 + q3 .* w2 - q2 .* w3,  ...
            - q3 .* w1 + q0 .* w2 + q1 .* w3,  ...
              q2 .* w1 - q1 .* w2 + q0 .* w3 ];          
