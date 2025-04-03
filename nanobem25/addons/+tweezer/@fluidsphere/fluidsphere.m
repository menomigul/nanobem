classdef fluidsphere
  %  Stokes drag and diffusion for sphere in fluid.
  
  properties
    diameter        %  hydrodynamic diameter
    vel             %  fluid velocity in z-direction
    eta = 9.544e-4  %  viscosity (Pa s)
    temp = 293      %  fluid temperature 
  end  
  
  methods
    function obj = fluidsphere( varargin )
      %  Initialize Stokes drag for sphere in fluid.
      %
      %  Usage :
      %    obj = tweezer.fluidsphere( diameter, vel )
      %  Input
      %    diameter   :  hydrodynamic diameter (nm)
      %    vel        :  fluid velocity (m/s)
      obj = init( obj, varargin{ : } );
    end
  end
end
