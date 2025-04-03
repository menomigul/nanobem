classdef fluidparticle
  %  Stokes drag and diffusion for particle in fluid.
  
  properties
    drag            %  drag tensor
    vel             %  fluid velocity in z-direction
    eta = 9.544e-4  %  viscosity (Pa s)
    temp = 293      %  fluid temperature 
  end  
  
  properties (Hidden)
    R               %  resistance tensor
    B               %  diffusion tensor B*B'
  end
  
  methods
    function obj = fluidparticle( varargin )
      %  Initialize Stokes drag for particle in fluid.
      %
      %  Usage :
      %    obj = tweezer.fluidparticle( drag, vel )
      %  Input
      %    drag   :  drag tensor from tweezer.stokesdrag
      %    vel    :  fluid velocity (m/s)
      obj = init( obj, varargin{ : } );
    end
  end
end
