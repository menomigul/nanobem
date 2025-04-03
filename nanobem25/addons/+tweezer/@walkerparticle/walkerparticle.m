classdef walkerparticle
  %  Walker for particle in fluid.
  
  properties
    scatterer     %  optical force evaluator for particle
    fluid         %  Stokes drag and diffusion for particle
    pos           %  walker positions
    rot           %  rotation matrix for particle
    vel           %  walker velocity
  end  
    
  methods
    function obj = walkerparticle( varargin )
      %  Initialize walker for particle with polar symmetry.
      %
      %  Usage :
      %    obj = tweezer.walkerparticle( scatterer, fluid, pos, PropertyPairs )
      %  Input
      %    scatterer  :  optical force evaluator for particle
      %    fluid      :  Stokes drag for particle
      %    pos        :  walker positions
      %    rot        :  rotation matrix for particle
      if ~isempty( varargin ),  obj = init( obj, varargin{ : } );  end
    end
  end
end
