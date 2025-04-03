function obj = init( obj, drag, varargin )
%  INIT - Initialize Stokes drag for particle in fluid.
%
%  Usage for obj = tweezer.fluidparticle :
%    obj = init( obj, drag, vel )
%  Input
%    drag       :  drag tensor
%    vel        :  fluid velocity in z-direction (m/s)

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'vel', 0 );
%  parse input
parse( p, varargin{ : } );

obj.drag = drag;
obj.vel = p.Results.vel;

%  drag tensor, enforce symmetry
nm = 1e-9;
D = [ drag.tt, drag.tr; drag.rt, drag.rr ] * nm ^ 2;
D = 0.5 * ( D + D .' );
%  resistance tensor and square root thereof
obj.R = - inv( D );
obj.B = sqrtm( obj.R );
