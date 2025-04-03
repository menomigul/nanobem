function obj = init( obj, scatterer, fluid, varargin )
%  INIT - Initialize walker for particle in fluid.
%
%  Usage for obj = tweezer.walkerparticle :
%    obj = init( obj, scatterer, fluid, pos, vel, PropertyPairs )
%  Input
%    scatterer  :  optical force evaluator for particle
%    fluid      :  Stokes drag for particle
%    pos        :  walker positions
%    vel        :  rotation matrix for particle

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'pos', [] );
addOptional( p, 'rot', [] );
%  parse input
parse( p, varargin{ : } );

%  save input
[ obj.scatterer, obj.fluid ] = deal( scatterer, fluid );
obj.pos = p.Results.pos;
obj.rot = p.Results.rot;
