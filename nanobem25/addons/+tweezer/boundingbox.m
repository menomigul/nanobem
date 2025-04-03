classdef boundingbox
  %  Bounding box with periodic boundary conditions in xy-plane.
  
  properties
    limits        %  minimal and maximal values for bounding box
  end
  
  methods
    function obj = boundingbox( varargin )
      %  Initialize bounding box with periodic boundary conditions.
      %
      %  Usage :
      %   obj = tweezer.boundingbox( limits )
      %  Input
      %    limits   -   minimal and maximal values for bounding box
      obj.limits = deal( varargin{ : } );
    end
    
    function pos = periodic( obj, pos )
      %  PERIODIC - Apply periodic bounding box conditions to POS.
      for k = 1 : 2
        %  limits for Cartesian coordinate
        a = obj.limits( k, : );
        %  apply periodic boundary conditions at lower limit
        ind = pos( :, k ) < a( 1 );
        pos( ind, k ) = a( 2 ) - abs( pos( ind, k ) - a( 1 ) );
        %  apply periodic boundary conditions at upper limit
        ind = pos( :, k ) > a( 2 );
        pos( ind, k ) = a( 1 ) + abs( pos( ind, k ) - a( 2 ) );
      end
    end
    
    function pos = rand( obj, n, z )
      %  RAND - Random positions within bounding box.
      siz = obj.limits( :, 2 ) - obj.limits( :, 1 );
      pos = [ obj.limits( 1 ) + rand( n, 1 ) * siz( 1 ),  ...
              obj.limits( 2 ) + rand( n, 1 ) * siz( 2 ), zeros( n, 1 ) + z ];
    end
    
    function a = area( obj )
      %  AREA - Area of bounding box.
      a = prod( obj.limits( :, 2 ) - obj.limits( :, 1 ) );
    end
    
  end
end
