function [ vel, omega ] = drift( obj, rot, ftot, ntot )
%  DRIFT - Drift velocity for given force and torque.
%
%  Usage for obj = tweezer.fluidparticle :
%    [ vel, omega ] = drift( obj, rot, ftot, ntot )
%  Input
%    rot      :  rotation matrix for particle
%    ftot     :  total force acting on particle (pN)
%    ntot     :  total torque acting on particle (pN×nm)
%  Output
%    vel      :  drift velocity for vanishing Reynolds number
%    omega    :  angular velocity

%  enlarge rotation matrix
rot = mat2cell( rot, 3, 3, ones( 1, size( rot, 3 ) ) );
rot = cellfun( @( x ) [ x, 0 * x; 0 * x, x ], rot, 'uniform', 0 );
rot = cat( 3, rot{ : } );
%  transform resistance tensor to laboratory frame
R = pagemtimes( rot, pagemtimes( obj.R, 'none', rot, 'transpose' ) ) / obj.eta;
%  steady state velocity (nm/s) and angular frequency (rad/s)
x = pagemtimes( R, 1e-12 * reshape( transpose( [ ftot, ntot ] ), 6, 1, [] ) );
vel = 1e9 * obj.vel * [ 0, 0, 1 ] + transpose( reshape( x( 1 : 3, : ), 3, [] ) );
omega = transpose( reshape( x( 4 : 6, : ), 3, [] ) );
