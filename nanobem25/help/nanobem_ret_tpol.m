%% multipole.polsolver
%
% T-matrix solver for particles with symmetry of revolution. We use the
% approach described in (w/o the refined numerical integration)
%
% * W.R.C. Sommerville, B. Auguié and E.C. Le Ru, JQSRT 123, 153 (2013).
%
% The multipole.polsover object is initialized with

%  Initialize multipole.polsolver
%    mat1       -  material properties at sphere inside
%    mat2       -  material properties at sphere outside
%    rad        -  radius of particle as a function of polar angle   
%   'lmax'      -  maximum number of spherical degrees
%   'nquad'     -  number of quadrature points, 201 on default
pol = multipole.polsolver( mat1, mat2, pol );
pol = multipole.polsolver( mat1, mat2, pol, 'lmax', lmax, 'nquad', nquad );

%%
% For instance, for an ellipsoid with a given diameter and axis ratio the
% radius function can be defined through

%  radius for ellispsoid with given diameter and axis ratio
rad = @( t ) 0.5 * diameter * ratio ./ sqrt( cos( t ) .^ 2 + ratio ^ 2 * sin( t ) .^ 2 );

%%
% Once the _multipole.polsover_ is initialized, we can compute the
% corresponding T-matrix through

%  T-matrix for particle with symmetry of revolution
%    k0       -  wavenumber of light in vacuum
%    tmat     -  multipole.tmatrix object
tmat = eval( pol, k0 );

%%
%
% Copyright 2024 Ulrich Hohenester

