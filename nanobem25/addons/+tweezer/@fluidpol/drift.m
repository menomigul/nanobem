function [ vel, omega ] = drift( obj, rot, ftot, ntot )
%  DRIFT - Drift velocity for given force and torque.
%
%  Usage for obj = tweezer.fluidpol :
%    [ vel, omega ] = drift( obj, rot, ftot, ntot )
%  Input
%    rot      :  rotation matrix for particle
%    ftot     :  total force acting on particle (pN)
%    ntot     :  total torque acting on particle (pN×nm)
%  Output
%    vel      :  drift velocity for vanishing Reynolds number
%    omega    :  angular velocity

%  optical force (N) and torque (N×m)
nm = 1e-9;
ftot = 1e-12 * ftot;
ntot = 1e-12 * nm * ntot;
%  inverse drag tensor for translation and rotation in particle frame
drag = obj.drag;
Dt = diag( 1 ./ ( drag.tt * nm     ) ) / obj.eta;
Dr = diag( 1 ./ ( drag.rr * nm ^ 3 ) ) / obj.eta;
%  transform to laboratory frame
Dt = pagemtimes( rot, pagemtimes( Dt, 'none', rot, 'transpose' ) );
Dr = pagemtimes( rot, pagemtimes( Dr, 'none', rot, 'transpose' ) );

%  steady state velocity
vel = pagemtimes( Dt, reshape( transpose( ftot ), 3, 1, [] ) );
vel = obj.vel * [ 0, 0, 1 ] - transpose( reshape( vel, 3, [] ) );
%  convert velocity to nm/s
vel = vel / nm;
%  steady-state angular frequency in rad/s
omega = pagemtimes( Dr, reshape( transpose( ntot ), 3, 1, [] ) );
omega = - transpose( reshape( omega, 3, [] ) );
