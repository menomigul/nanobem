function t = tmatsphere( mat1, mat2, diameter, k0, varargin )
%  TMATSPHERE - T-matrix for sphere.
%
%  Usage :
%    t = multipole.tmatsphere( mat1, mat2, diameter, k0, PropertyPairs )
%  Input
%    mat1       :  material at sphere inside
%    mat2       :  material at sphere outside
%    diameter   :  diameter of sphere
%    k0         :  wavenumber of light in vacuum
%  PropertyName
%    lmax       :  maximum number of spherical degrees
%  Output
%    t          :  T-matrix

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'lmax', [] );
%  parse input
parse( p, varargin{ : } );

%  Wiscombe cutoff for angular degree ?
if isempty( p.Results.lmax )
  x = 0.5 * diameter * max( mat2.k( k0 ) );
  lmax = ceil( x + 2 + 4.05 * x ^ ( 1 / 3 ) );
else
  lmax = p.Results.lmax;
end

%  set up Mie solver
mie = multipole.miesolver( mat1, mat2, diameter, 'lmax', lmax );
%  evaluate T-matrices
t = arrayfun( @( k0 ) eval( mie, k0 ), k0, 'uniform', 1 );
