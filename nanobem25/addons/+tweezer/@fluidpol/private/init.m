function obj = init( obj, drag, varargin )
%  INIT - Initialize Stokes drag for particle with polar symmetry in fluid.
%
%  Usage for obj = tweezer.fluidpol :
%    obj = init( obj, drag, vel )
%  Input
%    drag       :  diagonal components of drag tensor
%    vel        :  fluid velocity in z-direction (m/s)

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'vel', 0 );
%  parse input
parse( p, varargin{ : } );

obj.drag = drag;
obj.vel = p.Results.vel;
