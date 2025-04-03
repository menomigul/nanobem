classdef gaussfocus
  %  Focused Gaussian with azimuthal polarization.
  
  properties
    mat       %  material properties of medium
    w0        %  waist in focus plane
    pow       %  laser power (W)
  end  
   
  methods
    function obj = gaussfocus( varargin )
      %  Initialize focused Gaussian with azimuthal polarization.
      %
      %  Usage :
      %    obj = gaussfocus( mat, PropertyPairs )
      %  Input
      %    mat    :  material properties of embedding medium
      %  PropertyName
      %    w0     :  beam waist in focal plane
      %    pow    :  laser power (W)
      obj = init( obj, varargin{ : } );  
    end
  
  end
end
