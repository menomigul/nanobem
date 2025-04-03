classdef OPD
  %  Aberration due to optical path difference.  
  %    Refractive indices and thicknesses of the stratified medium must be
  %    given for optical axis in +z direction and ascending order of
  %    layers. We only account for the phase differences but not the
  %    slightly modified light propagation directions and field strengths.
  
  properties
    n         %  refractive indices for stratified medium of lens
    t         %  thicknesses for stratified medium of lens
    nstar     %  design refractive indices
    tstar     %  design thicknesses
  end
    
  methods
    function obj = OPD( varargin )
      %  Initialize abberation object.
      %
      %  Usage :
      %    obj = optics.OPD( n, t, nstar, tstar )
      %  Input
      %    n      :  refractive indices for stratified medium of lens
      %    t      :  thicknesses for stratified medium of lens
      %    nstar  :  design refractive indices
      %    tstar  :  design thicknesses
      obj = init( obj, varargin{ : } );
    end
  end  
end
