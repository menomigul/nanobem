function [ pos, rot, dt ] = brownianz( obj, pos, rot, ftot, ntot, dz )
%  BROWNIANT - Propagate particle in time using drift and diffusion.
%
%  Usage for obj = tweezer.fluidparticle :
%    pos = brownianz( obj, pos, rot, ftot, ntot, dz )
%  Input
%    pos      :  initial positions of particle
%    rot      :  initial rotation matrix for particle
%    ftot     :  total force acting on particle (pN)
%    ntot     :  total torque acting on particle (pN×nm)
%    dt       :  space increment
%  Output
%    pos      :  updated particle position
%    rot      :  updated rotation matrix
%    dt       :  time increment

%  drift velocity
[ vel, omega ] = drift( obj, rot, ftot, ntot );
%  diffusion increment
[ kb, nm ] = deal( 1.38e-23, 1e-9 );
fac = 2 * kb * obj.temp / ( obj.eta * nm );
u = sqrt( fac ) * randn( size( pos, 1 ), 6 ) * transpose( obj.B );
%  propgation distance increment w/o dt
zr = fun( rot, 'none', u( :, 1 : 3 ) );
zr = zr( :, 3 );

%  time increment
x = 0.5 ./ vel( :, 3 ) .* ( sqrt( zr .^ 2 + 4 * vel( :, 3 ) * dz ) - zr );
dt = x .^ 2;
%  update position
u = sqrt( dt ) .* u;
pos = pos + vel .* dt + fun( rot, 'none', u( :, 1 : 3 ) );
%  update rotation matrix
t = omega .* dt + fun( rot, 'none', u( :, 4 : 6 ) ); 
rot = pagemtimes( rotation( t ), rot );


function x = fun( rot, trans, x )
%  FUN - Rotate vector x.
x = pagemtimes( rot, trans, reshape( transpose( x ), 3, 1, [] ), 'none' );
x = transpose( squeeze( x ) );
