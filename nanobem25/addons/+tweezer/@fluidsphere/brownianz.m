function [ pos, dt ] = brownianz( obj, pos, ftot, dz )
%  BROWNIANT - Propagate particle in space using drift and diffusion.
%
%  Usage for obj = tweezer.fluidsphere :
%    [ pos, dt ] = brownianz( obj, pos, ftot, dz )
%  Input
%    pos      :  initial positions of particle
%    ftot     :  total force acting on particle (pN)
%    dz       :  space increment
%  Output
%    obj      :  array of walkers
%    dt       :  time increment

%  drift velocity
vel = drift( obj, ftot );
%  diffusion coefficient in nm^2/s
a = 0.5 * obj.diameter;
kb = 1.38e-23;
D = kb * obj.temp / ( 6 * pi * obj.eta * a ) * 1e27;

%  random variable and time increment
w = randn( size( pos ) );
zr = sqrt( 2 * D ) * w( :, 3 );
x = 0.5 ./ vel( :, 3 ) .* ( sqrt( zr .^ 2 + 4 * vel( :, 3 ) * dz ) - zr );
dt = x .^ 2;
%  propagate walkers
pos = pos + vel .* dt + sqrt( 2 * D * dt ) .* w;
  