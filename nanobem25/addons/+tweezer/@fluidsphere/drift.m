function vel = drift( obj, ftot )
%  DRIFT - Drift velocity for given force.
%
%  Usage for obj = tweezer.fluidsphere :
%    vel = drift( obj, ftot )
%  Input
%    ftot     :  total force acting on particle (pN)
%  Output
%    vel      :  drift velocity for vanishing Reynolds number

%  optical force (N)
ftot = 1e-12 * ftot;
%  radius of sphere (m)
a = 0.5e-9 * obj.diameter;
%  steady-state velocity, convert to nm/s
vel = ftot / ( 6 * pi * obj.eta * a ) + obj.vel * [ 0, 0, 1 ];
vel = 1e9 * vel;
