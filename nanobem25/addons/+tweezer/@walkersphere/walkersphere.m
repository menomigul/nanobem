classdef walkersphere
  %  Walker for spherical particles.
  
  properties
    scatterer     %  optical force evaluator for spherical particle
    fluid         %  Stokes drag and diffusion for spherical particle
    pos           %  walker positions
    vel           %  walker velocity
  end  
  
  methods
    function obj = walkersphere( varargin )
      %  Initialize walker for spherical particle.
      %
      %  Usage :
      %    obj = tweezer.walkersphere( scatterer, fluid, pos, PropertyPairs )
      %  Input
      %    scatterer  :  optical force evaluator for spherical particle
      %    fluid      :  Stokes drag for spherical particle
      %    pos        :  walker positions
      if ~isempty( varargin ),  obj = init( obj, varargin{ : } );  end
    end
  end
end
