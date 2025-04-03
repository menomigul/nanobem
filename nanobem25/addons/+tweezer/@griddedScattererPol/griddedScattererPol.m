classdef griddedScattererPol
  %  Gridded force interpolator for scatterer with polar symmetry.
  
  properties
    scatterer %  optical scatterer
    r         %  radii for interpolation
    z         %  z-values for interpolation
    f         %  grid for optical force
    n         %  grid for optical torque
    lmax      %  maximal order for azimuthal Fourier and multipole expansion
    fun       %  additional functions for gridding
  end
  
  properties (Hidden)
    method = 'cubic'    %  interpolation method
    extrapolation = 0   %  extrapolation method for grid
    ltab                %  table of spherical orders
    u                   %  azimuthal angles for grid
    pos                 %  grid positions
    tmat                %  rotated T-matrices
    data                %  grid for additional functions
  end
  
  methods 
    function obj = griddedScattererPol( varargin )
      %  Initialize gridded force interpolator for spherical scatterer.
      %
      %  Usage :
      %    obj = tweezer.griddedScattererPol( scatterer, r, PropertyPairs )
      %  Input
      %    scatterer    -  optical scatterer
      %    r            -  radii for interpolation
      %  PropertyName
      %    z            -  z-values for interpolation
      %    lmax         -  maximal orders for expansions
      %    fun          -  additional function for gridding
      obj = init( obj, varargin{ : } );
    end
  end
end
