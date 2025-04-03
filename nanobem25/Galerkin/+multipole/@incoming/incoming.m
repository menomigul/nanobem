classdef incoming < multipole.base
  %  Multipole expansion of incoming fields.
  
  properties
    mat       %  material properties of embedding medium
    k0        %  wavenumber of light in vacuum    
    fun       %  incoming fields [e,h]=fun(pos,k0) 
    a         %  TM incoming coefficients
    b         %  TE incoming coefficients    
  end
  
  properties (Hidden)
    diameter  %  diameter for multipole expansion
  end
  
  methods 
    function obj = incoming( mat, k0, fun, varargin )
      %  Initialize multipole expansion for incoming fields.
      %
      %  Usage :
      %    obj = multipole.incoming( mat, k0, fun, PropertyPairs )
      %  Input
      %    mat        :  material properties of embedding medium
      %    k0         :  wavenumber of light in vacuum
      %    fun        :  incoming fields [e,h]=fun(pos,k0) 
      %  PropertyName
      %    lmax       :  maximum of spherical degrees
      %    diameter   :  diameter for multipole expansion
 
      %  set up parser
      p = inputParser;
      p.KeepUnmatched = true;
      addOptional( p, 'lmax', 10 );
      %  parse input
      parse( p, varargin{ : } );      
      
      obj = obj@multipole.base( p.Results.lmax );
      obj = init( obj, mat, k0, fun, varargin{ : } );
    end
    
    function varargout = subsref( obj, s )
      %  Evaluate multipole.incoming object.
      switch s( 1 ).type
        case '()'
          [ varargout{ 1 : nargout } ] = eval( obj, s( 1 ).subs{ : } );
        otherwise
          [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );
      end
    end
 
  end
end 
