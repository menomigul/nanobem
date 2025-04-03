function t = tmatellipsoid( mat1, mat2, diameter, ratio, k0, varargin )
%  TMATSPHERE - T-matrix for ellipsoids, Sommerville JQSRT 123, 153 (2013).
%
%  Usage :
%    t = multipole.tmatellipsoid( mat1, mat2, diameter, ratio, k0, PropertyPairs )
%  Input
%    mat1       :  material at ellipsoid inside
%    mat2       :  material at ellipsoid outside
%    diameter   :  diameter of ellipsoid
%    ratio      :  axis ratio
%    k0         :  wavenumber of light in vacuum
%  PropertyName
%    lmax       :  maximum number of spherical degrees
%    nquad      :  number of quadrature points
%  Output
%    t          :  T-matrix

%  set up solver for particles with symmetry of revolution
rad = @( t ) 0.5 * diameter * ratio ./   ...
                     sqrt( cos( t ) .^ 2 + ratio ^ 2 * sin( t ) .^ 2 );
pol = multipole.polsolver( mat1, mat2, rad, varargin{ : } );
%  evaluate T-matrices
t = arrayfun( @( k0 ) eval( pol, k0 ), k0, 'uniform', 1 );
