function [ pos, rot ] = browniant( obj, pos, rot, ftot, ntot, dt )
%  BROWNIANT - Propagate particle in time using drift and diffusion.
%
%  Usage for obj = tweezer.fluidpol :
%    pos = browniant( obj, pos, rot, ftot, ntot, dt )
%  Input
%    pos      :  initial positions of particle
%    rot      :  initial rotation matrix for particle
%    ftot     :  total force acting on particle (pN)
%    ntot     :  total torque acting on particle (pN×nm)
%    dt       :  time increment
%  Output
%    pos      :  updated particle position
%    rot      :  updated rotation matrix

%  drift velocity
[ vel, omega ] = drift( obj, rot, ftot, ntot );
%  diffusion coefficients
drag = obj.drag;
kb = 1.38e-23;
Dt = kb * obj.temp / obj.eta * ( - 1 ./ drag.tt ) * 1e27;
Dr = kb * obj.temp / obj.eta * ( - 1 ./ drag.rr ) * 1e27;
%  update position
w = sqrt( 2 * Dt * dt ) .* randn( size( pos ) );
pos = pos + vel * dt + fun( rot, 'none', w );
%  rotation matrix for angle increment
w = sqrt( 2 * Dr * dt ) .* randn( size( pos ) );
t = omega * dt + fun( rot, 'none', w ); 
%  update rotation matrix
rot = pagemtimes( rotation( t ), rot );


function x = fun( rot, trans, x )
%  FUN - Rotate vector x.
x = pagemtimes( rot, trans, reshape( transpose( x ), 3, 1, [] ), 'none' );
x = transpose( squeeze( x ) );
