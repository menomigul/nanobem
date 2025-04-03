function obj = init( obj, mat1, mat2, rad, varargin )
%  INIT - Set up T-matrix solver for particles with symmetry of revolution.
%
%  Usage for obj = multipole.solver :
%    obj = init( obj, mat1, mat2, rad, PropertyPair )
%  Input
%    mat1   :  material properties at sphere inside
%    mat2   :  material properties at sphere outside
%    rad    :  maximal angular degree
%  PropertyName
%    lmax   :  maximum number of spherical degrees
%    nquad  :  number of quadrature points

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'lmax', 20 );
addParameter( p, 'nquad', 201 );
%  parse input
parse( p, varargin{ : } );

%  save input
[ obj.mat1, obj.mat2, obj.rad ] = deal( mat1, mat2, rad );
%  table of angular degrees and orders
base = multipole.base( p.Results.lmax );
obj.tab = base.tab;

%  maximum number of spherical degrees and number of quadrature points
obj.lmax = p.Results.lmax;
obj.nquad = p.Results.nquad;
