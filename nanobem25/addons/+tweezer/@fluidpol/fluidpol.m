classdef fluidpol
  %  Stokes drag and diffusion for particle with polar symmetry in fluid.
  
  properties
    drag            %  diagonal components of drag tensor
    vel             %  fluid velocity in z-direction
    eta = 9.544e-4  %  viscosity (Pa s)
    temp = 293      %  fluid temperature 
  end  
  
  methods
    function obj = fluidpol( varargin )
      %  Initialize Stokes drag for particle with polar symmetry in fluid.
      %
      %  Usage :
      %    obj = tweezer.fluidpol( drag, vel )
      %  Input
      %    drag   :  diagonal components of drag tensor
      %    vel    :  fluid velocity (m/s)
      obj = init( obj, varargin{ : } );
    end
  end
end
