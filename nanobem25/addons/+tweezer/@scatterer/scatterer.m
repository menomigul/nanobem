classdef scatterer
  %  Optical T-matrix scatterer.
  
  properties
    tmat      %  T-matrix for scatterer
    qinc      %  multipole coefficients for incoming fields
  end  
  
  properties (Hidden)
    data      %  auxiliary data for optical force evaluation
  end
  
  methods
    function obj = scatterer( varargin )
      %  Initialize optical T-matrix scatterer.
      %
      %  Usage :
      %    obj = tweezer.scatterer( tmat, qinc, PropertyPairs )
      %  Input
      %    tmat       :  T-matrix for scatterer
      %    qinc       :  multipole coefficients for incoming fields
      obj = init( obj, varargin{ : } );
    end
  end
end
