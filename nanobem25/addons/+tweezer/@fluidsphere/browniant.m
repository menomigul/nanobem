function pos = browniant( obj, pos, ftot, dt )
%  BROWNIANT - Propagate particle in time using drift and diffusion.
%
%  Usage for obj = tweezer.fluidsphere :
%    pos = browniant( obj, pos, ftot, dt )
%  Input
%    pos      :  initial positions of particle
%    ftot     :  total force acting on particle (pN)
%    dt       :  time increment
%  Output
%    pos      :  updated particle position

%  drift velocity
vel = drift( obj, ftot );
%  diffusion coefficient
a = 0.5 * obj.diameter;
kb = 1.38e-23;
D = kb * obj.temp / ( 6 * pi * obj.eta * a ) * 1e27;
%  update particle position
pos = pos + vel * dt + sqrt( 2 * D * dt ) * randn( size( pos ) );
