function obj = init( obj, diameter, varargin )
%  INIT - Initialize Stokes drag for sphere in fluid.
%
%  Usage for obj = tweezer.fluidsphere :
%    obj = init( obj, diameter, vel )
%  Input
%    diameter   :  hydrodynamic diameter (nm)
%    vel        :  fluid velocity in z-direction (m/s)

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'vel', 0 );
%  parse input
parse( p, varargin{ : } );

obj.diameter = diameter;
obj.vel = p.Results.vel;
