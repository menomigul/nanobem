classdef base
  %  Table of spherical degrees and orders
  
  properties
    tab     %  table of spherical degrees and orders
  end
  
  properties (Dependent)
    lmax    %  maximal degree for multipole expansion
  end
  
  methods 
    function obj = base( varargin )
      %  Initialize spherical degrees and orders.
      %
      %  Usage :
      %    obj = multipole.base( lmax )
      %  Input
      %    lmax     :  maximal degree for multipole expansion
      obj = init( obj, varargin{ : } );
    end
    
    function lmax = get.lmax( obj )
      %  LMAX - Maximal degree for multipole expansion.
      lmax = max( obj.tab.l );
    end
  end

end 
