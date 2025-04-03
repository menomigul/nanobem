classdef rotation
  %  Rotation matrix using quaternions.
  
  properties
    q       %  quaternions for rotation matrix
  end  
  
  methods
    function obj = rotation( varargin )
      %  Initialize rotation matrix.
      %
      %  Usage :
      %    obj = tweezer.rotation( rot )
      %    obj = tweezer.rotation( 'quater', q )
      %  Input
      %    rot    :  rotation matrix
      %    q      :  quaternions
      obj = init( obj, varargin{ : } );
    end
  end
end
