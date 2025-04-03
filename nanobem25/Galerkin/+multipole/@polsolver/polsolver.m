classdef polsolver
  %  T-matrix solver for particles with symmetry of revolution.
  %  Sommerville, Auguié and Le Ru, JQSRT 123, 153 (2013).
  
  properties
    mat1      %  material at inside
    mat2      %  material at outside
    rad       %  radius of particle as a function of polar angle
    lmax      %  maximal angular degree 
    nquad     %  number of quadrature points
  end
  
  properties (Hidden)
    tab       %  table of angular degrees and orders
  end
  
  properties (Dependent, Hidden)
    embedding   %  material properties of embedding medium
    mat         %  material vector
  end     
  
    methods
    function obj = polsolver( varargin )
      %  Set up Mie solver.
      %
      %  Usage :
      %    obj = multipole.polsolver( mat1, mat2, rad, PropertyPair )
      %  Input
      %    mat1       :  material properties at sphere inside
      %    mat2       :  material properties at sphere outside
      %    rad        :  radius of particle as a function of polar angle 
      %  PropertyName
      %    lmax       :  maximum number of spherical degrees
      %    nquad      :  number of quadrature points
      obj = init( obj, varargin{ : } );
    end
    
    function x = get.embedding( obj )
      %  EMBEDDING - Material properties of embedding medium.
      x = obj.mat2;
    end    
    
    function x = get.mat( obj )
      %  MAT - Material properties.
      x = [ obj.mat2, obj.mat1 ];
    end        
  end
  
end