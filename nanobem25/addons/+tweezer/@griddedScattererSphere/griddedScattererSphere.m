classdef griddedScattererSphere
  %  Gridded force interpolator for spherical scatterer.
  
  properties
    scatterer %  optical scatterer
    r         %  radii for interpolation
    z         %  z-values for interpolation
    f         %  grid for optical force
    lmax      %  maximal order for azimuthal Fourier expansion  
    fun       %  additional functions for gridding
  end
  
  properties (Hidden)
    method = 'cubic'    %  interpolation method
    extrapolation = 0   %  extrapolation method for grid
    ltab                %  table of spherical orders
    u                   %  azimuthal angles for grid
    pos                 %  grid positions
    data                %  grid for additional functions
  end
  
  methods 
    function obj = griddedScattererSphere( varargin )
      %  Initialize gridded force interpolator for spherical scatterer.
      %
      %  Usage :
      %    obj = tweezer.griddedScattererSphere( scatterer, r, PropertyPairs )
      %  Input
      %    scatterer    -  optical scatterer
      %    r            -  radii for interpolation
      %  PropertyName
      %    z            -  z-values for interpolation
      %    lmax         -  maximal order for azimuthal Fourier expansion
      %    fun          -  additional function for gridding
      obj = init( obj, varargin{ : } );
    end
  end
end
