function obj = init( obj, scatterer, fluid, varargin )
%  INIT - Initialize walker for spherical particle.
%
%  Usage for obj = tweezer.walkersphere :
%    obj = init( obj, scatterer, fluid, pos, vel, PropertyPairs )
%  Input
%    scatterer  :  optical force evaluator for spherical particle
%    fluid      :  Stokes drag for spherical particle
%    pos        :  walker positions

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'pos', [] );
%  parse input
parse( p, varargin{ : } );

%  save input
[ obj.scatterer, obj.fluid ] = deal( scatterer, fluid );
obj.pos = p.Results.pos;