%% multipole.miesolver
%
% Mie solver mainly for testing and visualization. The multipole.miesolver
% is initialized with

%  Initialize multipole.miesolver
%    mat1       -  material properties at sphere inside
%    mat2       -  material properties at sphere outside
%    diameter   -  diameter of sphere in nm    
%   'lmax'      -  maximum number of spherical degrees
mie = multipole.miesolver( mat1, mat2, diameter );
mie = multipole.miesolver( mat1, mat2, diameter, 'lmax', lmax );

%%
% We can then compute the T-matrix for the nanosphere with

%  T-matrix for nanosphere
%    k0       -  wavenumber of light in vacuum
%    tmat     -  multipole.tmatrix object
tmat = eval( mie, k0 );

%%
% For the inhomogeneities _q_ of incoming fields, to be computed with
% _multipole.incoming_, the electromagnetic fields at user-defined
% positions _pos_ inside and outside the sphere can be computed with

%  compute electromagnetic fields inside and outside oof sphere
%    q    -  inhomogeneities for incoming fields
%    pos  -  positions where fields are requested
[ e, h ] = fields( mie, q, pos );

%%
%
% Copyright 2024 Ulrich Hohenester

